#include <atlas/syscall.h>
#include <atlas/sysnums.h>
#include <atlas/errno.h>
#include <stddef.h>

int munmap(void *addr, size_t length) {
    long r = __atlas_syscall2(ATLAS_SYS_MUNMAP, (long)addr, (long)length);
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
