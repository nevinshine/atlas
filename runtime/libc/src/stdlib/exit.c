#include "../env/env_internal.h"
#include <stdio.h>
#include <atlas/process.h>

void exit(int status) {
    if (__runtime_process.state == RUNTIME_STATE_EXITING) {
        // Prevent recursive exit
        _exit(status);
    }
    
    __runtime_process.state = RUNTIME_STATE_EXITING;
    
    // 1. atexit handlers in reverse order
    for (int i = __runtime_process.atexit_count - 1; i >= 0; i--) {
        if (__runtime_process.atexit_funcs[i]) {
            __runtime_process.atexit_funcs[i]();
        }
    }
    
    // 2. flush stdio
    fflush(NULL);
    
    // 3. close FILE objects
    // TODO: implement fcloseall() or just close via stdio_manager.
    // For now, fflush is sufficient, as the kernel will close FDs on exit.
    
    // 4. .fini_array
    // Note: dynamic loader/CRT handles .fini_array usually, or we can invoke it here if we build support for it later.
    
    // 5. libatlas _exit
    _exit(status);
}
