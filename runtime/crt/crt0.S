.global _start
_start:
    # Mark outermost frame
    xor %ebp, %ebp
    
    # Pass initial SP (which is current esp) to __libatlas_start
    # The stack contains:
    # [esp] = argc
    # [esp+4] = argv[0]
    # ...
    # We pass esp as the first argument
    mov %esp, %eax
    
    # Align stack to 16 bytes for ABI compliance
    and $-16, %esp
    
    # push the initial stack pointer as an argument
    sub $12, %esp
    push %eax

    # Call the libatlas CRT entry point
    call __libatlas_start
    
    # __libatlas_start should never return, but if it does, trap
    hlt
