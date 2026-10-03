/* context_switch(old_thread, new_thread)
 *
 * Saves callee-saved registers onto the OLD thread's stack,
 * saves esp into old_thread->context.esp,
 * loads esp from new_thread->context.esp,
 * pops callee-saved registers from the NEW thread's stack,
 * and ret jumps to the new thread's saved EIP.
 *
 * C prototype:
 *   void context_switch(thread_t *old, thread_t *new);
 *
 * struct thread layout (offsets):
 *   pid       = 0
 *   name      = 4   (32 bytes)
 *   context   = 36
 *     esp     = 36
 */

.set CTX_ESP, 36

.global context_switch
.type context_switch, @function
context_switch:
    /* Get pointers to old and new thread structs */
    mov 4(%esp), %eax       /* eax = old thread */
    mov 8(%esp), %edx       /* edx = new thread */

    /* Save callee-saved registers onto the OLD stack */
    pushf
    push %ebp
    push %ebx
    push %esi
    push %edi

    /* Save old esp into old thread's context */
    mov %esp, CTX_ESP(%eax)

    /* Load new esp from new thread's context */
    mov CTX_ESP(%edx), %esp

    /* Pop callee-saved registers from the NEW stack */
    pop %edi
    pop %esi
    pop %ebx
    pop %ebp
    popf

    /* ret pops the new thread's saved EIP off its stack */
    ret

.global jump_to_usermode
jump_to_usermode:
    /* void jump_to_usermode(uint32_t entry_point, uint32_t user_stack); */
    mov 4(%esp), %ebx   /* ebx = entry_point */
    mov 8(%esp), %ecx   /* ecx = user_stack */
    
    /* Set up data segments to User Data Segment (0x23) */
    mov $0x23, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    
    /* Set up stack frame for IRET */
    push $0x23          /* SS (User Data Segment) */
    push %ecx           /* User ESP */
    pushf               /* EFLAGS */
    pop %eax
    or $0x200, %eax     /* Enable interrupts in user mode */
    push %eax           /* Push updated EFLAGS */
    push $0x1B          /* CS (User Code Segment) */
    push %ebx           /* EIP (entry_point) */
    
    iret                /* Jump to user space! */

.global fork_ret
fork_ret:
    /* The stack pointer points to the registers_t structure. */
    pop %eax        /* reload the original data segment descriptor */
    mov %ax, %ds
    mov %ax, %es

    popa            /* Pops edi,esi,ebp... */
    add $8, %esp    /* Cleans up the pushed error code and pushed ISR number */
    sti
    iret


.size context_switch, . - context_switch
