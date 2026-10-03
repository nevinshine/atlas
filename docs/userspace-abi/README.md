# Atlas Userspace ABI

## What is the Atlas Userspace ABI?
The Atlas Userspace ABI is the strict, versioned contract defining how the Atlas Kernel interacts with userspace. It establishes precise boundaries for memory ownership, execution lifecycles, and synchronization, ensuring that userspace environments can be built predictably without undocumented kernel dependencies.

## What documents define it?
This ABI is defined across a modular set of specifications:
- [Process ABI](process.md)
- [Loader ABI](loader.md)
- [Memory ABI](memory.md)
- [TLS ABI](tls.md)
- [Thread ABI](threads.md)
- [Signal ABI](signals.md)
- [vDSO ABI](vdso.md)
- [Versioning](versioning.md)

## Which version is current?
The current active specification is **Version 1.0**.

```text
Atlas Userspace ABI
Version 1.0
Status: Frozen
Date: 2026-08-07
```
