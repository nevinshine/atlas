# Atlas Loader ABI

This document explicitly defines the boundaries and ownership of execution environments during process initialization. Nobody should ever wonder whose job something is.

## Boundary Ownership

### Kernel
Responsible for:
- Address space creation and destruction
- Initial memory mappings (Executable, vDSO)
- Mapping the Interpreter (`Aether`)
- Construction of the Auxiliary Vector (`auxv`)
- Construction of the initial thread stack
- Transferring control to the Interpreter

### Aether (Dynamic Linker)
Responsible for:
- ELF structural validation
- Performing dynamic relocations
- Global symbol resolution
- Initial static TLS image allocation and alignment
- Invoking shared library constructors (`.init_array`)
- Transferring control to `_start`

### libatlas (Runtime Base)
Responsible for:
- Userspace runtime initialization
- Thread runtime management (stack/TLS allocation)
- Core memory management (Heap baseline)
- Standard IO bridging (`stdin`, `stdout`, `stderr`)
- Environment variable parsing

### Application
Responsible for:
- `main()`
- Application-specific user code
