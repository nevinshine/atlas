# Atlas Thread ABI

This document defines the lifecycle ownership, behavior, and synchronization of execution threads in Atlas.

## 1. Thread Lifecycle

Threads transition through the following states:

1. **Created**: Instantiated but not yet scheduled.
2. **Runnable**: Registered in the kernel runqueue.
3. **Running**: Executing on a CPU core.
4. **Blocked**: Waiting on a Futex, Mutex, or I/O.
5. **Zombie**: Finished execution, waiting to be joined.
6. **Destroyed**: Completely deallocated.

## 2. Synchronization Ownership

Synchronization is cleanly divided between the Kernel (mechanisms) and Userspace (policies and wrappers).

### Kernel
Responsible for raw wait/wake mechanisms:
- **Futex** (`sys_futex`): The only kernel-level synchronization primitive exposed to userspace. 

### libatlas
Responsible for all userspace high-level synchronization constructs, backed by atomic operations and `sys_futex`:
- **Mutex**: Mutual exclusion locks.
- **Condition Variable**: Event signaling and wait queues.
- **RWLock**: Read/Write concurrency locks.
- **Once**: Thread-safe single execution guarantees.

## 3. Lifecycle Transitions & Ownership

- **Creation**: `libatlas` allocates stack/TLS/guard and invokes `sys_clone`. `Kernel` allocates metadata.
- **Execution**: `Kernel` owns scheduling. `libatlas` owns userspace blocking (via Futex).
- **Termination**: Trampoline calls `sys_exit_thread`. `Kernel` marks as Zombie and wakes waiters.
- **Cleanup**: `libatlas` (`pthread_join`) calls `sys_munmap` to free userspace resources. `Kernel` reclaims dead tracking metadata.
