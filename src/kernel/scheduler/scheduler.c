#include "kernel/scheduler/scheduler.h"
#include "kernel/scheduler/process.h"
#include "kernel/heap.h"
#include "kernel/log.h"
#include "arch/x86/gdt.h"
#include "drivers/timer.h"
#include <stddef.h>

/* External assembly routine */
extern void context_switch(thread_t *old, thread_t *new);

/* Ready queue — circular linked list using a simple array + count.
 * The scheduler owns the queue, not the thread. */
#define MAX_TASKS 64

static thread_t *ready_queue[MAX_TASKS];
static uint32_t queue_count = 0;
static uint32_t queue_index = 0;

/* Idle thread */
static thread_t *idle_thread = NULL;

/* Statistics */
static uint32_t stat_context_switches = 0;
static uint32_t stat_idle_ticks = 0;
static uint32_t stat_tasks_created = 0;

/* Time slice in ticks (10 ticks = 100ms at 100Hz) */
#define TIME_SLICE 10
static uint32_t slice_remaining = TIME_SLICE;

static void idle_entry(void *arg) {
    (void)arg;
    while (1) {
        __asm__ volatile("hlt");
    }
}

void scheduler_init(void) {
    scheduler_sleep_init();
    
    /* Create idle thread as PID 0 */
    idle_thread = thread_create("idle", idle_entry, NULL);
    if (!idle_thread) {
        panic("Failed to create idle thread");
    }
    idle_thread->state = THREAD_RUNNING;
    current_thread = idle_thread;
    stat_tasks_created++;

    log_info("Scheduler initialized. Idle thread PID %u.", idle_thread->pid);
}

void scheduler_enqueue(thread_t *thread) {
    if (queue_count >= MAX_TASKS) {
        log_error("Ready queue full!");
        return;
    }
    thread->state = THREAD_READY;
    ready_queue[queue_count++] = thread;
    stat_tasks_created++;
}

void scheduler_dequeue(thread_t *thread) {
    for (uint32_t i = 0; i < queue_count; i++) {
        if (ready_queue[i] == thread) {
            /* Shift remaining tasks down */
            for (uint32_t j = i; j < queue_count - 1; j++) {
                ready_queue[j] = ready_queue[j + 1];
            }
            queue_count--;
            if (queue_index >= queue_count && queue_count > 0) {
                queue_index = 0;
            }
            return;
        }
    }
}

thread_t *scheduler_pick_next(void) {
    if (queue_count == 0) {
        return idle_thread;
    }

    /* Round-robin: pick the next ready thread */
    for (uint32_t i = 0; i < queue_count; i++) {
        uint32_t idx = (queue_index + i) % queue_count;
        if (ready_queue[idx]->state == THREAD_READY) {
            queue_index = (idx + 1) % queue_count;
            return ready_queue[idx];
        }
    }

    return idle_thread;
}

void scheduler_tick(void) {
    if (!current_thread) return;

    scheduler_wake_sleeping();

    slice_remaining--;
    if (slice_remaining > 0) {
        return;
    }

    /* Time slice expired — switch */
    slice_remaining = TIME_SLICE;

    thread_t *next = scheduler_pick_next();

    if (next == current_thread) {
        if (next == idle_thread) {
            stat_idle_ticks += TIME_SLICE;
        }
        return;
    }

    /* Perform the switch */
    thread_t *old = current_thread;

    if (old->state == THREAD_RUNNING) {
        old->state = THREAD_READY;
    }
    next->state = THREAD_RUNNING;
    current_thread = next;
    stat_context_switches++;

    if (old == idle_thread) {
        stat_idle_ticks += TIME_SLICE;
    }

    switch_thread(old, next);
}

void scheduler_yield(void) {
    /* Software interrupt to trigger IRQ0 (Timer) which is at 0x20 */
    __asm__ volatile("int $0x20");
}

void scheduler_exit_current(void) {
    current_thread->state = THREAD_TERMINATED;
    scheduler_dequeue(current_thread);
    
    /* Pick the next thread and switch to it.
     * We never return from this. */
    thread_t *next = scheduler_pick_next();
    thread_t *old = current_thread;
    next->state = THREAD_RUNNING;
    current_thread = next;
    stat_context_switches++;
    switch_thread(old, next);
}

void scheduler_make_ready(thread_t *thread) {
    if (thread) {
        scheduler_enqueue(thread);
    }
}

void switch_thread(thread_t *old, thread_t *new) {
    if (old->process != new->process) {
        if (new->process && new->process->address_space) {
            switch_address_space(new->process->address_space);
        }
    }
    
    tss_prepare(new);
    
    context_switch(old, new);
}




void scheduler_stats(void) {
    uint32_t ticks = timer_get_ticks();
    log_info("========== SCHEDULER STATISTICS ==========");
    log_info("Ticks             : %u", ticks);
    log_info("Context switches  : %u", stat_context_switches);
    log_info("Tasks created     : %u", stat_tasks_created);
    log_info("Tasks in queue    : %u", queue_count);
    log_info("Idle ticks        : %u", stat_idle_ticks);
    log_info("Time slice        : %u ticks (%u ms)", TIME_SLICE, TIME_SLICE * 10);
    log_info("==========================================");
}
