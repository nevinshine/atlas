#include <stdio.h>
#include <stdlib.h>
#include <memory.h>

int main() {
    int failed = 0;

    // Test 1: Basic malloc and free
    void *p1 = malloc(100);
    if (!p1) {
        printf("FAIL: Basic malloc\n");
        failed++;
    } else {
        memset(p1, 0xA5, 100); // Verify we can write to it
        free(p1);
    }

    // Test 2: Calloc
    int *arr = (int *)calloc(50, sizeof(int));
    if (!arr) {
        printf("FAIL: Basic calloc\n");
        failed++;
    } else {
        int zeroed = 1;
        for (int i = 0; i < 50; i++) {
            if (arr[i] != 0) zeroed = 0;
        }
        if (!zeroed) {
            printf("FAIL: Calloc not zeroed\n");
            failed++;
        }
        free(arr);
    }

    // Test 3: Realloc (grow)
    void *p2 = malloc(50);
    memset(p2, 0x42, 50);
    void *p3 = realloc(p2, 200);
    if (!p3) {
        printf("FAIL: realloc grow\n");
        failed++;
    } else {
        // Check first 50 bytes are preserved
        unsigned char *c = (unsigned char *)p3;
        int preserved = 1;
        for (int i = 0; i < 50; i++) {
            if (c[i] != 0x42) preserved = 0;
        }
        if (!preserved) {
            printf("FAIL: realloc grow didn't preserve data\n");
            failed++;
        }
        free(p3);
    }

    // Test 4: Realloc (shrink)
    void *p4 = malloc(500);
    memset(p4, 0x99, 500);
    void *p5 = realloc(p4, 10);
    if (!p5) {
        printf("FAIL: realloc shrink\n");
        failed++;
    } else {
        unsigned char *c = (unsigned char *)p5;
        if (c[0] != 0x99) {
            printf("FAIL: realloc shrink didn't preserve data\n");
            failed++;
        }
        free(p5);
    }

    // Test 5: Many allocations
    void *ptrs[1000];
    for (int i = 0; i < 1000; i++) {
        ptrs[i] = malloc(16 + (i % 64));
        if (!ptrs[i]) {
            printf("FAIL: Bulk alloc iteration %d\n", i);
            failed++;
            break;
        }
    }
    for (int i = 0; i < 1000; i++) {
        free(ptrs[i]);
    }

    if (!failed) {
        printf("PASS: malloc tests\n");
        return 0;
    }
    return 1;
}
