# ADR 0004: Futex Design

## Problem
Thread synchronization requires both userspace atomic operations (for speed) and kernel-level sleeping/waking (for fairness and CPU yield when contended). We must decide on the mechanism bridging userspace synchronization constructs and the kernel scheduler.

## Options Considered
1. **Kernel Mutexes**: Every mutex lock/unlock is a syscall.
2. **Signals/Pipes**: Threads block by reading from a pipe or waiting for a signal.
3. **Futex (Fast Userspace Mutex)**: Userspace handles uncontended locks atomically. The kernel is only invoked to sleep or wake threads when contention occurs, keyed by a userspace virtual address.

## Decision
We will implement the **Futex** ABI.
- The kernel exposes exactly one synchronization syscall: `sys_futex(addr, op, val)`.
- `libatlas` implements all high-level constructs (`Mutex`, `CondVar`, `RWLock`, `Once`) purely in userspace, invoking `sys_futex` only on contention.

## Consequences
- **Positive**: Uncontended locks are resolved in a few CPU cycles (pure userspace atomic instructions) with zero syscall overhead.
- **Positive**: Simplifies the kernel API drastically (only one syscall handles all wait/wake logic).
- **Negative**: Implementing correct Futex wrappers in userspace is notoriously complex and prone to race conditions if not carefully engineered.
