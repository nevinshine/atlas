#include "kernel/scheduler/thread.h"
#include "kernel/heap.h"
#include "kernel/log.h"
#include "lib/string.h"
#include "lib/memory.h"

#define KERNEL_STACK_SIZE 4096

thread_t *current_thread = NULL;
static uint32_t next_pid = 0;

/* Forward declaration — defined in kthread.c */
extern void thread_trampoline(void);

thread_t *thread_create(const char *name, void (*entry)(void *), void *arg) {
    thread_t *thread = (thread_t *)kmalloc(sizeof(thread_t), KMALLOC_ZERO);
    if (!thread) {
        log_error("Failed to allocate thread struct for '%s'", name);
        return NULL;
    }

    thread->pid = next_pid++;
    strncpy(thread->name, name, sizeof(thread->name) - 1);
    thread->name[sizeof(thread->name) - 1] = '\0';
    thread->state = THREAD_READY;

    /* Allocate kernel stack */
    thread->kernel_stack_size = KERNEL_STACK_SIZE;
    thread->kernel_stack = (uint32_t *)kmalloc(KERNEL_STACK_SIZE, KMALLOC_ZERO);
    if (!thread->kernel_stack) {
        log_error("Failed to allocate kernel stack for '%s'", name);
        kfree(thread);
        return NULL;
    }

    /* Store entry and arg in the thread struct.
     * thread_trampoline will read them from current_thread. */
    thread->entry = entry;
    thread->arg = arg;

    /* Set up the initial stack frame.
     * The stack grows downward, so we start at the top.
     * context_switch pops edi, esi, ebx, ebp, eflags then does ret.
     * So the stack must look like:
     *
     *   thread_trampoline  <- ret jumps here
     *   0x202 (eflags)     <- popf (IF enabled)
     *   0 (edi)            <- pop %edi
     *   0 (esi)            <- pop %esi
     *   0 (ebx)            <- pop %ebx
     *   0 (ebp)            <- pop %ebp, esp starts here
     */
    uint32_t *stack_top = (uint32_t *)((uint32_t)thread->kernel_stack + KERNEL_STACK_SIZE);

    *(--stack_top) = (uint32_t)thread_trampoline;      /* ret target */
    *(--stack_top) = 0x202;                            /* eflags: IF=1, reserved bit 1=1 */
    *(--stack_top) = 0;                                /* edi */
    *(--stack_top) = 0;                                /* esi */
    *(--stack_top) = 0;                                /* ebx */
    *(--stack_top) = 0;                                /* ebp */

    thread->context.esp = (uint32_t)stack_top;

    log_info("Task created: PID %u '%s'", thread->pid, thread->name);
    return thread;
}

void thread_destroy(thread_t *thread) {
    if (!thread) return;
    log_info("Task destroyed: PID %u '%s'", thread->pid, thread->name);
    thread->state = THREAD_TERMINATED;
    if (thread->kernel_stack) {
        kfree(thread->kernel_stack);
    }
    kfree(thread);
}
