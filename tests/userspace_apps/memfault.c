#include <stdio.h>
#include <stdlib.h>
#include <atlas/memory.h>

int main(int argc, char *argv[]) {
    printf("--- memfault ---\n");
    
    // Test PROT_NONE guard page fault
    void *guard = mmap(NULL, 4096, 0 /* PROT_NONE */, 0x20 | 0x02, -1, 0);
    if (guard == (void*)-1 || guard == NULL) {
        printf("[FAIL] memfault: mmap PROT_NONE failed\n");
        return 1;
    }
    
    printf("memfault: attempting to write to PROT_NONE guard page at %p...\n", guard);
    // This should trigger a page fault and terminate the process!
    volatile char *g = (volatile char *)guard;
    *g = 'X';
    
    // If we reach here, the kernel failed to protect the page
    printf("[FAIL] memfault: write to PROT_NONE succeeded!\n");
    return 1;
}
