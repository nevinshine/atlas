#include "../env/env_internal.h"
#include <stdlib.h>

int atexit(void (*func)(void)) {
    if (__runtime_process.state != RUNTIME_STATE_RUNNING) return -1;
    
    if (__runtime_process.atexit_count >= ATEXIT_MAX) {
        return -1; // Max exceeded
    }
    
    __runtime_process.atexit_funcs[__runtime_process.atexit_count++] = func;
    return 0;
}
