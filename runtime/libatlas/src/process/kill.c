#include "atlas/syscall.h"
#include "atlas/sysnums.h"

extern int errno;

int kill(int pid, int sig) {
    long r = __atlas_syscall2(ATLAS_SYS_KILL, (long)pid, (long)sig);
    if (r < 0) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
