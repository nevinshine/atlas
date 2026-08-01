#include "lib/printf.h"
#include "lib/string.h"
#include "drivers/console.h"
#include <stdarg.h>
#include <stdint.h>

static void itoa(unsigned int value, char *str, int base) {
    char *ptr = str, *ptr1 = str, tmp_char;
    int tmp_value;
    if (value == 0) {
        *ptr++ = '0';
        *ptr = '\0';
        return;
    }
    while (value > 0) {
        tmp_value = value % base;
        *ptr++ = "0123456789abcdef"[tmp_value];
        value /= base;
    }
    *ptr = '\0';
    ptr--;
    while (ptr1 < ptr) {
        tmp_char = *ptr;
        *ptr-- = *ptr1;
        *ptr1++ = tmp_char;
    }
}

int vsprintf(char *str, const char *format, va_list args) {
    int count = 0;
    while (*format) {
        if (*format == '%') {
            format++;
            if (*format == 'd') {
                int val = va_arg(args, int);
                char buf[32];
                if (val < 0) {
                    str[count++] = '-';
                    val = -val;
                }
                itoa(val, buf, 10);
                for (int i = 0; buf[i]; i++) str[count++] = buf[i];
            } else if (*format == 'u') {
                unsigned int val = va_arg(args, unsigned int);
                char buf[32];
                itoa(val, buf, 10);
                for (int i = 0; buf[i]; i++) str[count++] = buf[i];
            } else if (*format == 'x') {
                unsigned int val = va_arg(args, unsigned int);
                char buf[32];
                itoa(val, buf, 16);
                for (int i = 0; buf[i]; i++) str[count++] = buf[i];
            } else if (*format == 's') {
                char *s = va_arg(args, char*);
                if (!s) s = "(null)";
                while (*s) str[count++] = *s++;
            } else if (*format == 'c') {
                str[count++] = (char)va_arg(args, int);
            } else if (*format == '%') {
                str[count++] = '%';
            }
        } else {
            str[count++] = *format;
        }
        format++;
    }
    str[count] = '\0';
    return count;
}

int sprintf(char *str, const char *format, ...) {
    va_list args;
    va_start(args, format);
    int ret = vsprintf(str, format, args);
    va_end(args);
    return ret;
}

int printf(const char *format, ...) {
    char buf[1024];
    va_list args;
    va_start(args, format);
    int ret = vsprintf(buf, format, args);
    va_end(args);
    console_puts(buf);
    return ret;
}
