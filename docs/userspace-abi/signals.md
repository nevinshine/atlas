# Atlas Signal ABI

This document defines the semantics of asynchronous signal delivery and state restoration.

## 1. Core Philosophy
The kernel handles the injection of the signal, but userspace natively owns the signal return path. The kernel never directly executes `sys_sigreturn`. Instead, it manipulates the thread's execution state such that userspace naturally executes a `sigreturn` trampoline upon completion of the handler.

## 2. Signal Delivery Process

When a signal is delivered to a userspace thread, the Kernel performs the following steps:

1. **Interrupt / Suspend**: The kernel interrupts the thread's normal execution.
2. **Allocate Signal Frame**: The kernel allocates space on the thread's userspace stack. If the thread provides an alternate signal stack (`sigaltstack`), the kernel utilizes it.
3. **Save Context**: The kernel pushes a `ucontext_t` struct onto the stack. This structure captures the complete state of the thread prior to the signal (General Purpose Registers, Instruction Pointer, Flags, and FPU State).
4. **Push `siginfo_t`**: The kernel pushes a `siginfo_t` struct containing diagnostic information (e.g., faulting address for `SIGSEGV`, sender PID for `SIGKILL`).
5. **Set Return Address**: The kernel pushes the address of the `__vdso_sigreturn` trampoline as the standard return address on the stack.
6. **Execute Handler**: The kernel sets `%eip` (Instruction Pointer) to the address of the registered userspace signal handler.
7. **Resume**: The kernel resumes the thread.

## 3. Signal Return Process

When the userspace signal handler completes execution:

1. The `ret` instruction is executed.
2. The CPU pops the return address off the stack. Because the kernel pushed `__vdso_sigreturn`, execution immediately jumps into the vDSO memory space.
3. **`__vdso_sigreturn`**: This executable trampoline contains the raw syscall sequence for `sys_sigreturn`.
4. The `sys_sigreturn` syscall is processed by the kernel.
5. The kernel unpacks the `ucontext_t` structure from the stack and fully restores the thread's hardware state to exactly how it was before the signal occurred.
6. Execution resumes seamlessly in the interrupted userspace code.
