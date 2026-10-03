#include "format_internal.h"
#include <string.h>

static void print_int(format_target_t *target, unsigned int v, int base, int is_signed, int uppercase) {
    char buf[32];
    int pos = 0;
    
    unsigned int val = v;
    int is_neg = 0;
    
    if (is_signed) {
        int sv = (int)v;
        if (sv < 0) {
            is_neg = 1;
            val = (unsigned int)(-sv);
        }
    }
    
    if (val == 0) {
        buf[pos++] = '0';
    } else {
        while (val > 0) {
            int rem = val % base;
            if (rem < 10) {
                buf[pos++] = '0' + rem;
            } else {
                buf[pos++] = (uppercase ? 'A' : 'a') + (rem - 10);
            }
            val /= base;
        }
    }
    
    if (is_neg) {
        buf[pos++] = '-';
    }
    
    // reverse buf
    for (int i = 0; i < pos / 2; i++) {
        char t = buf[i];
        buf[i] = buf[pos - 1 - i];
        buf[pos - 1 - i] = t;
    }
    
    target->write(buf, pos, target->ctx);
    target->written += pos;
}

static void print_ptr(format_target_t *target, unsigned long long v) {
    char buf[64];
    int pos = 0;
    
    if (v == 0) {
        target->write("(nil)", 5, target->ctx);
        target->written += 5;
        return;
    }
    
    while (v > 0) {
        int rem = v % 16;
        if (rem < 10) {
            buf[pos++] = '0' + rem;
        } else {
            buf[pos++] = 'a' + (rem - 10);
        }
        v /= 16;
    }
    
    buf[pos++] = 'x';
    buf[pos++] = '0';
    
    // reverse buf
    for (int i = 0; i < pos / 2; i++) {
        char t = buf[i];
        buf[i] = buf[pos - 1 - i];
        buf[pos - 1 - i] = t;
    }
    
    target->write(buf, pos, target->ctx);
    target->written += pos;
}

int __vformat(format_target_t *target, const char *format, va_list ap) {
    target->written = 0;
    
    const char *p = format;
    while (*p) {
        if (*p != '%') {
            const char *start = p;
            while (*p && *p != '%') p++;
            target->write(start, p - start, target->ctx);
            target->written += (p - start);
        } else {
            p++;
            if (*p == '\0') break;
            
            switch (*p) {
                case 'd':
                case 'i':
                    print_int(target, va_arg(ap, int), 10, 1, 0);
                    break;
                case 'u':
                    print_int(target, va_arg(ap, unsigned int), 10, 0, 0);
                    break;
                case 'x':
                    print_int(target, va_arg(ap, unsigned int), 16, 0, 0);
                    break;
                case 'X':
                    print_int(target, va_arg(ap, unsigned int), 16, 0, 1);
                    break;
                case 'c': {
                    char c = (char)va_arg(ap, int);
                    target->write(&c, 1, target->ctx);
                    target->written += 1;
                    break;
                }
                case 's': {
                    const char *s = va_arg(ap, const char *);
                    if (!s) s = "(null)";
                    size_t len = strlen(s);
                    target->write(s, len, target->ctx);
                    target->written += len;
                    break;
                }
                case 'p':
                    print_ptr(target, (unsigned long long)va_arg(ap, void *));
                    break;
                case '%':
                    target->write("%", 1, target->ctx);
                    target->written += 1;
                    break;
                default:
                    // unknown format, just print it literally
                    target->write("%", 1, target->ctx);
                    target->write(p, 1, target->ctx);
                    target->written += 2;
                    break;
            }
            p++;
        }
    }
    
    return target->written;
}
