#ifndef KERNEL_SPINLOCK_H
#define KERNEL_SPINLOCK_H

#include <stdint.h>
#include <stdbool.h>
#include "kernel/sync/atomic.h"
#include "kernel/interrupts.h"

typedef struct {
    volatile uint32_t lock;
} spinlock_t;

#define SPINLOCK_INIT {0}

void spin_lock(spinlock_t *lock);
void spin_unlock(spinlock_t *lock);
void spin_lock_irqsave(spinlock_t *lock, uint32_t *flags);
void spin_unlock_irqrestore(spinlock_t *lock, uint32_t flags);

#endif /* KERNEL_SPINLOCK_H */
