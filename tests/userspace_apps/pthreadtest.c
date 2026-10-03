#include <stdio.h>
#include <pthread.h>

#define NUM_THREADS 4
#define ITERATIONS  1000

pthread_mutex_t counter_mutex = PTHREAD_MUTEX_INITIALIZER;
volatile int shared_counter = 0;

pthread_mutex_t cond_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond_var = PTHREAD_COND_INITIALIZER;
volatile int condition_met = 0;

// Thread Local Storage
__thread int tls_id = 0;

// Mutex contention test
void *worker_thread(void *arg) {
    int id = (int)arg;
    tls_id = id;
    
    for (int i = 0; i < ITERATIONS; i++) {
        pthread_mutex_lock(&counter_mutex);
        shared_counter++;
        pthread_mutex_unlock(&counter_mutex);
    }
    
    // Test condition variable wait
    pthread_mutex_lock(&cond_mutex);
    while (condition_met == 0) {
        pthread_cond_wait(&cond_var, &cond_mutex);
    }
    pthread_mutex_unlock(&cond_mutex);
    
    // Return TLS value to prove it was preserved
    return (void *)tls_id;
}

int main(void) {
    printf("pthreadtest starting.\n");
    
    pthread_t threads[NUM_THREADS];
    
    // 1. Create threads
    for (int i = 0; i < NUM_THREADS; i++) {
        if (pthread_create(&threads[i], NULL, worker_thread, (void *)(i + 1)) != 0) {
            printf("pthreadtest FAIL: thread creation failed\n");
            return 1;
        }
    }
    
    // 2. Wait a bit, then broadcast the condition to wake all threads
    // In a real system, we'd sleep, but we don't have sleep in libc yet.
    // The threads will block on the futex inside pthread_cond_wait.
    for (volatile int delay = 0; delay < 100000; delay++);
    
    pthread_mutex_lock(&cond_mutex);
    condition_met = 1;
    pthread_mutex_unlock(&cond_mutex);
    
    // Broadcast to wake everyone
    pthread_cond_broadcast(&cond_var);
    
    // 3. Join threads and check TLS preservation
    for (int i = 0; i < NUM_THREADS; i++) {
        void *ret;
        if (pthread_join(threads[i], &ret) != 0) {
            printf("pthreadtest FAIL: join failed\n");
            return 1;
        }
        
        int returned_id = (int)ret;
        if (returned_id != i + 1) {
            printf("pthreadtest FAIL: TLS corruption (expected %d, got %d)\n", i + 1, returned_id);
            return 1;
        }
    }
    
    // 4. Verify shared counter (no lost increments)
    int expected = NUM_THREADS * ITERATIONS;
    if (shared_counter != expected) {
        printf("pthreadtest FAIL: counter mismatch (expected %d, got %d)\n", expected, shared_counter);
        return 1;
    }
    
    printf("pthreadtest PASS\n");
    return 0;
}
