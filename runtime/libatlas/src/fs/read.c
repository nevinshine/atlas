#include <atlas/syscall.h>
#include <atlas/sysnums.h>
#include <atlas/errno.h>
#include <stddef.h>

long read(int fd, void *buf, size_t count) {
    long r = __atlas_syscall3(ATLAS_SYS_READ, (long)fd, (long)buf, (long)count);
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return -1;
    }
    return r;
}
