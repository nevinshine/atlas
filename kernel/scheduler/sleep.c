#include "kernel/scheduler/scheduler.h"
#include "kernel/scheduler/thread.h"
#include "drivers/timer.h"
#include "kernel/interrupts.h"

// The sleep queue is an ordered list of tasks waiting for a specific tick
static list_t sleep_queue;

// Comparison function for ordered insertion
static bool compare_wakeup_tick(void *a, void *b) {
    thread_t *thread_a = (thread_t *)a;
    thread_t *thread_b = (thread_t *)b;
    return thread_a->wakeup_tick < thread_b->wakeup_tick;
}

void scheduler_sleep_init(void) {
    list_init(&sleep_queue);
}

void scheduler_sleep_ticks(uint32_t ticks) {
    if (ticks == 0) return;
    
    uint32_t flags = irq_save();
    
    current_thread->wakeup_tick = timer_get_ticks() + ticks;
    current_thread->state = THREAD_SLEEPING;
    scheduler_dequeue(current_thread);
    
    list_insert_sorted(&sleep_queue, current_thread, compare_wakeup_tick);
    
    thread_t *next = scheduler_pick_next();
    thread_t *old = current_thread;
    next->state = THREAD_RUNNING;
    current_thread = next;
    
    switch_thread(old, next);
    
    irq_restore(flags);
}

void scheduler_sleep_ms(uint32_t ms) {
    // 100 Hz = 10 ms per tick
    uint32_t ticks = ms / 10;
    if (ticks == 0) ticks = 1;
    scheduler_sleep_ticks(ticks);
}

void scheduler_wake_sleeping(void) {
    uint32_t current_tick = timer_get_ticks();
    
    while (sleep_queue.head) {
        thread_t *thread = (thread_t *)sleep_queue.head->value;
        if (thread->wakeup_tick <= current_tick) {
            list_pop_front(&sleep_queue);
            scheduler_enqueue(thread);
        } else {
            break;
        }
    }
}
