#include <pthread.h>
#include <stdint.h>
#include <stdbool.h>
#include <atlas/syscall.h>

#define FUTEX_WAIT 0
#define FUTEX_WAKE 1
#define INT_MAX    2147483647

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

int pthread_cond_init(pthread_cond_t *cond, const void *attr) {
    (void)attr;
    if (cond) {
        cond->val = 0;
        return 0;
    }
    return -1;
}

int pthread_cond_destroy(pthread_cond_t *cond) {
    (void)cond;
    return 0;
}

int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex) {
    if (!cond || !mutex) return -1;
    
    // Read the current sequence value
    uint32_t current_val = cond->val;
    
    // Atomically block on this value while unlocking the mutex.
    // In userspace, we unlock first, then wait.
    // Note: A true POSIX cond_wait must atomically unlock and sleep to avoid missed wakeups.
    // Our futex wait relies on `val` staying the same.
    // If a wake happens between unlock and futex, `cond->val` will increment,
    // and futex() will return EAGAIN instead of blocking, avoiding the missed wakeup!
    pthread_mutex_unlock(mutex);
    
    futex(&cond->val, FUTEX_WAIT, current_val);
    
    // Re-acquire the mutex upon waking up
    pthread_mutex_lock(mutex);
    
    return 0;
}

int pthread_cond_signal(pthread_cond_t *cond) {
    if (!cond) return -1;
    
    // Increment the sequence counter
    __sync_fetch_and_add(&cond->val, 1);
    
    // Wake up one waiting thread
    futex(&cond->val, FUTEX_WAKE, 1);
    
    return 0;
}

int pthread_cond_broadcast(pthread_cond_t *cond) {
    if (!cond) return -1;
    
    // Increment the sequence counter
    __sync_fetch_and_add(&cond->val, 1);
    
    // Wake up all waiting threads
    futex(&cond->val, FUTEX_WAKE, INT_MAX);
    
    return 0;
}
