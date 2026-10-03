#ifndef _LIBC_STDLIB_H
#define _LIBC_STDLIB_H

#include <stddef.h>

int abs(int j);
int atoi(const char *nptr);
long strtol(const char *nptr, char **endptr, int base);
void abort(void);

extern char **environ;
char *getenv(const char *name);
int setenv(const char *name, const char *value, int overwrite);
int unsetenv(const char *name);
int putenv(char *string);

int atexit(void (*func)(void));
void exit(int status);

void *malloc(size_t size);
void free(void *ptr);
void *calloc(size_t nmemb, size_t size);
void *realloc(void *ptr, size_t size);
void *aligned_alloc(size_t alignment, size_t size);

#endif
