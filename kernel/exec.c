#include "kernel/exec.h"
#include "kernel/heap.h"
#include "kernel/fs/vfs.h"
#include "kernel/pmm.h"
#include "kernel/vmm.h"
#include "kernel/log.h"
#include "kernel/elf.h"
#include "lib/string.h"
#include "lib/memory.h"

static int elf_validate(file_t *f, Elf32_Ehdr *out_ehdr) {
    f->offset = 0;
    int bytes_read = vfs_read(f, out_ehdr, sizeof(Elf32_Ehdr));
    if (bytes_read != sizeof(Elf32_Ehdr)) return -1;
    
    // Check magic
    if (out_ehdr->e_ident[0] != 0x7F ||
        out_ehdr->e_ident[1] != 'E' ||
        out_ehdr->e_ident[2] != 'L' ||
        out_ehdr->e_ident[3] != 'F') {
        log_error("exec_load: Not an ELF file");
        return -1;
    }
    
    if (out_ehdr->e_ident[4] != ELFCLASS32) {
        log_error("exec_load: Not a 32-bit ELF");
        return -1;
    }
    
    if (out_ehdr->e_ident[5] != ELFDATA2LSB) {
        log_error("exec_load: Not little-endian");
        return -1;
    }
    
    if (out_ehdr->e_type != ET_EXEC && out_ehdr->e_type != ET_DYN) {
        log_error("exec_load: Not an executable or shared object");
        return -1;
    }
    
    if (out_ehdr->e_machine != EM_386) {
        log_error("exec_load: Not an x86 executable");
        return -1;
    }
    
    return 0;
}

static int elf_load_segments(file_t *f, Elf32_Ehdr *ehdr, address_space_t *as, vm_region_t **regions_head) {
    switch_address_space(as);
    
    for (int i = 0; i < ehdr->e_phnum; i++) {
        Elf32_Phdr phdr;
        f->offset = ehdr->e_phoff + (i * ehdr->e_phentsize);
        if (vfs_read(f, &phdr, sizeof(Elf32_Phdr)) != sizeof(Elf32_Phdr)) {
            switch_address_space(NULL);
            return -1;
        }
        
        if (phdr.p_type == PT_LOAD) {
            uint32_t page_aligned_vaddr = phdr.p_vaddr & ~0xFFF;
            uint32_t offset_in_page = phdr.p_vaddr & 0xFFF;
            uint32_t total_size = phdr.p_memsz + offset_in_page;
            uint32_t num_pages = (total_size + PAGE_SIZE - 1) / PAGE_SIZE;
            
            uint32_t flags = PAGE_PRESENT | PAGE_USER;
            if (phdr.p_flags & PF_W) flags |= PAGE_WRITE;
            // Note: x86 32-bit without PAE doesn't have NX bit, so PF_X is implicit if mapped.
            
            for (uint32_t j = 0; j < num_pages; j++) {
                phys_addr_t paddr = pmm_alloc_frame();
                vmm_map(page_aligned_vaddr + j * PAGE_SIZE, paddr, flags);
            }
            
            // Create vm_region_t for this segment
            vm_region_t *reg = (vm_region_t *)kmalloc(sizeof(vm_region_t), KMALLOC_ZERO);
            reg->start = page_aligned_vaddr;
            reg->end = page_aligned_vaddr + num_pages * PAGE_SIZE;
            reg->flags = flags;
            reg->is_anonymous = 1; // It is eagerly mapped and populated, so COW won't try to read from file
            reg->is_shared = 0;
            reg->is_lazy = 0;
            
            reg->next = *regions_head;
            *regions_head = reg;
            
            // Read file data
            if (phdr.p_filesz > 0) {
                f->offset = phdr.p_offset;
                int read_res = vfs_read(f, (void *)phdr.p_vaddr, phdr.p_filesz);
                if (read_res < 0 || (uint32_t)read_res != phdr.p_filesz) {
                    log_error("exec_load: failed to read segment data");
                    switch_address_space(NULL);
                    return -1;
                }
            }
            
            // Zero out BSS
            if (phdr.p_memsz > phdr.p_filesz) {
                memset((void *)(phdr.p_vaddr + phdr.p_filesz), 0, phdr.p_memsz - phdr.p_filesz);
            }
        }
    }
    
    switch_address_space(NULL);
    return 0;
}


