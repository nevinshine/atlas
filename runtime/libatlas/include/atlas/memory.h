#ifndef ATLAS_MEMORY_H
#define ATLAS_MEMORY_H

#include <stddef.h>

void *mmap(void *addr, size_t length, int prot, int flags, int fd, long offset);
int munmap(void *addr, size_t length);
int mprotect(void *addr, size_t len, int prot);
int brk(void *addr);
void *sbrk(long increment);

void *atlas_malloc(size_t size);
void atlas_free(void *ptr);
void *atlas_calloc(size_t nmemb, size_t size);
void *atlas_realloc(void *ptr, size_t size);

#endif
