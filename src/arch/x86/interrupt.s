.macro ISR_NOERRCODE num
.global isr\num
isr\num:
    cli
    push $0        /* push dummy error code */
    push $\num     /* push interrupt number */
    jmp isr_common_stub
.endm

.macro ISR_ERRCODE num
.global isr\num
isr\num:
    cli
    /* error code is already pushed by CPU */
    push $\num     /* push interrupt number */
    jmp isr_common_stub
.endm

.macro IRQ num, irq_num
.global irq\irq_num
irq\irq_num:
    cli
    push $0
    push $\num
    jmp isr_common_stub
.endm

ISR_NOERRCODE 0
ISR_NOERRCODE 1
ISR_NOERRCODE 2
ISR_NOERRCODE 3
ISR_NOERRCODE 4
ISR_NOERRCODE 5
ISR_NOERRCODE 6
ISR_NOERRCODE 7
ISR_ERRCODE   8
ISR_NOERRCODE 9
ISR_ERRCODE   10
ISR_ERRCODE   11
ISR_ERRCODE   12
ISR_ERRCODE   13
ISR_ERRCODE   14
ISR_NOERRCODE 15
ISR_NOERRCODE 16
ISR_NOERRCODE 17
ISR_NOERRCODE 18
ISR_NOERRCODE 19
ISR_NOERRCODE 20
ISR_NOERRCODE 21
ISR_NOERRCODE 22
ISR_NOERRCODE 23
ISR_NOERRCODE 24
ISR_NOERRCODE 25
ISR_NOERRCODE 26
ISR_NOERRCODE 27
ISR_NOERRCODE 28
ISR_NOERRCODE 29
ISR_NOERRCODE 30
ISR_NOERRCODE 31

IRQ 32, 0
IRQ 33, 1
IRQ 34, 2
IRQ 35, 3
IRQ 36, 4
IRQ 37, 5
IRQ 38, 6
IRQ 39, 7
IRQ 40, 8
IRQ 41, 9
IRQ 42, 10
IRQ 43, 11
IRQ 44, 12
IRQ 45, 13
IRQ 46, 14
IRQ 47, 15

ISR_NOERRCODE 128

.extern interrupt_dispatch

isr_common_stub:
    pusha           /* Pushes edi,esi,ebp,esp,ebx,edx,ecx,eax */
    
    mov %ds, %ax    /* Lower 16-bits of eax = ds. */
    push %eax       /* save the data segment descriptor */

    mov $0x10, %ax  /* load the kernel data segment descriptor */
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs

    push %esp       /* Pass pointer to registers_t to interrupt_dispatch */
    call interrupt_dispatch
    add $4, %esp    /* Clean up the pushed pointer */

    pop %eax        /* reload the original data segment descriptor */
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs

    popa            /* Pops edi,esi,ebp... */
    add $8, %esp    /* Cleans up the pushed error code and pushed ISR number */
    sti
    iret            /* pops 5 things at once: CS, EIP, EFLAGS, SS, and ESP */
