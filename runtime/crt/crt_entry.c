#include <stdint.h>
#include <stddef.h>
#include "../runtime/boot.h"

extern void __libatlas_start(runtime_boot_t *runtime_boot);
extern void libc_init(runtime_boot_t *runtime_boot);
extern int main(int argc, char **argv, char **envp);
extern void exit(int status);

void __crt_entry(void *sp) {
    // 1. Single source of truth for parsing the initial stack
    runtime_boot_t runtime;
    boot_parse_stack(sp, &runtime.boot);
    
    // 2. Initialize libatlas with the parsed boot structure
    __libatlas_start(&runtime);
    
    // 3. Initialize libc (stubbed for now)
    libc_init(&runtime);
    
    // 4. Call main
    int status = main(runtime.boot.argc, runtime.boot.argv, runtime.boot.envp);
    
    // 5. Native OS exit
    exit(status);
}
