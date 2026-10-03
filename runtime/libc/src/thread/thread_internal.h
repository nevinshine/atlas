#ifndef _LIBC_THREAD_INTERNAL_H
#define _LIBC_THREAD_INTERNAL_H

typedef struct {
    int thread_id;
    int thread_errno;
    void *locale;
    // ... future thread state (e.g. stdio locks) ...
} runtime_thread_t;

runtime_thread_t *__runtime_current_thread(void);

#endif
