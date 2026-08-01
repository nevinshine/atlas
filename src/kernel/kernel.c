#include "drivers/console.h"
#include "drivers/serial.h"
#include "drivers/timer.h"
#include "kernel/log.h"
#include "arch/x86/gdt.h"
#include "arch/x86/idt.h"
#include "arch/x86/pic.h"
#include "kernel/interrupts.h"

#include "kernel/pmm.h"
#include "kernel/vmm.h"
#include "kernel/heap.h"
#include "kernel/scheduler/scheduler.h"
#include "kernel/scheduler/kthread.h"
#include "kernel/multiboot.h"

#include "kernel/sync/mutex.h"
#include "kernel/scheduler/process.h"
#include "lib/memory.h"
#include "kernel/uaccess.h"
#include "kernel/fs/vfs.h"
#include "kernel/fs/ramfs.h"
#include "kernel/fs/devfs.h"
#include "kernel/exec.h"
#include "kernel/device.h"

// We need a global struct for the test
static process_t *user_proc;
static exec_image_t user_image;

static void user_init_thread(void *arg) {
    (void)arg;
    log_info("Jumping to user mode...");
    process_exec(user_proc, &user_image);
}

static mutex_t test_mutex;

static void mutex_test_thread(void *arg) {
    char *name = (char *)arg;
    
    for (int i = 0; i < 3; i++) {
        log_info("[%s] Attempting to acquire mutex...", name);
        mutex_acquire(&test_mutex);
        log_info("[%s] Acquired mutex! Critical section start.", name);
        
        /* Sleep for 200ms while holding the mutex.
         * Other threads will try to acquire it and be blocked. */
        scheduler_sleep_ms(200);
        
        log_info("[%s] Critical section end. Releasing mutex.", name);
        mutex_release(&test_mutex);
        
        /* Sleep before trying again */
        scheduler_sleep_ms(100);
    }
    
    log_info("[%s] Finished.", name);
}

void kernel_main(multiboot_info_t* mbd, uint32_t magic) {
    console_init();
    log_info("Atlas Kernel (tiny-kernel) Booting in Higher Half...");
    
    // 1. Initialize Global Descriptor Table
    gdt_init();

    // 2. Initialize Interrupts
    idt_init();
    log_info("Architecture Bring-up Complete.");

    // 3. Initialize Physical Memory Manager
    pmm_init(mbd);

    // 4. Initialize Virtual Memory Manager
    vmm_init();

    // 5. Initialize Dynamic Heap
    heap_init();

    // 6. Initialize Scheduler & Timer
    scheduler_init();
    timer_init(100);  /* 100 Hz = 10ms quantum */
    
    // 7. Initialize Syscalls
    extern void syscall_init(void);
    syscall_init();

    // 8. Initialize VFS and RAMFS Initialization
    vfs_init();
    ramfs_init();
    
    // Initialize Device Manager and Core Drivers
    device_manager_init();
    console_dev_init();
    
    devfs_init();
    
    // Mount root and dev
    vfs_mount("/", "ramfs", NULL);
    vfs_mount("/dev", "devfs", NULL);

    // 9. Verification Tests
    log_info("Running VM Isolation Test...");
    process_t *proc_a = process_create("Proc A");
    process_t *proc_b = process_create("Proc B");
    
    // Switch to Proc A and write 42
    switch_address_space(proc_a->address_space);
    vmm_map(0x400000, pmm_alloc_frame(), PAGE_PRESENT | PAGE_WRITE | PAGE_USER);
    volatile uint32_t *addr = (volatile uint32_t *)0x400000;
    *addr = 42;
    
    // Switch to Proc B and write 99
    switch_address_space(proc_b->address_space);
    vmm_map(0x400000, pmm_alloc_frame(), PAGE_PRESENT | PAGE_WRITE | PAGE_USER);
    *addr = 99;
    
    // Switch back to Proc A and verify
    switch_address_space(proc_a->address_space);
    if (*addr == 42) {
        log_info("VM Isolation Test: PASS (Proc A sees 42)");
    } else {
        log_error("VM Isolation Test: FAIL (Proc A sees %d)", *addr);
    }

    // Continue running using Proc A's address space since it has the kernel mapped!

    log_info("Preparing to launch first user process...");
    
    // Privilege Separation Test:
    log_info("Running User Payload Test via VFS...");
    
#include "../user/test_app/user_blob.h"
    
    // Injection and Mutex Tests
    mutex_init(&test_mutex);
    thread_t *mtx1 = thread_create("mtx_test_1", mutex_test_thread, "Thread 1");
    thread_t *mtx2 = thread_create("mtx_test_2", mutex_test_thread, "Thread 2");
    scheduler_enqueue(mtx1);
    scheduler_enqueue(mtx2);
    
    // Inject test app into RAMFS
    ramfs_add_dir("/bin");
    ramfs_add_file("/bin/init", src_user_test_app_user_elf, src_user_test_app_user_elf_len);
    
    user_proc = process_create("user_init");
    
    if (exec_load("/bin/init", &user_image) == 0) {
        thread_t *uthr = thread_create("user_main", user_init_thread, NULL);
        uthr->process = user_proc; // Associate thread with process
        scheduler_enqueue(uthr);
    } else {
        log_error("Failed to load /bin/init");
    }

    log_info("Kernel threads created. Enabling interrupts...");

    /* Enable interrupts — this is the moment Atlas becomes multitasking */
    __asm__ volatile("sti");

    /* The main kernel thread becomes the idle loop.
     * The scheduler will preempt us and run threads A and B. */
    while (1) {
        __asm__ volatile("hlt");
    }
}
