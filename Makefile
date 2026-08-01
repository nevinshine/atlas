CC = gcc
AS = as
LD = gcc

CFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra -Iinclude
ASFLAGS = --32
LDFLAGS = -m32 -ffreestanding -O2 -nostdlib -T linker.ld -Wl,-build-id=none

OBJS = src/boot.o \
       src/arch/x86/gdt_flush.o \
       src/arch/x86/interrupt.o \
       src/arch/x86/switch.o \
       src/arch/x86/gdt.o \
       src/arch/x86/idt.o \
       src/arch/x86/pic.o \
       src/drivers/console.o \
       src/drivers/serial.o \
       src/drivers/timer.o \
       src/lib/string.o \
       src/lib/memory.o \
       src/lib/printf.o \
       src/lib/list.o \
       src/kernel/interrupts.o \
       src/kernel/log.o \
       src/kernel/pmm.o \
       src/kernel/vmm.o \
       src/kernel/heap.o \
       src/kernel/sync/spinlock.o \
       src/kernel/sync/mutex.o \
       src/kernel/sync/waitqueue.o \
       src/kernel/syscall.o \
       src/kernel/uaccess.o \
       src/kernel/fs/vfs.o \
       src/kernel/fs/ramfs.o \
       src/kernel/fs/devfs.o \
       src/kernel/exec.o \
       src/kernel/device.o \
       src/kernel/scheduler/process.o \
       src/kernel/scheduler/thread.o \
       src/kernel/scheduler/scheduler.o \
       src/kernel/scheduler/sleep.o \
       src/kernel/scheduler/kthread.o \
       src/kernel/kernel.o

all: atlas.iso

user_app:
	$(CC) $(CFLAGS) -c src/user/test_app/main.c -o src/user/test_app/main.o
	$(AS) $(ASFLAGS) src/user/atlascrt/syscall.s -o src/user/atlascrt/syscall.o
	$(LD) -m32 -nostdlib -T src/user/test_app/user.ld src/user/test_app/main.o src/user/atlascrt/syscall.o -o src/user/test_app/user.elf
	xxd -i src/user/test_app/user.elf > src/user/test_app/user_blob.h

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.s
	$(AS) $(ASFLAGS) $< -o $@

atlas.bin: user_app $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

atlas.iso: atlas.bin
	mkdir -p iso/boot/grub
	cp atlas.bin iso/boot/atlas.bin
	cp grub.cfg iso/boot/grub/grub.cfg
	grub2-mkrescue -o atlas.iso iso

qemu: atlas.iso
	qemu-system-i386 -cdrom atlas.iso -serial stdio

clean:
	rm -f $(OBJS) atlas.bin atlas.iso
	rm -rf iso/boot/grub
	rm -f iso/boot/atlas.bin
	rm -f src/user/test_app/*.o src/user/atlascrt/*.o src/user/test_app/user.elf src/user/test_app/user_blob.h
