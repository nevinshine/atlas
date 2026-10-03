#include <stdio.h>
#include <string.h>
#include <unistd.h>

#define PRINT(msg) write(1, msg, strlen(msg))

int main() {
    int failed = 0;
    
    char buf[128];
    
    // snprintf
    int n = snprintf(buf, sizeof(buf), "Hello %s, num %d hex %x", "world", -42, 255);
    const char *expected = "Hello world, num -42 hex ff";
    
    if (strcmp(buf, expected) != 0) {
        PRINT("FAIL: snprintf basic\n");
        failed++;
    }
    
    if (n != (int)strlen(expected)) {
        PRINT("FAIL: snprintf length\n");
        failed++;
    }
    
    // Test %u and %%
    n = snprintf(buf, sizeof(buf), "100%% %u", 4294967295U);
    if (strcmp(buf, "100% 4294967295") != 0) {
        PRINT("FAIL: snprintf unsigned\n");
        failed++;
    }
    
    // Test %p
    void *ptr = (void *)0x1234abcd;
    n = snprintf(buf, sizeof(buf), "ptr: %p", ptr);
    if (strcmp(buf, "ptr: 0x1234abcd") != 0) {
        PRINT("FAIL: snprintf pointer\n");
        failed++;
    }

    // Test truncation
    n = snprintf(buf, 5, "Hello");
    if (strcmp(buf, "Hell") != 0) {
        PRINT("FAIL: snprintf truncation\n");
        failed++;
    }

    if (!failed) {
        PRINT("PASS: format tests\n");
        return 0;
    }
    
    return 1;
}
