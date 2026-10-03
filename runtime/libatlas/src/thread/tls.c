#include <atlas/boot.h>
#include <kernel/elf.h>
#include <atlas/memory.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>

extern unsigned long getauxval(unsigned long type);

typedef struct {
    void *tcb;
    void *dtv; // dynamic thread vector (not used yet)
    void *self; // some systems use this too
    int tid;
} tcb_t;

// We need to find the PT_TLS header to know size and alignment
static Elf32_Phdr *get_tls_phdr(void) {
    Elf32_Phdr *phdr = (Elf32_Phdr *)getauxval(AT_PHDR);
    if (!phdr) return NULL;
    
    int phnum = getauxval(AT_PHNUM);
    for (int i = 0; i < phnum; i++) {
        if (phdr[i].p_type == PT_TLS) {
            return &phdr[i];
        }
    }
    return NULL;
}

#define ALIGN_UP(x, align) (((x) + (align) - 1) & ~((align) - 1))

void *atlas_tls_allocate(void) {
    Elf32_Phdr *tls_phdr = get_tls_phdr();
    
    size_t tls_size = 0;
    size_t tls_align = 8;
    
    if (tls_phdr) {
        tls_size = tls_phdr->p_memsz;
        if (tls_phdr->p_align > tls_align) {
            tls_align = tls_phdr->p_align;
        }
    }
    
    // Variant II layout:
    // [ TLS DATA (memsz) ][ Padding for TCB alignment ][ TCB ]
    // The TP points to TCB.
    
    size_t offset = ALIGN_UP(tls_size, tls_align);
    size_t total_size = offset + sizeof(tcb_t);
    
    // Allocate the memory using atlas_malloc
    void *mem = atlas_malloc(total_size);
    if (!mem) return NULL;
    
    void *tp = (char *)mem + offset;
    tcb_t *tcb = (tcb_t *)tp;
    tcb->tcb = tcb;
    tcb->dtv = NULL;
    tcb->self = tcb;
    tcb->tid = 0; // Filled later
    
    return tp;
}

void atlas_tls_init(void *tp) {
    if (!tp) return;
    
    Elf32_Phdr *phdr_base = (Elf32_Phdr *)getauxval(AT_PHDR);
    int phnum = getauxval(AT_PHNUM);
    if (!phdr_base) return;

    Elf32_Phdr *tls_phdr = NULL;
    uintptr_t load_bias = 0;
    
    for (int i = 0; i < phnum; i++) {
        if (phdr_base[i].p_type == PT_PHDR) {
            load_bias = (uintptr_t)phdr_base - phdr_base[i].p_vaddr;
        }
        if (phdr_base[i].p_type == PT_TLS) {
            tls_phdr = &phdr_base[i];
        }
    }
    
    if (!tls_phdr) return;
    
    size_t tls_size = tls_phdr->p_memsz;
    size_t tls_align = tls_phdr->p_align;
    if (tls_align < 8) tls_align = 8;
    
    size_t offset = ALIGN_UP(tls_size, tls_align);
    
    void *tls_data_start = (char *)tp - offset;
    
    // Copy .tdata
    if (tls_phdr->p_filesz > 0) {
        memcpy(tls_data_start, (void *)(tls_phdr->p_vaddr + load_bias), tls_phdr->p_filesz);
    }
    
    // Zero .tbss
    if (tls_phdr->p_memsz > tls_phdr->p_filesz) {
        memset((char *)tls_data_start + tls_phdr->p_filesz, 0, 
               tls_phdr->p_memsz - tls_phdr->p_filesz);
    }
}

void atlas_tls_free(void *tp) {
    if (!tp) return;
    
    Elf32_Phdr *tls_phdr = get_tls_phdr();
    size_t tls_size = tls_phdr ? tls_phdr->p_memsz : 0;
    size_t tls_align = tls_phdr ? tls_phdr->p_align : 8;
    if (tls_align < 8) tls_align = 8;
    
    size_t offset = ALIGN_UP(tls_size, tls_align);
    void *mem = (char *)tp - offset;
    
    atlas_free(mem);
}
