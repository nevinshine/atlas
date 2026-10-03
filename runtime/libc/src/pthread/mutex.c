#include <pthread.h>
#include <stdint.h>
#include <stdbool.h>
#include <atlas/syscall.h>

#define FUTEX_WAIT 0
#define FUTEX_WAKE 1

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

int pthread_mutex_init(pthread_mutex_t *mutex, const void *attr) {
    (void)attr;
    if (mutex) {
        mutex->val = 0;
        return 0;
    }
    return -1;
}

int pthread_mutex_destroy(pthread_mutex_t *mutex) {
    (void)mutex;
    return 0; // Nothing to do for minimal mutex
}

int pthread_mutex_lock(pthread_mutex_t *mutex) {
    if (!mutex) return -1;
    
    // Fast path / atomic acquire
    while (__sync_lock_test_and_set(&mutex->val, 1)) {
        // Slow path: wait
        futex(&mutex->val, FUTEX_WAIT, 1);
    }
    
    return 0;
}

int pthread_mutex_unlock(pthread_mutex_t *mutex) {
    if (!mutex) return -1;
    
    // Release
    __sync_lock_release(&mutex->val);
    
    // Wake up one waiting thread
    futex(&mutex->val, FUTEX_WAKE, 1);
    
    return 0;
}
