#include "kernel/exec.h"
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
    
    if (out_ehdr->e_type != ET_EXEC) {
        log_error("exec_load: Not an executable");
        return -1;
    }
    
    if (out_ehdr->e_machine != EM_386) {
        log_error("exec_load: Not an x86 executable");
        return -1;
    }
    
    return 0;
}

static int elf_load_segments(file_t *f, Elf32_Ehdr *ehdr, address_space_t *as) {
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

int exec_load(const char *path, exec_image_t *out_image) {
    if (!out_image) return -1;
    
    file_t *f = vfs_open(path, 0); // O_RDONLY equivalent
    if (!f) {
        log_error("exec_load: failed to open %s", path);
        return -1;
    }
    
    Elf32_Ehdr ehdr;
    if (elf_validate(f, &ehdr) != 0) {
        vfs_close(f);
        return -1;
    }
    
    address_space_t *as = address_space_create();
    if (!as) {
        vfs_close(f);
        return -1;
    }
    
    if (elf_load_segments(f, &ehdr, as) != 0) {
        address_space_destroy(as);
        vfs_close(f);
        return -1;
    }
    
    // Map user stack
    switch_address_space(as);
    uint32_t stack_page_virt = as->stack_top - PAGE_SIZE;
    phys_addr_t stack_phys = pmm_alloc_frame();
    vmm_map(stack_page_virt, stack_phys, PAGE_PRESENT | PAGE_WRITE | PAGE_USER);
    switch_address_space(NULL);
    
    out_image->space = as;
    out_image->entry = (void *)ehdr.e_entry;
    out_image->user_stack = (void *)as->stack_top;
    
    vfs_close(f);
    log_info("exec_load: loaded ELF %s", path);
    return 0;
}
