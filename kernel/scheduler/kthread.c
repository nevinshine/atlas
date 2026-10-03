#include "kernel/scheduler/kthread.h"
#include "kernel/scheduler/thread.h"
#include "kernel/scheduler/scheduler.h"
#include "kernel/log.h"
#include <stddef.h>

/* thread_trampoline
 *
 * Every new thread starts here via context_switch's `ret`.
 * It reads the entry point and argument from current_thread,
 * calls the function, and cleanly exits when it returns. */
void thread_trampoline(void) {
    /* Read entry and arg from the current thread struct */
    void (*entry)(void *) = current_thread->entry;
    void *arg = current_thread->arg;

    /* Interrupts were enabled implicitly by popf in context_switch */

    /* Call the thread's actual function */
    entry(arg);

    /* Thread returned naturally — clean exit */
    scheduler_exit_current();

    /* Should never reach here */
    while(1) { __asm__ volatile("hlt"); }
}

thread_t *kthread_create(const char *name, void (*entry)(void *), void *arg) {
    thread_t *thread = thread_create(name, entry, arg);
    if (!thread) return NULL;

    scheduler_enqueue(thread);
    return thread;
}
