#include <stdio.h>
#include <stdlib.h>
#include <atlas/memory.h>
#include <string.h>

void print_status(const char *test, int success) {
    if (success) {
        printf("[PASS] %s\n", test);
    } else {
        printf("[FAIL] %s\n", test);
        exit(1);
    }
}

int main(int argc, char *argv[]) {
    printf("--- memtest ---\n");

    // 1. malloc/free
    void *ptr1 = malloc(128);
    void *ptr2 = malloc(256);
    print_status("malloc allocation", ptr1 != NULL && ptr2 != NULL && ptr1 != ptr2);
    
    strcpy((char*)ptr1, "Hello malloc!");
    print_status("malloc write/read", strcmp((char*)ptr1, "Hello malloc!") == 0);
    
    free(ptr1);
    free(ptr2);
    print_status("free", 1);

    // 2. sbrk growth
    void *brk_orig = sbrk(0);
    void *brk_new = sbrk(4096);
    print_status("sbrk growth", brk_new == brk_orig && sbrk(0) == (char*)brk_orig + 4096);
    
    // write to new brk area
    char *b = (char *)brk_orig;
    b[0] = 'X';
    b[4095] = 'Y';
    print_status("sbrk write/read", b[0] == 'X' && b[4095] == 'Y');

    // 3. sbrk shrink
    void *brk_shrink = sbrk(-4096);
    print_status("sbrk shrink", brk_shrink != (void*)-1 && sbrk(0) == brk_orig);

    // 4. mmap anonymous
    void *map = mmap(NULL, 8192, 1 | 2 /* PROT_READ | PROT_WRITE */, 0x20 | 0x02 /* MAP_ANONYMOUS | MAP_PRIVATE */, -1, 0);
    print_status("mmap anonymous", map != (void*)-1 && map != NULL);
    
    char *m = (char *)map;
    m[0] = 'A';
    m[8191] = 'B';
    print_status("mmap write/read", m[0] == 'A' && m[8191] == 'B');

    // 5. munmap
    int unmap_res = munmap(map, 8192);
    print_status("munmap", unmap_res == 0);

    // 6. protection semantics (we'll just test that PROT_NONE mmap succeeds)
    void *guard = mmap(NULL, 4096, 0 /* PROT_NONE */, 0x20 | 0x02, -1, 0);
    print_status("mmap PROT_NONE", guard != (void*)-1 && guard != NULL);

    printf("All memtest phases PASS.\n");
    return 0;
}
