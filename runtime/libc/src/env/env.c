#include "env_internal.h"
#include <stdlib.h>
#include <string.h>
#include <memory.h>

runtime_process_t __runtime_process;
char **environ = NULL;

void __env_init(atlas_boot_info_t *boot) {
    __runtime_process.state = RUNTIME_STATE_RUNNING;
    __runtime_process.atexit_count = 0;
    
    // Count envs
    size_t count = 0;
    if (boot->envp) {
        while (boot->envp[count]) count++;
        
        __runtime_process.env_count = count;
        __runtime_process.env_capacity = count + 1;
        __runtime_process.environ = boot->envp;
    } else {
        __runtime_process.env_count = 0;
        __runtime_process.env_capacity = 16;
        __runtime_process.environ = calloc(__runtime_process.env_capacity, sizeof(char *));
    }
    
    environ = __runtime_process.environ;
}

char *getenv(const char *name) {
    if (!name || !environ) return NULL;
    
    size_t len = strlen(name);
    for (size_t i = 0; environ[i] != NULL; i++) {
        if (strncmp(environ[i], name, len) == 0 && environ[i][len] == '=') {
            return environ[i] + len + 1;
        }
    }
    
    return NULL;
}

int setenv(const char *name, const char *value, int overwrite) {
    if (!name || !value) return -1;
    if (__runtime_process.state != RUNTIME_STATE_RUNNING) return -1;
    
    size_t name_len = strlen(name);
    
    // Find existing
    for (size_t i = 0; environ[i] != NULL; i++) {
        if (strncmp(environ[i], name, name_len) == 0 && environ[i][name_len] == '=') {
            if (!overwrite) return 0;
            
            size_t val_len = strlen(value);
            char *new_str = malloc(name_len + 1 + val_len + 1);
            if (!new_str) return -1;
            
            memcpy(new_str, name, name_len);
            new_str[name_len] = '=';
            memcpy(new_str + name_len + 1, value, val_len + 1);
            
            environ[i] = new_str;
            return 0;
        }
    }
    
    // Need to add new
    size_t val_len = strlen(value);
    char *new_str = malloc(name_len + 1 + val_len + 1);
    if (!new_str) return -1;
    
    memcpy(new_str, name, name_len);
    new_str[name_len] = '=';
    memcpy(new_str + name_len + 1, value, val_len + 1);
    
    if (__runtime_process.env_count + 1 >= __runtime_process.env_capacity) {
        size_t new_cap = __runtime_process.env_capacity == 0 ? 16 : __runtime_process.env_capacity * 2;
        char **new_env = malloc(new_cap * sizeof(char *));
        if (!new_env) {
            free(new_str);
            return -1;
        }
        
        if (environ) {
            memcpy(new_env, environ, __runtime_process.env_count * sizeof(char *));
        }
        
        // If environ was dynamically allocated previously, we could free it, 
        // but we don't know if it was the startup pointer or dynamically allocated.
        // POSIX putenv/setenv often leaks the old environ array or we can track it.
        // For simplicity, we just leak the old array if it was dynamically allocated.
        // Or we could track if it's the original. Let's just track it via capacity logic:
        // Actually, if we just realloc, wait, the original is NOT malloc'd!
        // We shouldn't free the original. We'll just leak the arrays for now, or track it.
        // We'll leak the array pointer for simplicity.
        
        environ = new_env;
        __runtime_process.environ = new_env;
        __runtime_process.env_capacity = new_cap;
    }
    
    environ[__runtime_process.env_count++] = new_str;
    environ[__runtime_process.env_count] = NULL;
    
    return 0;
}

int unsetenv(const char *name) {
    if (!name || !environ) return -1;
    if (__runtime_process.state != RUNTIME_STATE_RUNNING) return -1;
    
    size_t name_len = strlen(name);
    for (size_t i = 0; environ[i] != NULL; i++) {
        if (strncmp(environ[i], name, name_len) == 0 && environ[i][name_len] == '=') {
            // Shift everything down
            for (size_t j = i; environ[j] != NULL; j++) {
                environ[j] = environ[j+1];
            }
            __runtime_process.env_count--;
            // We do not free the string, as putenv might have placed a static string.
            return 0;
        }
    }
    return 0;
}

int putenv(char *string) {
    if (!string) return -1;
    if (__runtime_process.state != RUNTIME_STATE_RUNNING) return -1;
    
    char *eq = strchr(string, '=');
    if (!eq) return -1;
    
    size_t name_len = eq - string;
    
    // Find existing
    for (size_t i = 0; environ[i] != NULL; i++) {
        if (strncmp(environ[i], string, name_len) == 0 && environ[i][name_len] == '=') {
            environ[i] = string;
            return 0;
        }
    }
    
    // Add new
    if (__runtime_process.env_count + 1 >= __runtime_process.env_capacity) {
        size_t new_cap = __runtime_process.env_capacity == 0 ? 16 : __runtime_process.env_capacity * 2;
        char **new_env = malloc(new_cap * sizeof(char *));
        if (!new_env) return -1;
        
        if (environ) {
            memcpy(new_env, environ, __runtime_process.env_count * sizeof(char *));
        }
        
        environ = new_env;
        __runtime_process.environ = new_env;
        __runtime_process.env_capacity = new_cap;
    }
    
    environ[__runtime_process.env_count++] = string;
    environ[__runtime_process.env_count] = NULL;
    
    return 0;
}
