#include <stdlib.h>
#include <atlas/memory.h>

void *malloc(size_t size) {
    return atlas_malloc(size);
}

void free(void *ptr) {
    atlas_free(ptr);
}

void *calloc(size_t nmemb, size_t size) {
    return atlas_calloc(nmemb, size);
}

void *realloc(void *ptr, size_t size) {
    return atlas_realloc(ptr, size);
}
