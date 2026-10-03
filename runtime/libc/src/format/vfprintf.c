#include "format_internal.h"
#include <stdio.h>

static void file_write_cb(const char *str, size_t len, void *ctx) {
    FILE *f = (FILE *)ctx;
    fwrite(str, 1, len, f);
}

int vfprintf(FILE *stream, const char *format, va_list ap) {
    if (!stream) return -1;
    
    format_target_t target;
    target.write = file_write_cb;
    target.ctx = stream;
    
    return __vformat(&target, format, ap);
}
