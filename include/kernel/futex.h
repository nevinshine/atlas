#ifndef ATLAS_KERNEL_FUTEX_H
#define ATLAS_KERNEL_FUTEX_H

#include <stdint.h>
#include "kernel/interrupts.h"

#define FUTEX_WAIT 0
#define FUTEX_WAKE 1

void futex_init(void);
int sys_futex(registers_t *regs);

#endif
