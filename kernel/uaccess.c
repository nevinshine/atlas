#include "kernel/uaccess.h"
#include "lib/memory.h"
#include "kernel/vmm.h"

bool user_ptr_valid(const void *ptr, size_t size, bool write) {
    return vmm_check_user_access((uint32_t)ptr, size, write);
}

int copy_from_user(void *dest, const void *src, size_t size) {
    if (!user_ptr_valid(src, size, false)) {
        return -1;
    }
    memcpy(dest, src, size);
    return 0;
}

int copy_to_user(void *dest, const void *src, size_t size) {
    if (!user_ptr_valid(dest, size, true)) {
        return -1;
    }
    memcpy(dest, src, size);
    return 0;
}
