# ADR 0006 — Atlas Thread/TLS Model

## Status
Accepted

## Context
With the introduction of threading and Thread-Local Storage (TLS) in Phase 3.4, Atlas needs a well-defined boundary for how threads, processes, and TLS interact, both in the kernel and userspace.

Specifically, we need to establish:
1. The kernel-level distinction between processes and threads.
2. How the `%gs` segment for TLS is managed and supplied to the execution context.
3. How userspace execution begins for new threads.
4. How thread termination and joining behave.

## Decision

### 1. Process vs. Thread Distinction
The kernel structures will explicitly decouple processes from threads:

**Process (`process_t`)** Owns:
- Address space (VM regions, page directory)
- File descriptor table
- Process identity and parent/child relationship

**Thread (`thread_t`)** Owns:
- Register state (execution context)
- Kernel stack
- User stack bounds
- TLS base (`tls_base`)
- Scheduler state and Thread ID
- Exit state

### 2. TLS Management (Variant II)
TLS allocation and initialization remain strictly userspace/runtime responsibilities (`libatlas`). Atlas threads share a process address space but possess independent TLS.
- The TLS base pointer (the TCB address) is supplied by userspace as part of thread creation (`sys_clone`).
- It is maintained by the kernel as part of the `thread_t` state.
- During context switching, the kernel restores the current thread's TLS base through an Atlas-managed `%gs` descriptor in the GDT. The GDT selector remains constant, but the descriptor's base address is updated per-CPU during the context switch.
- We will NOT implement a Linux-style `sys_set_thread_area`.

### 3. Userspace Thread Trampoline
The kernel's `sys_clone` primitive operates purely on execution context (stack, registers, TLS base). It does not understand function pointers, arguments, or thread exit semantics.
- `libatlas`'s `atlas_thread_create(fn, arg)` will construct a userspace trampoline on the new thread's stack.
- When `sys_clone` returns in the new thread, it executes the trampoline.
- The trampoline invokes `fn(arg)` and unconditionally calls `atlas_thread_exit()` upon return, guaranteeing safe termination.

### 4. Thread Exit and Reaping
Thread joining and termination require kernel awareness to properly release the kernel stack, thread ID, and record exit status.
- `sys_thread_exit` will record the thread's termination state and pause execution.
- `sys_thread_join` will allow another thread (or process) to wait for termination and reap the kernel-side resources of the deceased thread.

## Consequences
- The kernel remains clean of userspace runtime semantics (like `pthread_create` and function calling conventions).
- Thread and Process structures will require refactoring in the kernel scheduler.
- A single GDT entry per CPU is sufficient for `%gs` TLS bases.
