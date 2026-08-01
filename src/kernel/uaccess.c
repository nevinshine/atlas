#include "kernel/uaccess.h"
#include "lib/memory.h"

bool user_ptr_valid(const void *ptr, size_t size) {
    uintptr_t start = (uintptr_t)ptr;
    uintptr_t end = start + size;

    if (start > end) { // overflow
        return false;
    }

    // In a higher-half kernel, user space is anything below 0xC0000000.
    if (end > 0xC0000000) {
        return false;
    }

    return true;
}

int copy_from_user(void *dest, const void *src, size_t size) {
    if (!user_ptr_valid(src, size)) {
        return -1;
    }
    memcpy(dest, src, size);
    return 0;
}

int copy_to_user(void *dest, const void *src, size_t size) {
    if (!user_ptr_valid(dest, size)) {
        return -1;
    }
    memcpy(dest, src, size);
    return 0;
}
