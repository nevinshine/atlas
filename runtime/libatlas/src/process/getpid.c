#include "atlas/syscall.h"
#include "atlas/sysnums.h"

extern int errno;

int getpid(void) {
    long r = __atlas_syscall0(ATLAS_SYS_GETPID);
    if (r < 0) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
