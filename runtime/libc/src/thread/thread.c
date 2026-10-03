#include "thread_internal.h"

static runtime_thread_t __main_thread = {
    .thread_id = 0,
    .thread_errno = 0,
    .locale = 0
};

runtime_thread_t *__runtime_current_thread(void) {
    // Single threaded for now
    return &__main_thread;
}

int *__get_thread_errno_ptr(void) {
    return &(__runtime_current_thread()->thread_errno);
}
