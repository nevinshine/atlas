#ifndef ATLAS_UACCESS_H
#define ATLAS_UACCESS_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>
#include "kernel/scheduler/process.h"

// Verify that [ptr, ptr+size) is entirely within the mapped user address space
// and has the required permissions (write = true requires writable pages)
bool user_ptr_valid(const void *ptr, size_t size, bool write);

// Copy memory from user space to kernel space safely
// Returns 0 on success, or -1 on invalid access
int copy_from_user(void *dest, const void *src, size_t size);

// Copy memory from kernel space to user space safely
// Returns 0 on success, or -1 on invalid access
int copy_to_user(void *dest, const void *src, size_t size);

#endif /* ATLAS_UACCESS_H */
