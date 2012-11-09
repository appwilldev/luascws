#!/usr/bin/env luajit

local ffi = require("ffi")
local io_open = io.open
local setmetatable = setmetatable
local error = error
local t_insert = table.insert
local strsub = string.sub
require('scws_header')

-- debug
local print = print

module("scws")

local scws = {}

scws.XDICT_XDB = 1
scws.XDICT_MEM = 2
scws.XDICT_TXT = 4

local S = ffi.load('scws')

function scws:new(dict, rules, charset, dicttype)
  local o = {}
  if not charset then
    charset = 'utf-8'
  end
  if not dicttype then
    dicttype = scws.XDICT_XDB
  end
  local s = ffi.gc(S.scws_new(), S.scws_free)
  S.scws_set_charset(s, charset)
  local st = S.scws_set_dict(s, dict, dicttype)
  if st < 0 then
    error('failed to set dict')
  end
  if rules then
    S.scws_set_rule(s, rules)
  end

  o._scws = s
  setmetatable(o, self)
  self.__index = self
  return o
end

function scws:__call(sentence)
  local s = self._scws
  if not s then
    error("can't find myself, sorry.")
  end
  S.scws_send_text(s, sentence, #sentence);
  local ret = {}
  while true do
    local result = S.scws_get_result(s)
    if result == nil then break end
    local cursor = result
    while cursor ~= nil do
      local o = strsub(sentence, cursor.off+1, cursor.off + cursor.len)
      t_insert(ret, o)
      cursor = cursor.next
    end
    S.scws_free_result(result)
  end
  return ret
end

return scws
