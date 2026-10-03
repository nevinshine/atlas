#include <atlas/syscall.h>
#include <atlas/sysnums.h>
#include <atlas/errno.h>
#include <stddef.h>

int mprotect(void *addr, size_t len, int prot) {
    long r = __atlas_syscall3(ATLAS_SYS_MPROTECT, (long)addr, (long)len, (long)prot);
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