typedef struct {
    uint32_t a_type;
    uint32_t a_val;
} Elf32_auxv_t;

// AT_* constants
#define AT_NULL   0
#define AT_PHDR   3
#define AT_PHENT  4
#define AT_PHNUM  5
#define AT_PAGESZ 6
#define AT_ENTRY  9
#define AT_UID    11
#define AT_EUID   12
#define AT_GID    13
#define AT_EGID   14
#define AT_PLATFORM 15
#define AT_RANDOM 25
#define AT_EXECFN 31

static int elf_get_interp(file_t *f, Elf32_Ehdr *ehdr, char *interp_buf, size_t buf_size) {
    for (int i = 0; i < ehdr->e_phnum; i++) {
        Elf32_Phdr phdr;
        f->offset = ehdr->e_phoff + (i * ehdr->e_phentsize);
        if (vfs_read(f, &phdr, sizeof(Elf32_Phdr)) != sizeof(Elf32_Phdr)) {
            return -1;
        }
        
        if (phdr.p_type == PT_INTERP) {
            if (phdr.p_filesz >= buf_size) return -1;
            f->offset = phdr.p_offset;
            if (vfs_read(f, interp_buf, phdr.p_filesz) != (int)phdr.p_filesz) {
                return -1;
            }
            interp_buf[phdr.p_filesz] = 0;
            return 0;
        }
    }
    return -1;
}

static uint32_t push_string(uint32_t *sp, const char *str) {
    size_t len = strlen(str) + 1;
    *sp -= len;
    strcpy((char *)*sp, str);
    return *sp;
}

static uint32_t build_initial_stack(uint32_t stack_top, int argc, const char *argv[], int envc, const char *envp[], Elf32_auxv_t *auxv, int auxc) {
    uint32_t sp = stack_top;
    
    // 16 bytes of random data for AT_RANDOM
    sp -= 16;
    for (int i=0; i<16; i++) ((uint8_t*)sp)[i] = i; // Dummy random for now
    uint32_t random_ptr = sp;
    
    // Platform string
    sp = push_string(&sp, "atlas");
    uint32_t platform_ptr = sp;
    
    // Execfn string
    sp = push_string(&sp, argc > 0 ? argv[0] : "");
    uint32_t execfn_ptr = sp;
    
    // Push actual argument and environment strings
    uint32_t argv_ptrs[32];
    for (int i = argc - 1; i >= 0; i--) {
        sp = push_string(&sp, argv[i]);
        argv_ptrs[i] = sp;
    }
    
    uint32_t envp_ptrs[32];
    for (int i = envc - 1; i >= 0; i--) {
        sp = push_string(&sp, envp[i]);
        envp_ptrs[i] = sp;
    }
    
    // Align stack pointer to 16 bytes before pushing array data
    sp &= ~15;
    
    // Now push arrays backwards
    
    // Auxv
    for (int i = 0; i < auxc; i++) {
        if (auxv[i].a_type == AT_RANDOM) auxv[i].a_val = random_ptr;
        if (auxv[i].a_type == AT_PLATFORM) auxv[i].a_val = platform_ptr;
        if (auxv[i].a_type == AT_EXECFN) auxv[i].a_val = execfn_ptr;
    }
    
    sp -= sizeof(Elf32_auxv_t);
    Elf32_auxv_t null_auxv = {AT_NULL, 0};
    memcpy((void *)sp, &null_auxv, sizeof(Elf32_auxv_t));
    
    sp -= auxc * sizeof(Elf32_auxv_t);
    memcpy((void *)sp, auxv, auxc * sizeof(Elf32_auxv_t));
    
    // Envp pointers
    sp -= 4;
    *(uint32_t*)sp = 0; // NULL
    
    sp -= envc * 4;
    memcpy((void *)sp, envp_ptrs, envc * 4);
    
    // Argv pointers
    sp -= 4;
    *(uint32_t*)sp = 0; // NULL
    
    sp -= argc * 4;
    memcpy((void *)sp, argv_ptrs, argc * 4);
    
    // Argc
    sp -= 4;
    *(uint32_t*)sp = argc;
    
    return sp;
}

