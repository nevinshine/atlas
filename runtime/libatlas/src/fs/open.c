#include <atlas/syscall.h>
#include <atlas/sysnums.h>
#include <atlas/errno.h>
#include <stdarg.h>

int open(const char *pathname, int flags, ...) {
    int mode = 0;
    if (flags & 0x40) { // O_CREAT
        va_list args;
        va_start(args, flags);
        mode = va_arg(args, int);
        va_end(args);
    }
    long r = __atlas_syscall3(ATLAS_SYS_OPEN, (long)pathname, (long)flags, (long)mode);
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return -1;
    }
    return (int)r;
}
