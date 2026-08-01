/* The bootloader will look at this image and start execution at the symbol
   designated as the entry point. */
ENTRY(_start)

/* Higher-half kernel offset */
KERNEL_VIRT_BASE = 0xC0000000;

SECTIONS
{
	/* The kernel will live at 3GB + 1MB in the virtual address space, 
	   but will be physically loaded at 1MB. */
	. = KERNEL_VIRT_BASE + 1M;
	
	kernel_start = .;

	/* First put the multiboot header, as it is required to be put very early
	   early in the image or the bootloader won't recognize the file format.
	   Next we'll put the .text section. 
	   We use AT() to specify the load address (physical) */
	.text BLOCK(4K) : AT(ADDR(.text) - KERNEL_VIRT_BASE) ALIGN(4K)
	{
		*(.multiboot)
		*(.text)
	}

	/* Read-only data. */
	.rodata BLOCK(4K) : AT(ADDR(.rodata) - KERNEL_VIRT_BASE) ALIGN(4K)
	{
		*(.rodata)
	}

	/* Read-write data (initialized) */
	.data BLOCK(4K) : AT(ADDR(.data) - KERNEL_VIRT_BASE) ALIGN(4K)
	{
		*(.data)
	}

	/* Read-write data (uninitialized) and stack */
	.bss BLOCK(4K) : AT(ADDR(.bss) - KERNEL_VIRT_BASE) ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	}
	
	kernel_end = .;

	/* The compiler may produce other sections, by default it will put them in
	   a segment with the same name. Simply add stuff here as needed. */
}
