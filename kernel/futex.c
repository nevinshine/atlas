#include "kernel/futex.h"
#include "kernel/scheduler/thread.h"
#include "kernel/scheduler/scheduler.h"
#include "kernel/log.h"
#include "kernel/uaccess.h"

// Global list of threads blocked on a futex.
static thread_t *futex_waiters = NULL;

void futex_init(void) {
    futex_waiters = NULL;
}

// Atomically check the value at `uaddr` and block if it matches `val`.
// We rely on the fact that this is called from within a syscall handler (interrupts disabled)
// so checking the value and blocking is atomic with respect to other threads calling sys_futex.
static int futex_wait(uint32_t *uaddr, uint32_t val) {
    uint32_t current_val;
    if (copy_from_user((char *)&current_val, (const char *)uaddr, sizeof(uint32_t)) != 0) {
        return -1;
    }
    
    if (current_val != val) {
        return -1; // EAGAIN
    }
    
    // Add to wait queue
    current_thread->futex_uaddr = uaddr;
    current_thread->next_futex = futex_waiters;
    futex_waiters = current_thread;
    
    // Block the thread
    extern void scheduler_block_current(void);
    scheduler_block_current();
    
    return 0;
}

// Wake up to `count` threads waiting on `uaddr`.
static int futex_wake(uint32_t *uaddr, uint32_t count) {
    int woken = 0;
    
    thread_t **curr = &futex_waiters;
    while (*curr != NULL && woken < count) {
        thread_t *thread = *curr;
        if (thread->futex_uaddr == uaddr) {
            // Remove from list
            *curr = thread->next_futex;
            thread->next_futex = NULL;
            thread->futex_uaddr = NULL;
            
            // Wake up
            scheduler_make_ready(thread);
            woken++;
        } else {
            curr = &thread->next_futex;
        }
    }
    
    return woken;
}

int sys_futex(registers_t *regs) {
    uint32_t *uaddr = (uint32_t *)regs->ebx;
    int futex_op = (int)regs->ecx;
    uint32_t val = (uint32_t)regs->edx;
    
    if (futex_op == FUTEX_WAIT) {
        return futex_wait(uaddr, val);
    } else if (futex_op == FUTEX_WAKE) {
        return futex_wake(uaddr, val);
    }
    
    return -1; // Invalid operation
}
