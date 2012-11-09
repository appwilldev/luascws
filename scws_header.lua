local ffi = require("ffi")

ffi.cdef[[
struct pheap
{
 int size;
 int used;
 char block[0];
};

struct pclean
{
 void *obj;
 struct pclean *nxt;
};

typedef struct
{
 int size;
 int dirty;
 struct pheap *heap;
 struct pclean *clean;
} pool_st, *pool_t;


pool_t pool_new();
void pool_free(pool_t p);
void *pmalloc(pool_t p, int size);
void *pmalloc_x(pool_t p, int size, char c);
void *pmalloc_z(pool_t p, int size);
char *pstrdup(pool_t p, const char *s);
char *pstrndup(pool_t p, const char *s, int l);


typedef struct tree_node node_st, *node_t;
struct tree_node
{
 char *key;
 void *value;
 int vlen;
 node_t left;
 node_t right;
};

typedef struct
{
 pool_t p;
 int base;
 int prime;
 int count;
 node_t *trees;
} xtree_st, *xtree_t;


int xtree_hasher(xtree_t xt, const char *key, int len);
xtree_t xtree_new(int base, int prime);
void xtree_free(xtree_t xt);

void xtree_put(xtree_t xt, const char *value, const char *key);
void xtree_nput(xtree_t xt, void *value, int vlen, const char *key, int len);

void *xtree_get(xtree_t xt, const char *key, int *vlen);
void *xtree_nget(xtree_t xt, const char *key, int len, int *vlen);
void xtree_optimize(xtree_t xt);
void xtree_to_xdb(xtree_t xt, const char *fpath);
typedef struct scws_rule_item
{
 short flag;
 char zmin;
 char zmax;
 char name[17];
 char attr[3];
 float tf;
 float idf;
 unsigned int bit;
 unsigned int inc;
 unsigned int exc;
} *rule_item_t;


typedef struct scws_rule_attr *rule_attr_t;
struct scws_rule_attr
{
 char attr1[2];
 char attr2[2];
 unsigned char npath[2];
 short ratio;
 rule_attr_t next;
};

typedef struct scws_rule
{
 xtree_t tree;
 rule_attr_t attr;
 struct scws_rule_item items[32];
} rule_st, *rule_t;




rule_t scws_rule_new(const char *fpath, unsigned char *mblen);


void scws_rule_free(rule_t r);


rule_item_t scws_rule_get(rule_t r, const char *str, int len);


int scws_rule_checkbit(rule_t r, const char *str, int len, unsigned int bit);


int scws_rule_attr_ratio(rule_t r, const char *attr1, const char *attr2, const unsigned char *npath);


int scws_rule_check(rule_t r, rule_item_t cr, const char *str, int len);
typedef struct scws_word
{
 float tf;
 float idf;
 unsigned char flag;
 char attr[3];
} word_st, *word_t;

typedef struct scws_xdict
{
 void *xdict;
 int xmode;
 struct scws_xdict *next;
} xdict_st, *xdict_t;


xdict_t xdict_open(const char *fpath, int mode);
void xdict_close(xdict_t xd);


xdict_t xdict_add(xdict_t xd, const char *fpath, int mode, unsigned char *ml);


word_t xdict_query(xdict_t xd, const char *key, int len);
typedef struct scws_result *scws_res_t;
struct scws_result
{
 int off;
 float idf;
 unsigned char len;
 char attr[3];
 scws_res_t next;
};

typedef struct scws_topword *scws_top_t;
struct scws_topword
{
 char *word;
 float weight;
 short times;
 char attr[2];
 scws_top_t next;
};

struct scws_zchar
{
 int start;
 int end;
};

typedef struct scws_st scws_st, *scws_t;
struct scws_st
{

 scws_t p;
 xdict_t d;
 rule_t r;
 unsigned char *mblen;
 unsigned int mode;
 unsigned char *txt;
 int zis;
 int len;
 int off;
 int wend;
 scws_res_t res0;
 scws_res_t res1;
 word_t **wmap;
 struct scws_zchar *zmap;
};


scws_t scws_new();
void scws_free(scws_t s);

scws_t scws_fork(scws_t s);


int scws_add_dict(scws_t s, const char *fpath, int mode);
int scws_set_dict(scws_t s, const char *fpath, int mode);
void scws_set_charset(scws_t s, const char *cs);
void scws_set_rule(scws_t s, const char *fpath);


void scws_set_ignore(scws_t s, int yes);
void scws_set_multi(scws_t s, int mode);
void scws_set_debug(scws_t s, int yes);
void scws_set_duality(scws_t s, int yes);

void scws_send_text(scws_t s, const char *text, int len);
scws_res_t scws_get_result(scws_t s);
void scws_free_result(scws_res_t result);

scws_top_t scws_get_tops(scws_t s, int limit, char *xattr);
void scws_free_tops(scws_top_t tops);

scws_top_t scws_get_words(scws_t s, char *xattr);
int scws_has_word(scws_t s, char *xattr);
]]
