#include <stddef.h>
#include <stdint.h>
#include <atlas/boot.h>

atlas_boot_info_t global_boot_info;

extern int main(int argc, char **argv, char **envp);
extern void exit(int status);

extern void (*__init_array_start[])(void) __attribute__((weak));
extern void (*__init_array_end[])(void) __attribute__((weak));

extern void (*__fini_array_start[])(void) __attribute__((weak));
extern void (*__fini_array_end[])(void) __attribute__((weak));

// Provided by libc for early initialization
extern void libc_init(void *boot_info);

extern int write(int fd, const void *buf, size_t count);
#define TRACE(msg) write(1, msg, sizeof(msg)-1)

void __libatlas_start(void *sp) {
    TRACE("libatlas: Parsing stack\n");
    // 1. Parse Stack (argc, argv, envp, auxv)
    global_boot_info.initial_sp = sp;
    long *stack_ptr = (long *)sp;
    
    global_boot_info.argc = (int)*stack_ptr;
    global_boot_info.argv = (char **)(stack_ptr + 1);
    global_boot_info.envp = global_boot_info.argv + global_boot_info.argc + 1;
    
    char **p = global_boot_info.envp;
    while (*p != NULL) {
        p++;
    }
    p++;
    global_boot_info.auxv = (void *)p;

    TRACE("libatlas: Calling libc_init\n");
    // 2. libc bootstrap (sets up heap, stdio, etc.)
    libc_init(&global_boot_info);

    TRACE("libatlas: Setting up TLS\n");
    // 2.5 TLS bootstrap
    extern void *atlas_tls_allocate(void);
    extern void atlas_tls_init(void *tp);
    extern int set_tls(void *tls_base);
    
    void *tp = atlas_tls_allocate();
    if (tp) {
        atlas_tls_init(tp);
        set_tls(tp);
    }

    TRACE("libatlas: Calling constructors\n");
    // 3. Call Constructors
    size_t count = 0;
    if (__init_array_start != NULL && __init_array_end != NULL) {
        count = __init_array_end - __init_array_start;
    }
    for (size_t i = 0; i < count; i++) {
        if (__init_array_start[i]) {
            __init_array_start[i]();
        }
    }

    TRACE("libatlas: Handoff to main\n");
    // 4. Handoff to main
    int status = main(global_boot_info.argc, global_boot_info.argv, global_boot_info.envp);

    TRACE("libatlas: Exiting\n");

    // 5. Call Destructors (reverse order)
    count = 0;
    if (__fini_array_start != NULL && __fini_array_end != NULL) {
        count = __fini_array_end - __fini_array_start;
    }
    for (size_t i = count; i > 0; i--) {
        if (__fini_array_start[i-1]) {
            __fini_array_start[i-1]();
        }
    }

    // 6. Exit
    exit(status);
}
