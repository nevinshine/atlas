#ifndef ATLAS_SYSCALL_H
#define ATLAS_SYSCALL_H

#include <stdint.h>
#include "kernel/interrupts.h"

// Basic System Calls
#define SYS_EXIT  0
#define SYS_WRITE 1
#define SYS_YIELD 2
#define SYS_OPEN  3
#define SYS_READ  4
#define SYS_CLOSE 5
#define SYS_IOCTL 6
#define SYS_LSEEK 7
#define SYS_MMAP  8
#define SYS_MPROTECT 9
#define SYS_MUNMAP 10
#define SYS_WAITPID 11
#define SYS_FORK 12
#define SYS_EXECVE 13
#define SYS_FUTEX 18
#define SYS_PIPE 19
#define SYS_DUP 20
#define SYS_DUP2 21
#define SYS_SOCKET 22
#define SYS_BIND 23
#define SYS_SENDTO 24
#define SYS_RECVFROM 25

typedef int (*syscall_fn)(registers_t *);

void syscall_init(void);
void register_syscall(uint32_t num, syscall_fn handler);

#endif
