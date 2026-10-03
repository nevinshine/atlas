#include "atlas/syscall.h"
#include "atlas/sysnums.h"

extern int errno;

int execve(const char *pathname, char *const argv[], char *const envp[]) {
    long r = __atlas_syscall3(ATLAS_SYS_EXECVE, (long)pathname, (long)argv, (long)envp);
    if (r < 0) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
