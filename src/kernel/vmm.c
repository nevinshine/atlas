#include "kernel/vmm.h"
#include "kernel/pmm.h"
#include "kernel/interrupts.h"
#include "kernel/log.h"
#include "lib/memory.h"

// Access page tables via recursive mapping
static uint32_t *const page_directory = (uint32_t *)0xFFFFF000;
static uint32_t *const page_tables = (uint32_t *)0xFFC00000;

static void page_fault_handler(registers_t *regs) {
    uint32_t faulting_address;
    __asm__ volatile("mov %%cr2, %0" : "=r" (faulting_address));

    int present   = !(regs->err_code & 0x1); // Page not present
    int rw        = regs->err_code & 0x2;    // Write operation?
    int us        = regs->err_code & 0x4;    // Processor was in user-mode?
    int reserved  = regs->err_code & 0x8;    // Overwritten CPU-reserved bits of page entry?
    int id        = regs->err_code & 0x10;   // Caused by an instruction fetch?

    log_error("========== PAGE FAULT ==========");
    log_error("Virtual Address : 0x%x", faulting_address);
    log_error("Present         : %s", present ? "No" : "Yes");
    log_error("Write           : %s", rw ? "Yes" : "No");
    log_error("User            : %s", us ? "Yes" : "No");
    log_error("Reserved        : %s", reserved ? "Yes" : "No");
    log_error("Instruction     : %s", id ? "Yes" : "No");
    log_error("EIP             : 0x%x", regs->eip);
    log_error("================================");
    if (us) {
        log_error("User-mode page fault! Terminating process.");
        extern void scheduler_exit_current(void);
        scheduler_exit_current();
        return;
    }
    
    panic("Kernel Page fault");
}

void vmm_init(void) {
    register_interrupt_handler(14, page_fault_handler);

    // Unmap the identity map at the bottom 4MB created in boot.s
    page_directory[0] = 0;
    vmm_invalidate(0);
    
    log_info("VMM initialized. Identity map removed.");
}

void vmm_invalidate(uint32_t virt) {
    __asm__ volatile("invlpg (%0)" ::"r" (virt) : "memory");
}

void vmm_map(uint32_t virt, uint32_t phys, uint32_t flags) {
    uint32_t pd_index = virt >> 22;
    uint32_t pt_index = (virt >> 12) & 0x03FF;

    if (!(page_directory[pd_index] & PAGE_PRESENT)) {
        // Allocate a new page table
        phys_addr_t new_table_phys = pmm_alloc_frame();
        page_directory[pd_index] = new_table_phys | PAGE_PRESENT | PAGE_WRITE | PAGE_USER;
        
        // Clear the new page table
        uint32_t *pt = (uint32_t *)(0xFFC00000 + (pd_index * 4096));
        memset(pt, 0, 4096);
    }

    uint32_t pt_virtual_addr = 0xFFC00000 + (pd_index * 4096);
    uint32_t *pt = (uint32_t *)pt_virtual_addr;
    pt[pt_index] = (phys & 0xFFFFF000) | (flags & 0xFFF) | PAGE_PRESENT;
    vmm_invalidate(virt);
}

void vmm_unmap(uint32_t virt) {
    uint32_t pd_index = virt >> 22;
    uint32_t pt_index = (virt >> 12) & 0x03FF;

    if (page_directory[pd_index] & PAGE_PRESENT) {
        uint32_t *pt = (uint32_t *)(0xFFC00000 + (pd_index * 4096));
        pt[pt_index] = 0;
        vmm_invalidate(virt);
    }
}

uint32_t vmm_translate(uint32_t virt) {
    uint32_t pd_index = virt >> 22;
    uint32_t pt_index = (virt >> 12) & 0x03FF;

    if (page_directory[pd_index] & PAGE_PRESENT) {
        uint32_t *pt = (uint32_t *)(0xFFC00000 + (pd_index * 4096));
        if (pt[pt_index] & PAGE_PRESENT) {
            return (pt[pt_index] & 0xFFFFF000) | (virt & 0xFFF);
        }
    }
    return 0;
}

bool vmm_is_mapped(uint32_t virt) {
    uint32_t pd_index = virt >> 22;
    uint32_t pt_index = (virt >> 12) & 0x03FF;

    if (page_directory[pd_index] & PAGE_PRESENT) {
        uint32_t *pt = (uint32_t *)(0xFFC00000 + (pd_index * 4096));
        if (pt[pt_index] & PAGE_PRESENT) {
            return true;
        }
    }
    return false;
}

uint32_t *vmm_clone_directory(void) {
    phys_addr_t new_dir_phys = pmm_alloc_frame();
    if (!new_dir_phys) return NULL;
    
    // We need to map this physical frame somewhere temporarily to copy into it.
    // We can use a temporary mapping at the top of the kernel heap, or map it dynamically.
    // For simplicity, we map it to 0xE0000000 temporarily.
    uint32_t temp_virt = 0xE0000000;
    vmm_map(temp_virt, new_dir_phys, PAGE_PRESENT | PAGE_WRITE);
    
    uint32_t *new_dir = (uint32_t *)temp_virt;
    memset(new_dir, 0, 4096);
    
    // Link kernel page tables (768 to 1023)
    for (int i = 768; i < 1023; i++) {
        new_dir[i] = page_directory[i];
    }
    
    // Recursive mapping for the new directory itself
    new_dir[1023] = new_dir_phys | PAGE_PRESENT | PAGE_WRITE;
    
    vmm_unmap(temp_virt);
    
    return (uint32_t *)new_dir_phys;
}

void vmm_switch_directory(uint32_t *phys_dir) {
    __asm__ volatile("mov %0, %%cr3" :: "r"((uint32_t)phys_dir) : "memory");
}
