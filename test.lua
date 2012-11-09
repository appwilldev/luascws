#!/usr/bin/env luajit

local scws = require('scws')

local dictpath = '/home/lilydjwg/workspace/indexd/data/dict.utf8.xdb'
local f = scws:new(dictpath)
local r = f('测试分词效果如何，貌似很不错的样子呢。Oh yeah~LuaJIT 很好很强大！')
for _, s in ipairs(r) do
  io.stdout:write(s .. ' ')
end
print()
