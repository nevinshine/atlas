#include <pthread.h>
#include <stdlib.h>
#include <stdint.h>
#include <atlas/syscall.h>

#define FUTEX_WAIT 0
#define FUTEX_WAKE 1

// We declare the underlying libatlas primitives
extern int atlas_thread_create(void (*fn)(void *), void *arg);
extern void atlas_thread_exit(void);

// This matches the opaque pthread_t
struct _pthread_tcb {
    int tid;
    void *(*start_routine)(void *);
    void *arg;
    void *retval;
    uint32_t exited;
};

// Syscall stub for futex
static int futex(uint32_t *uaddr, int futex_op, uint32_t val) {
    int ret;
    __asm__ volatile (
        "int $0x80"
        : "=a" (ret)
        : "a" (18), "b" (uaddr), "c" (futex_op), "d" (val)
        : "memory"
    );
    return ret;
}

// Internal wrapper that runs the thread
static void pthread_wrapper(void *arg) {
    struct _pthread_tcb *tcb = (struct _pthread_tcb *)arg;
    
    // Execute the user function
    tcb->retval = tcb->start_routine(tcb->arg);
    
    // Mark as exited and wake any joiners
    __sync_lock_test_and_set(&tcb->exited, 1);
    futex(&tcb->exited, FUTEX_WAKE, 1);
    
    // Exit the thread
    atlas_thread_exit();
}

int pthread_create(pthread_t *thread, const void *attr, void *(*start_routine)(void *), void *arg) {
    (void)attr; // Attributes not supported yet
    
    struct _pthread_tcb *tcb = malloc(sizeof(struct _pthread_tcb));
    if (!tcb) return -1;
    
    tcb->start_routine = start_routine;
    tcb->arg = arg;
    tcb->retval = NULL;
    tcb->exited = 0;
    
    int tid = atlas_thread_create(pthread_wrapper, tcb);
    if (tid < 0) {
        free(tcb);
        return -1;
    }
    
    tcb->tid = tid;
    *thread = tcb;
    return 0;
}

void pthread_exit(void *retval) {
    // In a fully compliant libc, pthread_exit would find the current thread's TCB.
    // For now, if a thread calls pthread_exit instead of returning from the start_routine,
    // we would need to store the TCB pointer in TLS to retrieve it.
    // Let's assume for Phase 3.5 that threads exit by returning from their start_routine.
    // If they call pthread_exit directly, we'd need a TLS lookup. 
    // To support this properly later, we can stash `tcb` in the TLS block during wrapper init.
    
    (void)retval;
    atlas_thread_exit();
}

int pthread_join(pthread_t thread, void **retval) {
    if (!thread) return -1;
    
    // Wait until exited == 1
    while (!thread->exited) {
        futex(&thread->exited, FUTEX_WAIT, 0);
    }
    
    if (retval) {
        *retval = thread->retval;
    }
    
    free(thread);
    return 0;
}
