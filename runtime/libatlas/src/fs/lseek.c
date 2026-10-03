#include <atlas/syscall.h>
#include <atlas/sysnums.h>
#include <atlas/errno.h>

long lseek(int fd, long offset, int whence) {
    long r = __atlas_syscall3(ATLAS_SYS_LSEEK, (long)fd, (long)offset, (long)whence);
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return -1;
    }
    return r;
}
