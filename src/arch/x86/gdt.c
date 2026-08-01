#include "arch/x86/gdt.h"
#include "kernel/log.h"

struct gdt_entry_struct {
    uint16_t limit_low;           // The lower 16 bits of the limit.
    uint16_t base_low;            // The lower 16 bits of the base.
    uint8_t  base_middle;         // The next 8 bits of the base.
    uint8_t  access;              // Access flags, determine what ring this segment can be used in.
    uint8_t  granularity;
    uint8_t  base_high;           // The last 8 bits of the base.
} __attribute__((packed));
typedef struct gdt_entry_struct gdt_entry_t;

struct gdt_ptr_struct {
    uint16_t limit;               // The upper 16 bits of all selector limits.
    uint32_t base;                // The address of the first gdt_entry_t struct.
} __attribute__((packed));
typedef struct gdt_ptr_struct gdt_ptr_t;

extern void gdt_flush(uint32_t);

static gdt_entry_t gdt_entries[6]; // 5 segments + TSS
static gdt_ptr_t   gdt_ptr;
static tss_entry_t tss_entry;

static void gdt_set_gate(int32_t num, uint32_t base, uint32_t limit, uint8_t access, uint8_t gran) {
    gdt_entries[num].base_low    = (base & 0xFFFF);
    gdt_entries[num].base_middle = (base >> 16) & 0xFF;
    gdt_entries[num].base_high   = (base >> 24) & 0xFF;

    gdt_entries[num].limit_low   = (limit & 0xFFFF);
    gdt_entries[num].granularity = (limit >> 16) & 0x0F;

    gdt_entries[num].granularity |= gran & 0xF0;
    gdt_entries[num].access      = access;
}

static void tss_flush(void) {
    __asm__ volatile("mov $0x2B, %ax; ltr %ax"); // 5th segment (0x28) | Ring 3 (0x3) = 0x2B
}

void gdt_init(void) {
    gdt_ptr.limit = (sizeof(gdt_entry_t) * 6) - 1;
    gdt_ptr.base  = (uint32_t)&gdt_entries;

    gdt_set_gate(0, 0, 0, 0, 0);                // Null segment
    gdt_set_gate(1, 0, 0xFFFFFFFF, 0x9A, 0xCF); // Code segment
    gdt_set_gate(2, 0, 0xFFFFFFFF, 0x92, 0xCF); // Data segment
    gdt_set_gate(3, 0, 0xFFFFFFFF, 0xFA, 0xCF); // User mode code segment
    gdt_set_gate(4, 0, 0xFFFFFFFF, 0xF2, 0xCF); // User mode data segment

    // Initialize TSS
    uint32_t tss_base = (uint32_t)&tss_entry;
    uint32_t tss_limit = tss_base + sizeof(tss_entry_t) - 1;
    __builtin_memset(&tss_entry, 0, sizeof(tss_entry_t));
    tss_entry.ss0 = 0x10;  // Kernel Data Segment
    tss_entry.iomap_base = sizeof(tss_entry_t);
    
    // Add TSS to GDT (Access: 0x89 for available 32-bit TSS)
    gdt_set_gate(5, tss_base, tss_limit, 0x89, 0x00);

    gdt_flush((uint32_t)&gdt_ptr);
    tss_flush();
    log_info("GDT initialized (with TSS).");
}

#include "kernel/scheduler/thread.h"
void tss_prepare(thread_t *thread) {
    if (thread) {
        tss_entry.esp0 = (uint32_t)thread->kernel_stack + thread->kernel_stack_size;
    }
}

