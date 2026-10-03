#include <atlas/boot.h>
#include <stddef.h>
#include <stdint.h>

extern atlas_boot_info_t global_boot_info;

unsigned long getauxval(unsigned long type) {
    if (!global_boot_info.auxv) return 0;
    
    unsigned long *auxv = (unsigned long *)global_boot_info.auxv;
    for (size_t i = 0; auxv[i] != 0; i += 2) {
        if (auxv[i] == type) {
            return auxv[i + 1];
        }
    }
    return 0;
}
