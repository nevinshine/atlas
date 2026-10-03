# Atlas Process ABI

This document defines the lifecycle and boundaries of process and execution context creation, execution, and termination in Atlas.

## 1. Process Lifecycle Overview

Processes in Atlas transition through the following states:
1. **Created**: Instantiated via `sys_fork` or `sys_exec`.
2. **Runnable**: Inserted into the kernel scheduler queue.
3. **Running**: Currently executing on a CPU core.
4. **Blocked**: Waiting on IO, Mutex (Futex), or `sys_waitpid`.
5. **Zombie**: Terminated via `sys_exit` but not yet reaped by parent.
6. **Destroyed**: Completely deallocated after parent calls `sys_waitpid`.

## 2. ABI Contracts

### 2.1 Process Creation & `execve()`
- **Semantics**: Replaces the entire address space of the calling process with a new executable image.
- **Ownership**: The Kernel destroys existing VMM mappings, maps the interpreter and executable, and constructs the initial stack.

### 2.2 Process Startup
- **Semantics**: The handoff from Kernel to Userspace.
- **Ownership**: The Kernel transfers control to `Aether`. `Aether` resolves symbols and relocates. `libatlas` initializes the runtime environment. `main()` executes user code.

### 2.3 `fork()`
- **Semantics**: Duplicates the entire address space via Copy-On-Write (COW).
- **Ownership**: The kernel completely owns the memory duplication and VMM setup. `libatlas` exposes the wrapper and handles any userspace `pthread_atfork` locks.

### 2.4 `clone()`
- **Semantics**: Creates a new execution thread sharing the *same* address space.
- **Ownership**: `libatlas` owns stack/TLS/guard allocation. Kernel owns metadata and scheduling.

### 2.5 `exit()`
- **Semantics**: Terminates the calling thread/process.
- **Ownership**: Userspace invokes `sys_exit`. Kernel transitions the task to `Zombie`, closes descriptors, and wakes waiters.

### 2.6 `wait()`
- **Semantics**: Pauses execution until a child process changes state.
- **Ownership**: Userspace calls `sys_waitpid`. Kernel manages the blocking and reaping.

### 2.7 Termination
- **Semantics**: The final teardown of process resources.
- **Ownership**: The kernel translates a reaped `Zombie` into `Destroyed`, fully reclaiming all physical pages, PIDs, and metadata.
