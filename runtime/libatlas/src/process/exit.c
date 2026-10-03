#include "atlas/syscall.h"
#include "atlas/sysnums.h"

void _exit(int status) {
    __atlas_syscall1(ATLAS_SYS_EXIT, status);
    while (1) {}
}
