#include "kernel/vmm.h"
#include "kernel/pmm.h"
#include "kernel/interrupts.h"
#include "kernel/log.h"
#include "lib/memory.h"
#include "kernel/scheduler/thread.h"
#include "kernel/scheduler/process.h"

// Access page tables via recursive mapping
static uint32_t *const page_directory = (uint32_t *)0xFFFFF000;
static uint32_t *const page_tables = (uint32_t *)0xFFC00000;

static void page_fault_handler(registers_t *regs) {
    uint32_t faulting_address;
    __asm__ volatile("mov %%cr2, %0" : "=r" (faulting_address));

    int present   = regs->err_code & 0x1;    // Page present?
    int rw        = regs->err_code & 0x2;    // Write operation?
    int us        = regs->err_code & 0x4;    // Processor was in user-mode?
    int reserved  = regs->err_code & 0x8;    // Overwritten CPU-reserved bits of page entry?
    int id        = regs->err_code & 0x10;   // Caused by an instruction fetch?
    
    // Demand Paging & COW Logic
    if (us || faulting_address < 0xC0000000) {
        extern thread_t *current_thread;
        if (current_thread && current_thread->process) {
            process_t *proc = current_thread->process;
            vm_region_t *curr = proc->vm_regions;
            while (curr) {
                if (faulting_address >= curr->start && faulting_address < curr->end) {
                    uint32_t page_aligned = faulting_address & 0xFFFFF000;
                    
                    if (!present) {
                        // Demand Paging
                        phys_addr_t paddr = pmm_alloc_frame();
                        if (!paddr) panic("Out of memory during demand paging!");
                        
                        vmm_map(page_aligned, paddr, curr->flags);
                        memset((void *)page_aligned, 0, PAGE_SIZE);
                        
                        if (curr->file && curr->file->node && curr->file->node->ops->read) {
                            uint32_t file_offset = curr->offset + (page_aligned - curr->start);
                            uint32_t to_read = PAGE_SIZE;
                            if (file_offset < curr->file->node->size) {
                                if (file_offset + to_read > curr->file->node->size) {
                                    to_read = curr->file->node->size - file_offset;
                                }
                                curr->file->node->ops->read(curr->file, (void *)page_aligned, to_read, file_offset);
                            }
                        }
                        return; // Successfully resolved page fault
                        
                    } else if (present && rw) {
                        // Check if this is a Copy-On-Write fault
                        if (curr->flags & PAGE_WRITE) {
                            phys_addr_t old_paddr = vmm_translate(page_aligned) & 0xFFFFF000;
                            
                            // Allocate a new physical frame
                            phys_addr_t new_paddr = pmm_alloc_frame();
                            if (!new_paddr) panic("Out of memory during COW!");
                            
                            // Temporarily map it to copy data
                            uint32_t temp_virt = 0xE0001000;
                            vmm_map(temp_virt, new_paddr, PAGE_PRESENT | PAGE_WRITE);
                            memcpy((void *)temp_virt, (void *)page_aligned, PAGE_SIZE);
                            vmm_unmap(temp_virt);
                            
                            // Remap the original virtual address to the new frame, making it writable
                            vmm_map(page_aligned, new_paddr, curr->flags);
                            
                            // Decrease refcount of the old physical frame
                            pmm_free_frame(old_paddr);
                            
                            return; // Successfully resolved COW fault
                        }
                        // If it's present, a write fault, but the region does NOT have PAGE_WRITE,
                        // this is a genuine protection violation. Break out to error reporting.
                        break;
                    }
                }
                curr = curr->next;
            }
        }
    }

    log_error("========== PAGE FAULT ==========");
    log_error("Virtual Address : 0x%x", faulting_address);
    log_error("Present         : %s", present ? "No" : "Yes");
    log_error("Write           : %s", rw ? "Yes" : "No");
    log_error("User            : %s", us ? "Yes" : "No");
    log_error("Reserved        : %s", reserved ? "Yes" : "No");
    log_error("Instruction     : %s", id ? "Yes" : "No");
    log_error("EIP             : 0x%x", regs->eip);
    log_error("ESP             : 0x%x", regs->useresp);
    
    if (us) {
        if (present && rw) {
            log_error("Cause           : Protection Violation (Write to read-only memory)");
        } else if (!present) {
            log_error("Cause           : Unmapped Address (Segmentation Fault)");
        } else {
            log_error("Cause           : Access Violation");
        }
    } else {
        log_error("Cause           : Kernel Page Fault");
    }
    
    log_error("================================");
    if (us) {
        log_error("User-mode page fault! Terminating process.");
        
        if (current_thread && current_thread->process) {
            process_t *proc = current_thread->process;
            vm_region_t *curr = proc->vm_regions;
            log_error("VM Regions for PID %d:", proc->pid);
            while (curr) {
                log_error("  0x%x - 0x%x (Flags: 0x%x, Anon: %d, Lazy: %d)", curr->start, curr->end, curr->flags, curr->is_anonymous, curr->is_lazy);
                curr = curr->next;
            }
        }
        
        extern void process_exit(int status);
        process_exit(139);
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

bool vmm_check_user_access(uint32_t virt, size_t size, bool write) {
    if (size == 0) return true;
    if (virt >= 0xC0000000) return false;
    
    uint32_t start_page = virt & 0xFFFFF000;
    uint32_t end_page = (virt + size - 1) & 0xFFFFF000;
    
    if (end_page < start_page || end_page >= 0xC0000000) return false;
    
    for (uint32_t page = start_page; page <= end_page; page += 4096) {
        uint32_t pd_index = page >> 22;
        uint32_t pt_index = (page >> 12) & 0x03FF;
        
        bool present = false;
        if (page_directory[pd_index] & PAGE_PRESENT) {
            uint32_t *pt = (uint32_t *)(0xFFC00000 + (pd_index * 4096));
            uint32_t entry = pt[pt_index];
            if (entry & PAGE_PRESENT) {
                if (!(entry & PAGE_USER)) return false;
                if (write && (!(entry & PAGE_WRITE))) return false;
                present = true;
            }
        }
        
        if (!present) {
            // Not present in page tables, check if it's in a valid vm_region for demand paging
            extern thread_t *current_thread;
            if (!current_thread || !current_thread->process) return false;
            
            bool found = false;
            vm_region_t *curr = current_thread->process->vm_regions;
            while (curr) {
                if (page >= (curr->start & 0xFFFFF000) && page < curr->end) {
                    if (write && !(curr->flags & PAGE_WRITE)) return false;
                    found = true;
                    break;
                }
                curr = curr->next;
            }
            if (!found) return false;
        }
    }
    
    return true;
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

uint32_t *vmm_clone_address_space(void) {
    phys_addr_t new_dir_phys = pmm_alloc_frame();
    if (!new_dir_phys) return NULL;
    
    uint32_t temp_virt = 0xE0002000;
    vmm_map(temp_virt, new_dir_phys, PAGE_PRESENT | PAGE_WRITE);
    uint32_t *new_dir = (uint32_t *)temp_virt;
    memset(new_dir, 0, 4096);
    
    // Copy kernel PDEs (768 to 1023)
    for (int i = 768; i < 1023; i++) {
        new_dir[i] = page_directory[i];
    }
    
    // Recursive mapping
    new_dir[1023] = new_dir_phys | PAGE_PRESENT | PAGE_WRITE;
    
    // Copy user PDEs (0 to 767) with COW
    for (int i = 0; i < 768; i++) {
        if (page_directory[i] & PAGE_PRESENT) {
            phys_addr_t new_pt_phys = pmm_alloc_frame();
            new_dir[i] = new_pt_phys | (page_directory[i] & 0xFFF);
            
            uint32_t temp_pt_virt = 0xE0003000;
            vmm_map(temp_pt_virt, new_pt_phys, PAGE_PRESENT | PAGE_WRITE);
            uint32_t *new_pt = (uint32_t *)temp_pt_virt;
            
            uint32_t *src_pt = (uint32_t *)(0xFFC00000 + (i * 4096));
            for (int j = 0; j < 1024; j++) {
                if (src_pt[j] & PAGE_PRESENT) {
                    if (src_pt[j] & PAGE_WRITE) {
                        src_pt[j] &= ~PAGE_WRITE;
                        vmm_invalidate((i << 22) | (j << 12));
                    }
                    new_pt[j] = src_pt[j];
                    pmm_ref_frame(src_pt[j] & 0xFFFFF000);
                } else {
                    new_pt[j] = 0;
                }
            }
            vmm_unmap(temp_pt_virt);
        }
    }
    
    vmm_unmap(temp_virt);
    return (uint32_t *)new_dir_phys;
}

void vmm_destroy_directory(uint32_t *phys_dir) {
    if (!phys_dir) return;
    
    uint32_t temp_virt = 0xE0002000;
    vmm_map(temp_virt, (phys_addr_t)phys_dir, PAGE_PRESENT | PAGE_WRITE);
    uint32_t *dir = (uint32_t *)temp_virt;
    
    for (int i = 0; i < 768; i++) {
        if (dir[i] & PAGE_PRESENT) {
            phys_addr_t pt_phys = dir[i] & 0xFFFFF000;
            
            uint32_t temp_pt_virt = 0xE0003000;
            vmm_map(temp_pt_virt, pt_phys, PAGE_PRESENT | PAGE_WRITE);
            uint32_t *pt = (uint32_t *)temp_pt_virt;
            
            for (int j = 0; j < 1024; j++) {
                if (pt[j] & PAGE_PRESENT) {
                    pmm_free_frame(pt[j] & 0xFFFFF000);
                }
            }
            vmm_unmap(temp_pt_virt);
            pmm_free_frame(pt_phys);
        }
    }
    
    vmm_unmap(temp_virt);
    pmm_free_frame((phys_addr_t)phys_dir);
}

void vmm_switch_directory(uint32_t *phys_dir) {
    __asm__ volatile("mov %0, %%cr3" :: "r"((uint32_t)phys_dir) : "memory");
}
