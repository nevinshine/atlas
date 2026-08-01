#include "kernel/sync/spinlock.h"

void spin_lock(spinlock_t *lock) {
    while (atomic_xchg(&lock->lock, 1) == 1) {
        __asm__ volatile("pause");
    }
}

void spin_unlock(spinlock_t *lock) {
    lock->lock = 0;
}

void spin_lock_irqsave(spinlock_t *lock, uint32_t *flags) {
    *flags = irq_save();
    spin_lock(lock);
}

void spin_unlock_irqrestore(spinlock_t *lock, uint32_t flags) {
    spin_unlock(lock);
    irq_restore(flags);
}
