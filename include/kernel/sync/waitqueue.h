#ifndef ATLAS_WAITQUEUE_H
#define ATLAS_WAITQUEUE_H

#include "kernel/list.h"
#include "kernel/sync/spinlock.h"

typedef struct wait_queue {
    list_t list;
    spinlock_t lock; // protects the wait queue itself
} wait_queue_t;

void waitqueue_init(wait_queue_t *wq);

/*
 * Block the current thread and put it on the wait queue.
 * The provided spinlock `lock` is released atomically just before sleeping,
 * avoiding the lost wakeup race.
 */
void waitqueue_sleep(wait_queue_t *wq, spinlock_t *lock);

/* Wake up a single thread blocked on the wait queue. */
void waitqueue_wake_one(wait_queue_t *wq);

/* Wake up all threads blocked on the wait queue. */
void waitqueue_wake_all(wait_queue_t *wq);

#endif
