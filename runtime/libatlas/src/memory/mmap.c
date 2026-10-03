#include <atlas/syscall.h>
#include <atlas/sysnums.h>
#include <atlas/errno.h>
#include <stddef.h>

void *mmap(void *addr, size_t length, int prot, int flags, int fd, long offset) {
    long r = __atlas_syscall6(ATLAS_SYS_MMAP, (long)addr, (long)length, (long)prot, (long)flags, (long)fd, offset);
    // On Linux/x86_64, mmap can return addresses that look like negative error codes
    // if we just check r < 0. Specifically, any return value between -4095 and -1 is an error.
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return (void *)-1;
    }
    return (void *)r;
}
