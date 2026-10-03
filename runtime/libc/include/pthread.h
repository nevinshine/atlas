#ifndef PTHREAD_H
#define PTHREAD_H

#include <stdint.h>
#include <stddef.h>

// Opaque thread handle
typedef struct _pthread_tcb* pthread_t;

// Mutex
typedef struct {
    uint32_t val;
} pthread_mutex_t;

#define PTHREAD_MUTEX_INITIALIZER {0}

int pthread_mutex_init(pthread_mutex_t *mutex, const void *attr);
int pthread_mutex_destroy(pthread_mutex_t *mutex);
int pthread_mutex_lock(pthread_mutex_t *mutex);
int pthread_mutex_unlock(pthread_mutex_t *mutex);

// Condition Variable
typedef struct {
    uint32_t val;
} pthread_cond_t;

#define PTHREAD_COND_INITIALIZER {0}

int pthread_cond_init(pthread_cond_t *cond, const void *attr);
int pthread_cond_destroy(pthread_cond_t *cond);
int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex);
int pthread_cond_signal(pthread_cond_t *cond);
int pthread_cond_broadcast(pthread_cond_t *cond);

// Thread Lifecycle
int pthread_create(pthread_t *thread, const void *attr, void *(*start_routine)(void *), void *arg);
void pthread_exit(void *retval);
int pthread_join(pthread_t thread, void **retval);

#endif // PTHREAD_H
