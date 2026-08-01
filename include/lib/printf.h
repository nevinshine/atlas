#ifndef ATLAS_PRINTF_H
#define ATLAS_PRINTF_H

#include <stdarg.h>

int printf(const char *format, ...);
int sprintf(char *str, const char *format, ...);
int vsprintf(char *str, const char *format, va_list args);

#endif
