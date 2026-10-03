#include <atlas/syscall.h>
#include <atlas/sysnums.h>
#include <atlas/errno.h>

int close(int fd) {
    long r = __atlas_syscall1(ATLAS_SYS_CLOSE, (long)fd);
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
