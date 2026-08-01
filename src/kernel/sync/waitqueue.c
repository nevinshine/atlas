#include "kernel/sync/waitqueue.h"
#include "kernel/scheduler/scheduler.h"
#include "kernel/interrupts.h"
#include <stddef.h>

void waitqueue_init(wait_queue_t *wq) {
    list_init(&wq->list);
    wq->lock.lock = 0;
}

void waitqueue_sleep(wait_queue_t *wq, spinlock_t *lock) {
    uint32_t irq = irq_save();

    spin_lock(&wq->lock);

    current_thread->state = THREAD_BLOCKED;
    list_push_back(&wq->list, current_thread);
    
    spin_unlock(&wq->lock);

    if (lock) {
        spin_unlock(lock);
    }
    
    scheduler_dequeue(current_thread);
    scheduler_yield();
    
    irq_restore(irq);
}

void waitqueue_wake_one(wait_queue_t *wq) {
    uint32_t irq = irq_save();
    spin_lock(&wq->lock);
    
    thread_t *thread = (thread_t *)list_pop_front(&wq->list);
    
    spin_unlock(&wq->lock);
    
    if (thread) {
        scheduler_make_ready(thread);
    }
    
    irq_restore(irq);
}

void waitqueue_wake_all(wait_queue_t *wq) {
    uint32_t irq = irq_save();
    spin_lock(&wq->lock);
    
    thread_t *thread;
    while ((thread = (thread_t *)list_pop_front(&wq->list)) != NULL) {
        scheduler_make_ready(thread);
    }
    
    spin_unlock(&wq->lock);
    irq_restore(irq);
}
