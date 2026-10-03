#ifndef _LIBC_FORMAT_INTERNAL_H
#define _LIBC_FORMAT_INTERNAL_H

#include <stdarg.h>
#include <stddef.h>

typedef struct {
    void (*write)(const char *str, size_t len, void *ctx);
    void *ctx;
    size_t written;
} format_target_t;

int __vformat(format_target_t *target, const char *format, va_list ap);

#endif
