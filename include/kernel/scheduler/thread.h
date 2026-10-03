#ifndef ATLAS_TASK_H
#define ATLAS_TASK_H

#include <stdint.h>
#include <stdbool.h>

typedef enum {
    THREAD_READY,
    THREAD_RUNNING,
    THREAD_BLOCKED,
    THREAD_SLEEPING,
    THREAD_TERMINATED,
} thread_state_t;

/* Saved CPU context for context switching.
 * Only esp is stored in the struct. The callee-saved registers
 * (ebx, esi, edi, ebp) are pushed/popped on the task's stack
 * by context_switch in switch.s. */
struct cpu_context {
    uint32_t esp;
};

typedef struct thread {
    uint32_t pid;
    char name[32];

    struct cpu_context context;

    uint32_t *kernel_stack;     // Base of allocated stack (for freeing)
    uint32_t kernel_stack_size;

    thread_state_t state;
    
    uint32_t wakeup_tick;       // For SLEEPING state

    void (*entry)(void *);      // Thread entry point
    void *arg;                  // Thread argument
    
    struct process *process;    // Parent process
    uint32_t tls_base;          // Thread Local Storage base address
    
    uint32_t *futex_uaddr;      // Address this thread is waiting on (if blocked)
    struct thread *next_futex;  // Link for the futex wait queue
} thread_t;

/* PID allocation */
#define PID_IDLE 0

/* Task lifecycle */
thread_t *thread_create(const char *name, void (*entry)(void *), void *arg);
void thread_destroy(thread_t *task);

/* Current running task */
extern thread_t *current_thread;

#endif
