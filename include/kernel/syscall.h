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

typedef int (*syscall_fn)(registers_t *);

void syscall_init(void);
void register_syscall(uint32_t num, syscall_fn handler);

#endif
