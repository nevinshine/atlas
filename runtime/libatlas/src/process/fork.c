#include "atlas/syscall.h"
#include "atlas/sysnums.h"

extern int errno;

int fork(void) {
    long r = __atlas_syscall0(ATLAS_SYS_FORK);
    if (r < 0) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
