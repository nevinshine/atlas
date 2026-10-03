# Atlas ABI Versioning

This document establishes the versioning semantics for the userspace runtime ABI. The ABI dictates how the kernel and userspace communicate. An evolution of this document establishes a contract that future userspace ecosystems and kernels must strictly follow.

## Current Version

**Atlas Runtime ABI - Version 1.0**

## The Golden Rule

> **The ABI is considered stable once published. Implementations may change, but published ABI semantics must remain compatible unless explicitly versioned.**

## Compatibility Guarantees

### Forward Compatibility
A userspace binary compiled against Version `N` of the ABI must be executable by a kernel enforcing ABI Version `N` or greater. The kernel guarantees it will maintain backwards-compatible syscall layers (or emulated shims) for legacy binaries.

### Backward Compatibility
A kernel compiled for ABI Version `N` is not required to support a userspace application compiled for ABI Version `N+1`. If a new ABI introduces structural differences in `ucontext_t` or auxiliary vectors that an older kernel does not emit, the binary is considered fundamentally incompatible.

## ABI Stability Policy

The following rules define what changes are permissible without bumping the major ABI version:

| Change | Allowed in v1.x? |
| :--- | :--- |
| Bug fix | ✅ |
| Performance improvement | ✅ |
| Internal implementation rewrite | ✅ |
| New optional API | ✅ |
| Structure layout change | ❌ |
| Syscall semantic change | ❌ |
| Process startup change | ❌ |
| TLS layout change | ❌ |

## Deprecation Process

When an interface transitions out of the modern standard, it undergoes strict lifecycle tracking:

1. **Active**: Supported and utilized natively.
2. **Deprecated**: (e.g., `Version 1.0 (Deprecated in 2.0)`). The interface remains fully functional in the kernel, but new SDK headers emit compilation warnings discouraging its use.
3. **Removed**: The kernel completely drops support for the syscall/behavior. Any binary compiled for an ABI version older than the removal date will abort upon invoking the removed path.