int exec_load(const char *path, exec_image_t *out_image, int argc, const char *argv[], int envc, const char *envp[]) {
    if (!out_image) return -1;
    
    file_t *f = vfs_open(path, 0); 
    if (!f) {
        log_error("exec_load: failed to open %s", path);
        return -1;
    }
    
    Elf32_Ehdr ehdr;
    if (elf_validate(f, &ehdr) != 0) {
        vfs_close(f);
        return -1;
    }
    
    char interp_path[256];
    int has_interp = (elf_get_interp(f, &ehdr, interp_path, sizeof(interp_path)) == 0);
    
    if (!has_interp) {
        // Fallback to /lib/aether for now if it's an executable
        strcpy(interp_path, "/lib/aether");
        has_interp = 1;
    }
    
    vfs_close(f);
    
    // Open interpreter
    file_t *interp_f = vfs_open(interp_path, 0);
    if (!interp_f) {
        log_error("exec_load: failed to open interpreter %s", interp_path);
        return -1;
    }
    
    Elf32_Ehdr interp_ehdr;
    if (elf_validate(interp_f, &interp_ehdr) != 0) {
        vfs_close(interp_f);
        return -1;
    }
    
    address_space_t *as = address_space_create();
    if (!as) {
        vfs_close(interp_f);
        return -1;
    }
    
    vm_region_t *regions = NULL;
    
    if (elf_load_segments(interp_f, &interp_ehdr, as, &regions) != 0) {
        address_space_destroy(as);
        vfs_close(interp_f);
        // We should really clean up regions if this fails, but panic/exit usually handles it
        return -1;
    }
    
    // Map user stack (4 pages = 16KB)
    switch_address_space(as);
    for (int i = 1; i <= 4; i++) {
        uint32_t stack_page_virt = as->stack_top - (i * PAGE_SIZE);
        phys_addr_t stack_phys = pmm_alloc_frame();
        vmm_map(stack_page_virt, stack_phys, PAGE_PRESENT | PAGE_WRITE | PAGE_USER);
    }
    
    // Create a VM region for the stack so that COW and page faults work
    vm_region_t *stack_region = (vm_region_t *)kmalloc(sizeof(vm_region_t), KMALLOC_ZERO);
    stack_region->start = as->stack_top - (4 * PAGE_SIZE);
    stack_region->end = as->stack_top;
    stack_region->flags = PAGE_PRESENT | PAGE_WRITE | PAGE_USER;
    stack_region->is_anonymous = 1;
    stack_region->is_shared = 0;
    stack_region->is_lazy = 0; // Already eagerly mapped
    
    stack_region->next = regions;
    regions = stack_region;
    
    // Compute heap_base based on the highest loaded ELF segment
    uintptr_t max_end = 0;
    vm_region_t *r = regions;
    while (r) {
        if (r != stack_region && r->end > max_end) {
            max_end = r->end;
        }
        r = r->next;
    }
    
    // Page align and set a small gap (e.g., 4 pages)
    as->heap_base = ((max_end + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1)) + (4 * PAGE_SIZE);
    as->heap_end = as->heap_base;
    
    // mmap_next will start at a safe high address, e.g., 0x60000000
    as->mmap_next = 0x60000000;
    
    Elf32_auxv_t auxv[] = {
        {AT_PHDR, 0}, // Atlas does not map target executable's headers
        {AT_PHENT, sizeof(Elf32_Phdr)},
        {AT_PHNUM, ehdr.e_phnum},
        {AT_PAGESZ, PAGE_SIZE},
        {AT_ENTRY, ehdr.e_entry}, // Target entry point
        {AT_UID, 0},
        {AT_EUID, 0},
        {AT_GID, 0},
        {AT_EGID, 0},
        {AT_PLATFORM, 0},
        {AT_RANDOM, 0},
        {AT_EXECFN, 0}
    };
    int auxc = sizeof(auxv)/sizeof(auxv[0]);
    
    uint32_t initial_sp = build_initial_stack(as->stack_top, argc, argv, envc, envp, auxv, auxc);
    
    switch_address_space(NULL);
    
    out_image->space = as;
    out_image->entry = (void *)interp_ehdr.e_entry;
    out_image->user_stack = (void *)initial_sp;
    out_image->regions = regions;
    
    vfs_close(interp_f);
    log_info("exec_load: loaded %s via interpreter %s", path, interp_path);
    return 0;
}
