#include "format_internal.h"
#include <stdio.h>
#include <memory.h>

typedef struct {
    char *buf;
    size_t size;
    size_t pos;
} mem_ctx_t;

static void mem_write_cb(const char *str, size_t len, void *ctx) {
    mem_ctx_t *m = (mem_ctx_t *)ctx;
    
    if (m->pos < m->size) {
        size_t space = m->size - m->pos;
        size_t to_copy = (len < space) ? len : space;
        
        if (to_copy > 0) {
            memcpy(m->buf + m->pos, str, to_copy);
            m->pos += to_copy;
        }
    }
}

int vsnprintf(char *str, size_t size, const char *format, va_list ap) {
    mem_ctx_t m;
    m.buf = str;
    m.size = size > 0 ? size - 1 : 0; // reserve space for null terminator
    m.pos = 0;
    
    format_target_t target;
    target.write = mem_write_cb;
    target.ctx = &m;
    
    int ret = __vformat(&target, format, ap);
    
    if (size > 0 && str) {
        str[m.pos] = '\0';
    }
    
    return ret;
}
