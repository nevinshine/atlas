#include <atlas/boot.h>
#include "src/env/env_internal.h"

extern void __stdio_init(void);

void libc_init(atlas_boot_info_t *boot_info) {
    __env_init(boot_info); // stub if it expects runtime_boot_t
    // Initialize standard IO streams
    __stdio_init();
}
