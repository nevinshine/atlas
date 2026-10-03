#include <stdio.h>
#include <stdlib.h>

extern int atlas_thread_create(void (*fn)(void *), void *arg);
extern int yield(void);

__thread int my_tls_val = 0;
int shared_var = 0;

void thread_fn(void *arg) {
    int id = (int)arg;
    
    printf("Thread %d started. TLS initial = %d\n", id, my_tls_val);
    
    my_tls_val = id * 100;
    shared_var += id;
    
    printf("Thread %d modified values. TLS = %d, Shared = %d\n", id, my_tls_val, shared_var);
    
    // Thread will exit here and atlas_thread_start_c will call atlas_thread_exit()
}

int main(void) {
    printf("threadtest starting.\n");
    
    int t1 = atlas_thread_create(thread_fn, (void *)1);
    int t2 = atlas_thread_create(thread_fn, (void *)2);
    
    if (t1 < 0 || t2 < 0) {
        printf("threadtest FAIL: thread creation failed\n");
        return 1;
    }
    
    // Give threads some time to run
    for (int i = 0; i < 10; i++) {
        yield();
    }
    
    printf("threadtest main thread. Shared = %d, TLS = %d\n", shared_var, my_tls_val);
    
    if (shared_var == 3 && my_tls_val == 0) {
        printf("threadtest PASS\n");
        return 0;
    } else {
        printf("threadtest FAIL\n");
        return 1;
    }
}
