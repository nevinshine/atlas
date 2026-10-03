#include <atlas/memory.h>
#include <stddef.h>
#include <stdint.h>

#define CLONE_VM      0x00000100
#define CLONE_FS      0x00000200
#define CLONE_FILES   0x00000400
#define CLONE_SIGHAND 0x00000800
#define CLONE_THREAD  0x00010000
#define CLONE_SETTLS  0x00080000

extern int atlas_clone(uint32_t flags, void *stack_ptr, void *parent_tidptr, void *tls_val, void *child_tidptr);
extern void atlas_thread_exit(void);
extern void *atlas_tls_allocate(void);
extern void atlas_tls_init(void *tp);

typedef struct {
    void (*fn)(void *);
    void *arg;
} thread_start_info_t;

// This is the C entry point for a new thread.
// It is called directly from the assembly trampoline.
void atlas_thread_start_c(thread_start_info_t *info) {
    if (info && info->fn) {
        info->fn(info->arg);
    }
    atlas_thread_exit();
}

extern void atlas_thread_trampoline(void);

// Create a thread. Returns the thread ID (PID).
int atlas_thread_create(void (*fn)(void *), void *arg) {
    // 1. Allocate a stack for the thread (e.g., 64KB)
    size_t stack_size = 64 * 1024;
    void *stack = atlas_malloc(stack_size);
    if (!stack) return -1;
    
    // 2. Allocate and initialize TLS
    void *tp = atlas_tls_allocate();
    if (tp) {
        atlas_tls_init(tp);
    }
    
    // 3. Prepare the stack frame for the trampoline
    uint32_t *sp = (uint32_t *)((char *)stack + stack_size);
    
    sp -= (sizeof(thread_start_info_t) / sizeof(uint32_t));
    thread_start_info_t *info = (thread_start_info_t *)sp;
    info->fn = fn;
    info->arg = arg;
    
    // Push the argument to atlas_thread_start_c (info pointer)
    *(--sp) = (uint32_t)info;
    
    // Dummy return address for atlas_thread_start_c
    *(--sp) = 0;
    
    // Return address for `ret` instruction in atlas_clone (which jumps to atlas_thread_start_c)
    *(--sp) = (uint32_t)atlas_thread_start_c;
    
    // 5 dummy registers to be popped by atlas_clone: ebx, ecx, edx, esi, edi
    *(--sp) = 0; // ebx
    *(--sp) = 0; // ecx
    *(--sp) = 0; // edx
    *(--sp) = 0; // esi
    *(--sp) = 0; // edi
    
    // 4. Call clone
    uint32_t flags = CLONE_VM | CLONE_FS | CLONE_FILES | CLONE_SIGHAND | CLONE_THREAD | CLONE_SETTLS;
    
    int tid = atlas_clone(flags, sp, NULL, tp, NULL);
    if (tid == 0) {
        // Child thread (should never happen here, it returns via ret in assembly)
        return 0;
    } else if (tid < 0) {
        // Failed
        return -1;
    }
    
    return tid;
}
