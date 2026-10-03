#ifndef _LIBC_STDIO_H
#define _LIBC_STDIO_H

#include <stddef.h>

#define EOF (-1)

typedef struct FILE FILE;

extern FILE *stdin;
extern FILE *stdout;
extern FILE *stderr;

FILE *fopen(const char *pathname, const char *mode);
int fclose(FILE *stream);
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
int fflush(FILE *stream);

int fgetc(FILE *stream);
int getc(FILE *stream);
int fputc(int c, FILE *stream);
int putc(int c, FILE *stream);

int feof(FILE *stream);
int ferror(FILE *stream);
void clearerr(FILE *stream);

char *fgets(char *s, int size, FILE *stream);
int fputs(const char *s, FILE *stream);

#include <stdarg.h>

int printf(const char *format, ...);
int fprintf(FILE *stream, const char *format, ...);
int snprintf(char *str, size_t size, const char *format, ...);

int vprintf(const char *format, va_list ap);
int vfprintf(FILE *stream, const char *format, va_list ap);
int vsnprintf(char *str, size_t size, const char *format, va_list ap);

#endif
