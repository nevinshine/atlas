#include "kernel/sync/mutex.h"
#include "kernel/log.h"
#include "kernel/interrupts.h"

void mutex_init(mutex_t *m) {
    if (!m) return;
    m->lock.lock = 0;
    m->owner = NULL;
    m->recursion = 0;
    waitqueue_init(&m->wait_queue);
}

void mutex_acquire(mutex_t *m) {
    if (!m) return;
    uint32_t flags;
    spin_lock_irqsave(&m->lock, &flags);
    
    if (m->owner == current_thread) {
        panic("Mutex recursive lock attempted by PID %u", current_thread->pid);
    }
    
    while (m->owner != NULL) {
        uint32_t original_flags = flags;
        waitqueue_sleep(&m->wait_queue, &m->lock);
        
        spin_lock_irqsave(&m->lock, &flags);
        flags = original_flags;
    }
    
    m->owner = current_thread;
    m->recursion = 1;
    
    spin_unlock_irqrestore(&m->lock, flags);
}

void mutex_release(mutex_t *m) {
    if (!m) return;
    uint32_t flags;
    spin_lock_irqsave(&m->lock, &flags);
    
    if (m->owner != current_thread) {
        panic("Mutex unlock by non-owner PID %u", current_thread->pid);
    }
    
    m->owner = NULL;
    m->recursion = 0;
    
    waitqueue_wake_one(&m->wait_queue);
    
    spin_unlock_irqrestore(&m->lock, flags);
}

void mutex_destroy(mutex_t *m) {
    if (!m) return;
    uint32_t flags;
    spin_lock_irqsave(&m->lock, &flags);
    if (m->owner != NULL) {
        panic("Attempted to destroy locked mutex!");
    }
    spin_unlock_irqrestore(&m->lock, flags);
}
