/* boot.s - Bootloader entry point for tiny-kernel */

/* Multiboot constants */
.set ALIGN,    1<<0             /* align loaded modules on page boundaries */
.set MEMINFO,  1<<1             /* provide memory map */
.set FLAGS,    ALIGN | MEMINFO  /* this is the Multiboot 'flag' field */
.set MAGIC,    0x1BADB002       /* 'magic number' lets bootloader find the header */
.set CHECKSUM, -(MAGIC + FLAGS) /* checksum of above, to prove we are multiboot */

/* 
 * Multiboot header 
 * Must be in the first 8 KB of the kernel file, 32-bit aligned.
 */
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/* Stack setup */
.section .bss
.align 16
stack_bottom:
.skip 16384 /* 16 KiB */
stack_top:

/* Initial Page Directory and Page Table for identity mapping and higher-half mapping */
.align 4096
.global boot_page_directory
boot_page_directory:
.skip 4096
boot_page_table1:
.skip 4096

/*
 * Kernel Entry Point
 */
.section .text
.global _start
.type _start, @function
_start:
    /* Set up a physical stack so we can push */
    mov $(stack_top - 0xC0000000), %esp

    /* We must preserve %eax and %ebx for Multiboot */
    push %eax
    push %ebx

    /* Build identity map of first 4MB (for boot sequence) and higher-half map */
    /* Map boot_page_table1 to 0x00000000 and 0xC0000000 */
    mov $(boot_page_table1 - 0xC0000000 + 0x003), %eax
    mov $(boot_page_directory - 0xC0000000), %edi
    mov %eax, 0(%edi)       /* Identity map first 4MB */
    mov %eax, 3072(%edi)    /* Map to 0xC0000000 (entry 768 * 4 bytes = 3072) */

    /* Map recursive entry: PD[1023] = PD */
    mov $(boot_page_directory - 0xC0000000 + 0x003), %eax
    mov %eax, 4092(%edi)    /* Entry 1023 * 4 = 4092 */

    /* Fill boot_page_table1 with physical addresses 0x0 - 0x400000 */
    mov $0, %ecx
    mov $(boot_page_table1 - 0xC0000000), %edi
.fill_table:
    mov %ecx, %eax
    shl $12, %eax           /* Multiply by 4096 to get physical address */
    or $0x003, %eax         /* Present + Writable */
    mov %eax, (%edi, %ecx, 4)
    inc %ecx
    cmp $1024, %ecx
    jne .fill_table

    /* Enable paging */
    mov $(boot_page_directory - 0xC0000000), %eax
    mov %eax, %cr3

    mov %cr0, %eax
    or $0x80000000, %eax    /* Set PG bit */
    mov %eax, %cr0

    /* Far jump to higher half */
    lea higher_half, %ecx
    jmp *%ecx

higher_half:
    /* We are now executing in the higher half! */
    
    /* Translate the stack pointer to a virtual address */
    add $0xC0000000, %esp

    /* Restore %eax and %ebx */
    pop %ebx
    pop %eax

    /* Translate %ebx (Multiboot struct) to virtual address */
    add $0xC0000000, %ebx

    /* Push multiboot info struct pointer and magic number */
    push %eax  /* magic (2nd argument) */
    push %ebx  /* mbd (1st argument) */

    /* Transfer control to the main kernel */
    call kernel_main

    /* If kernel_main returns, halt the CPU */
    cli
1:  hlt
    jmp 1b

/* Set the size of the _start symbol for debugging */
.size _start, . - _start
