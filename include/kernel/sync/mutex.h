#ifndef KERNEL_MUTEX_H
#define KERNEL_MUTEX_H

#include "kernel/scheduler/thread.h"
#include "kernel/sync/waitqueue.h"
#include "kernel/sync/spinlock.h"

typedef struct {
    spinlock_t lock;
    thread_t *owner;
    uint32_t recursion;
    wait_queue_t wait_queue;
} mutex_t;

void mutex_init(mutex_t *m);
void mutex_acquire(mutex_t *m);
void mutex_release(mutex_t *m);
void mutex_destroy(mutex_t *m);

#endif /* KERNEL_MUTEX_H */
