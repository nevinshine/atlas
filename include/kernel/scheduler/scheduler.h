#ifndef ATLAS_SCHEDULER_H
#define ATLAS_SCHEDULER_H

#include "kernel/scheduler/thread.h"
#include "kernel/scheduler/process.h"

void scheduler_init(void);
void scheduler_tick(void);
void scheduler_enqueue(thread_t *task);
void scheduler_dequeue(thread_t *task);
thread_t *scheduler_pick_next(void);
void scheduler_stats(void);

void switch_thread(thread_t *old, thread_t *new);

/* Called by kthread when a thread finishes */
void scheduler_exit_current(void);
void scheduler_yield(void);

/* Blocking and waking for synchronization primitives */
void scheduler_make_ready(thread_t *thread);

/* Sleep timers */
void scheduler_sleep_ticks(uint32_t ticks);
void scheduler_sleep_ms(uint32_t ms);
void scheduler_sleep_init(void);
void scheduler_wake_sleeping(void);

#endif
