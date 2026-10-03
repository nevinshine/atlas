#include "atlas/syscall.h"
#include "atlas/sysnums.h"
#include <stddef.h>

extern int errno;

// Linux implements waitpid via wait4 syscall
// int wait4(pid_t pid, int *wstatus, int options, struct rusage *rusage);
int waitpid(int pid, int *wstatus, int options) {
    long r = __atlas_syscall4(ATLAS_SYS_WAIT4, (long)pid, (long)wstatus, (long)options, 0);
    if (r < 0) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
