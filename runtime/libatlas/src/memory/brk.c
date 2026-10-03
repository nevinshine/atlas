#include <atlas/syscall.h>
#include <atlas/sysnums.h>
#include <atlas/errno.h>

int brk(void *addr) {
    long r = __atlas_syscall1(ATLAS_SYS_BRK, (long)addr);
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return -1;
    }
    return 0;
}

void *sbrk(long increment) {
    long current_brk = __atlas_syscall1(ATLAS_SYS_BRK, 0);
    if ((unsigned long)current_brk > (unsigned long)-4096) {
        errno = -current_brk;
        return (void *)-1;
    }
    
    if (increment == 0) {
        return (void *)current_brk;
    }
    
    long new_brk = current_brk + increment;
    long r = __atlas_syscall1(ATLAS_SYS_BRK, new_brk);
    if ((unsigned long)r > (unsigned long)-4096) {
        errno = -r;
        return (void *)-1;
    }
    
    return (void *)current_brk;
}
