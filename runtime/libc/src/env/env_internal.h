#ifndef _LIBC_ENV_INTERNAL_H
#define _LIBC_ENV_INTERNAL_H

#include <stddef.h>
#include <atlas/boot.h>

#define RUNTIME_STATE_RUNNING 0
#define RUNTIME_STATE_EXITING 1

#define ATEXIT_MAX 32

typedef struct {
    char **environ;
    size_t env_capacity;
    size_t env_count;
    
    void (*atexit_funcs[ATEXIT_MAX])(void);
    size_t atexit_count;
    
    int state;
} runtime_process_t;

extern runtime_process_t __runtime_process;

void __env_init(atlas_boot_info_t *boot);

#endif
