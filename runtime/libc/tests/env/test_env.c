#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <unistd.h>
#include "../../src/env/env_internal.h"
#include <runtime/boot.h>

#define PRINT(msg) write(1, msg, strlen(msg))

int main() {
    int failed = 0;
    
    char *mock_envp[] = {
        "PATH=/bin",
        "USER=nevin",
        NULL
    };
    
    runtime_boot_t boot;
    boot.boot.envp = mock_envp;
    
    __env_init(&boot);
    
    if (strcmp(getenv("PATH"), "/bin") != 0) {
        PRINT("FAIL: getenv PATH\n");
        failed++;
    }
    
    if (getenv("NOTFOUND") != NULL) {
        PRINT("FAIL: getenv NOTFOUND\n");
        failed++;
    }
    
    setenv("TEST", "hello", 1);
    if (strcmp(getenv("TEST"), "hello") != 0) {
        PRINT("FAIL: setenv new\n");
        failed++;
    }
    
    setenv("USER", "admin", 0);
    if (strcmp(getenv("USER"), "nevin") != 0) {
        PRINT("FAIL: setenv no-overwrite\n");
        failed++;
    }
    
    setenv("USER", "admin", 1);
    if (strcmp(getenv("USER"), "admin") != 0) {
        PRINT("FAIL: setenv overwrite\n");
        failed++;
    }
    
    unsetenv("TEST");
    if (getenv("TEST") != NULL) {
        PRINT("FAIL: unsetenv\n");
        failed++;
    }
    
    // Test capacity expansion
    for (int i = 0; i < 50; i++) {
        char name[32];
        snprintf(name, sizeof(name), "VAR%d", i);
        setenv(name, "123", 1);
    }
    
    if (strcmp(getenv("VAR42"), "123") != 0) {
        PRINT("FAIL: setenv expansion\n");
        failed++;
    }
    
    if (!failed) {
        PRINT("PASS: env tests\n");
        return 0;
    }
    return 1;
}
