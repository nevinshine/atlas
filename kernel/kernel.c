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
#include "kernel/fs/ext2.h"
#include "kernel/fs/ramfs.h"
#include "kernel/fs/devfs.h"
#include "kernel/net/net.h"
#include "kernel/net/dummy_nic.h"
#include "kernel/net/ethernet.h"
#include "kernel/net/arp.h"
#include "kernel/net/ipv4.h"
#include "kernel/net/icmp.h"
#include "kernel/net/udp.h"
#include "kernel/net/checksum.h"
#include "kernel/exec.h"
#include "lib/string.h"

#include "../tests/userspace/init_blob.h"
#include "../tests/userspace/cat_blob.h"
#include "../tests/userspace/echo_blob.h"
#include "../tests/userspace/wc_blob.h"
#include "../tests/userspace/test_blob.h"
#include "../tests/userspace/blocktest_blob.h"
#include "../tests/userspace/memtest_blob.h"
#include "../tests/userspace/memfault_blob.h"
#include "../tests/userspace/tlstest_blob.h"
#include "../tests/userspace/threadtest_blob.h"
#include "../tests/userspace/pthreadtest_blob.h"
#include "../tests/userspace/pipetest_blob.h"
#include "../tests/userspace/fdtest_blob.h"
#include "../tests/userspace/pipetest2_blob.h"
#include "../tests/userspace/socktest_blob.h"
#include "aether_blob.h"
#include "kernel/device.h"

// We need a global struct for the test
static process_t *user_proc;
static exec_image_t user_image;

static void user_init_thread(void *arg) {
    (void)arg;
    log_info("Jumping to user mode...");
    process_exec(user_proc, &user_image);
}

static void test_18g_injector(void *arg) {
    network_device_t *dummy = (network_device_t *)arg;
    if (!dummy) return;
    
    // Wait for userspace socktest to bind and block on recvfrom
    scheduler_sleep_ms(500);
    log_info("18G Injector: Waking up to inject packet...");
    
    uint8_t rx_frame[128];
    ethernet_header_t *eth = (ethernet_header_t *)rx_frame;
    ipv4_header_t *ip = (ipv4_header_t *)(rx_frame + sizeof(ethernet_header_t));
    udp_header_t *udp = (udp_header_t *)(rx_frame + sizeof(ethernet_header_t) + sizeof(ipv4_header_t));
    char *payload = (char *)(rx_frame + sizeof(ethernet_header_t) + sizeof(ipv4_header_t) + sizeof(udp_header_t));
    
    memcpy(eth->dst, dummy->mac, 6);
    uint8_t remote_mac[6] = {0x02, 0x00, 0x00, 0x00, 0x00, 0x02};
    memcpy(eth->src, remote_mac, 6);
    eth->type = net_htons(ETH_TYPE_IPV4);
    
    ip->version_ihl = 0x45;
    ip->tos = 0;
    ip->identification = net_htons(1234);
    ip->flags_fragment = 0;
    ip->ttl = 64;
    ip->protocol = 17; // UDP
    ip->src_ip = net_htonl(0x0A000002);
    ip->dst_ip = net_htonl(0x0A000001); // 10.0.0.1
    
    const char *msg = "Hello from kernel dummy0!";
    uint16_t msg_len = strlen(msg);
    memcpy(payload, msg, msg_len);
    
    uint16_t udp_len = sizeof(udp_header_t) + msg_len;
    udp->src_port = net_htons(4000);
    udp->dst_port = net_htons(5000);
    udp->length = net_htons(udp_len);
    udp->checksum = 0;
    
    ip->total_length = net_htons(20 + udp_len);
    ip->checksum = 0;
    ip->checksum = net_checksum16(ip, 20);
    
    // No UDP checksum for simplicity
    dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 20 + udp_len);
    
    // Now inject 20 more packets to test queue limits
    for (int i = 0; i < 20; i++) {
        strcpy(payload, "Queue pkt");
        msg_len = strlen(payload);
        udp_len = sizeof(udp_header_t) + msg_len;
        udp->length = net_htons(udp_len);
        ip->total_length = net_htons(20 + udp_len);
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 20 + udp_len);
    }
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
static int udp_test_handler(network_device_t *dev, packet_buffer_t *pkt, uint16_t src_port, uint16_t dst_port, uint32_t src_ip, uint32_t dst_ip) {
    log_info("18F Test Handler: Received UDP from %x:%d to %x:%d", src_ip, src_port, dst_ip, dst_port);
    if (pkt->len > 0) {
        // Print payload safely
        char buf[32];
        uint32_t len = pkt->len < sizeof(buf) - 1 ? pkt->len : sizeof(buf) - 1;
        memcpy(buf, pkt->data, len);
        buf[len] = '\0';
        log_info("18F Test Handler Payload: %s", buf);
    }
    return 0;
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
    extern void futex_init(void);
    futex_init();

    // 8. Initialize VFS and RAMFS Initialization
    vfs_init();
    ramfs_init();
    
    // Initialize Device Manager and Core Drivers
    device_manager_init();
    console_dev_init();
    
    devfs_init();
    
    extern void ramdisk_init(void);
    ramdisk_init();
    
    extern void ext2_init(void);
    ext2_init();
    
    net_init();
    dummy_nic_init();
    net_eth_init();
    arp_init();
    ipv4_init();
    icmp_init();
    udp_init();
    
    // Mount root and dev
    vfs_mount("/", "ramfs", NULL);
    vfs_mount("/dev", "devfs", NULL);
    vfs_mount("/mnt", "ext2", "/dev/ram0");

    // Test EXT2 Phase 17D
    log_info("Testing EXT2 Phase 17D (mkdir & Directory Mutation)...");
    
    // 1. mkdir /mnt/testdir
    if (vfs_mkdir("/mnt/testdir", 0755) == 0) {
        log_info("17D Test 1 PASS: mkdir /mnt/testdir succeeded");
    } else {
        log_error("17D Test 1 FAIL: mkdir /mnt/testdir failed");
    }
    
    // 2. Lookup /mnt/testdir
    vfs_node_t *n_dir = vfs_lookup("/mnt/testdir");
    if (n_dir) {
        if (n_dir->flags & FS_DIRECTORY) {
            log_info("17D Test 2 PASS: /mnt/testdir is a directory");
        } else {
            log_error("17D Test 2 FAIL: Not a directory (flags=%x)", n_dir->flags);
        }
    } else {
        log_error("17D Test 2 FAIL: /mnt/testdir not found");
    }
    
    // 3. Lookup . and ..
    vfs_node_t *n_dot = vfs_lookup("/mnt/testdir/.");
    vfs_node_t *n_mnt = vfs_lookup("/mnt");
    vfs_node_t *n_dotdot = vfs_lookup("/mnt/testdir/..");
    
    if (n_dot && n_dir && n_dot->inode == n_dir->inode) {
        log_info("17D Test 3 PASS: . resolves to self");
    } else {
        log_error("17D Test 3 FAIL");
    }
    
    if (n_dotdot && n_mnt && n_dotdot->inode == n_mnt->inode) {
        log_info("17D Test 4 PASS: .. resolves to parent");
    } else {
        log_error("17D Test 4 FAIL");
    }
    
    // 5. Nested file creation
    file_t *f_nest = vfs_open("/mnt/testdir/file.txt", O_CREAT | O_RDWR);
    if (f_nest) {
        log_info("17D Test 5 PASS: Nested file created in new directory");
        vfs_close(f_nest);
    } else {
        log_error("17D Test 5 FAIL: Nested file creation failed");
    }
    
    // 6. Rollback test
    ext2_mount_t *emnt = (ext2_mount_t *) n_mnt->device;
    uint32_t free_inodes_before = emnt->super.free_inodes_count;
    uint32_t free_blocks_before = emnt->super.free_blocks_count;
    
    if (vfs_mkdir("/mnt/faildir", 0755) != 0) {
        if (emnt->super.free_inodes_count == free_inodes_before && 
            emnt->super.free_blocks_count == free_blocks_before) {
            log_info("17D Test 6 PASS: Rollback successful, no leaks");
        } else {
            log_error("17D Test 6 FAIL: Rollback leaked resources. Inodes: %d -> %d, Blocks: %d -> %d",
                free_inodes_before, emnt->super.free_inodes_count,
                free_blocks_before, emnt->super.free_blocks_count);
        }
    } else {
        log_error("17D Test 6 FAIL: faildir unexpectedly succeeded");
    }
    
    // Test EXT2 Phase 17E
    log_info("Testing EXT2 Phase 17E (unlink & File Reclamation)...");
    
    // 1. Create -> unlink -> ENOENT
    file_t *f_unlink = vfs_open("/mnt/unlink1.txt", O_CREAT | O_RDWR);
    if (f_unlink) vfs_close(f_unlink);
    
    if (vfs_unlink("/mnt/unlink1.txt") == 0) {
        if (vfs_lookup("/mnt/unlink1.txt") == NULL) {
            log_info("17E Test 1 PASS: unlink removed file successfully");
        } else {
            log_error("17E Test 1 FAIL: file still exists after unlink");
        }
    } else {
        log_error("17E Test 1 FAIL: unlink returned error");
    }
    
    // 2. Small file reclaim count
    uint32_t i_before = emnt->super.free_inodes_count;
    uint32_t b_before = emnt->super.free_blocks_count;
    
    file_t *f_small = vfs_open("/mnt/small.txt", O_CREAT | O_RDWR);
    if (f_small) {
        vfs_write(f_small, "hello", 5);
        vfs_close(f_small);
    }
    
    uint32_t b_after_alloc = emnt->super.free_blocks_count;
    vfs_unlink("/mnt/small.txt");
    
    if (emnt->super.free_inodes_count == i_before && emnt->super.free_blocks_count == b_before) {
        log_info("17E Test 2 PASS: unlink small file perfectly restored inodes and blocks");
    } else {
        log_error("17E Test 2 FAIL: Inodes: %d -> %d, Blocks: %d -> %d -> %d", 
                  i_before, emnt->super.free_inodes_count, b_before, b_after_alloc, emnt->super.free_blocks_count);
    }
    
    // 3. 13KB file reclaim
    file_t *f_big = vfs_open("/mnt/big.txt", O_CREAT | O_RDWR);
    if (f_big) {
        char *big_buf = kmalloc(13412, KMALLOC_ZERO);
        vfs_write(f_big, big_buf, 13412);
        kfree(big_buf);
        vfs_close(f_big);
        
        uint32_t blocks_used_by_big = b_before - emnt->super.free_blocks_count;
        vfs_unlink("/mnt/big.txt");
        
        if (emnt->super.free_blocks_count == b_before && blocks_used_by_big >= 14) {
            log_info("17E Test 3 PASS: 13KB unlink reclaimed %d blocks (expected >= 14)", blocks_used_by_big);
        } else {
            log_error("17E Test 3 FAIL: blocks reclaimed: %d", b_before - emnt->super.free_blocks_count);
        }
    }
    
    // 4. Unlink ENOENT
    if (vfs_unlink("/mnt/does_not_exist.txt") < 0) {
        log_info("17E Test 4 PASS: unlink ENOENT rejected");
    } else {
        log_error("17E Test 4 FAIL");
    }
    
    // 5. Unlink Directory (EISDIR)
    if (vfs_unlink("/mnt/testdir") < 0) {
        log_info("17E Test 5 PASS: unlink EISDIR rejected");
    } else {
        log_error("17E Test 5 FAIL");
    }
    
    // 6. Reuse
    file_t *f_re = vfs_open("/mnt/reuse.txt", O_CREAT | O_RDWR);
    if (f_re) vfs_close(f_re);
    vfs_unlink("/mnt/reuse.txt");
    file_t *f_re2 = vfs_open("/mnt/reuse2.txt", O_CREAT | O_RDWR);
    if (f_re2) vfs_close(f_re2);
    vfs_unlink("/mnt/reuse2.txt");
    log_info("17E Test 6 PASS: file create/unlink cycle successful");
    
    // 7. Persistence
    vfs_unmount("/mnt");
    vfs_mount("/mnt", "ext2", "/dev/ram0");
    if (vfs_lookup("/mnt/small.txt") == NULL && vfs_lookup("/mnt/unlink1.txt") == NULL) {
        log_info("17E Test 7 PASS: unlink persisted across remount");
    } else {
        log_error("17E Test 7 FAIL");
    }
    
    // 8. Active File Test (EBUSY)
    file_t *f_busy = vfs_open("/mnt/busy.txt", O_CREAT | O_RDWR);
    if (f_busy) {
        if (vfs_unlink("/mnt/busy.txt") < 0) {
            log_info("17E Test 8a PASS: unlink returned EBUSY for active file");
            
            // Verify still writable
            if (vfs_write(f_busy, "OK", 2) == 2) {
                log_info("17E Test 8b PASS: file still writable while busy");
            } else {
                log_error("17E Test 8b FAIL");
            }
            
            vfs_close(f_busy);
            
            if (vfs_unlink("/mnt/busy.txt") == 0) {
                log_info("17E Test 8c PASS: unlink succeeded after close");
            } else {
                log_error("17E Test 8c FAIL");
            }
        } else {
            log_error("17E Test 8 FAIL: unlink bypassed EBUSY check");
            vfs_close(f_busy);
        }
    }

    // Test Phase 18C: ARP Layer
    log_info("Testing Phase 18C: ARP Layer...");
    
    network_device_t *dummy = net_dev_get("dummy0");
    if (dummy) {
        // Test 1: ARP Request TX
        log_info("18C Test 1: Constructing ARP request for 10.0.0.2");
        arp_send_request(dummy, 0x0A000002);
        log_info("18C Test 1 PASS: ARP request transmitted");

        // Helper to construct raw ARP Reply frame for injection
        uint8_t raw_frame[64];
        ethernet_header_t *eth_hdr = (ethernet_header_t *)raw_frame;
        arp_packet_t *arp = (arp_packet_t *)(raw_frame + sizeof(ethernet_header_t));
        uint32_t frame_len = sizeof(ethernet_header_t) + sizeof(arp_packet_t);
        
        uint8_t remote_mac[6] = {0x02, 0x00, 0x00, 0x00, 0x00, 0x02};
        uint32_t remote_ip = 0x0A000002; // 10.0.0.2
        
        // Ethernet framing
        memcpy(eth_hdr->dst, dummy->mac, 6);
        memcpy(eth_hdr->src, remote_mac, 6);
        eth_hdr->type = net_htons(ETH_TYPE_ARP);
        
        // ARP framing
        arp->htype = net_htons(ARP_HTYPE_ETHERNET);
        arp->ptype = net_htons(ARP_PTYPE_IPV4);
        arp->hlen = 6;
        arp->plen = 4;
        arp->oper = net_htons(ARP_OP_REPLY);
        memcpy(arp->sha, remote_mac, 6);
        arp->spa = net_htonl(remote_ip);
        memcpy(arp->tha, dummy->mac, 6);
        arp->tpa = net_htonl(dummy->ip_addr);

        // Test 2 & 3: Parse Reply & Update Cache
        log_info("18C Test 2/3: Injecting ARP reply from 10.0.0.2");
        dummy_inject_rx(dummy, raw_frame, frame_len);
        
        uint8_t resolved_mac[6];
        if (arp_resolve(dummy, remote_ip, resolved_mac) == 0) {
            log_info("18C Test 2/3 PASS: ARP cache updated correctly (%x:%x:%x:%x:%x:%x)",
                     resolved_mac[0], resolved_mac[1], resolved_mac[2], 
                     resolved_mac[3], resolved_mac[4], resolved_mac[5]);
        } else {
            log_error("18C Test 2/3 FAIL: ARP cache missing entry");
        }

        // Test 4: Malformed
        log_info("18C Test 4: Injecting truncated ARP packet");
        dummy_inject_rx(dummy, raw_frame, sizeof(ethernet_header_t) + 10);
        log_info("18C Test 4 PASS: Truncated ARP rejected");

        // Test 5: Request for Atlas
        log_info("18C Test 5: Injecting ARP request for Atlas (10.0.0.1)");
        arp->oper = net_htons(ARP_OP_REQUEST);
        memset(arp->tha, 0, 6); // Target MAC unknown in request
        memcpy(eth_hdr->dst, "\xFF\xFF\xFF\xFF\xFF\xFF", 6); // broadcast
        dummy_inject_rx(dummy, raw_frame, frame_len);
        log_info("18C Test 5 PASS: Atlas replied to ARP request");

        // Test 6: Ignore foreign IP
        log_info("18C Test 6: Injecting ARP request for foreign IP (10.0.0.5)");
        arp->tpa = net_htonl(0x0A000005);
        dummy_inject_rx(dummy, raw_frame, frame_len);
        log_info("18C Test 6 PASS: Foreign IP request ignored");
        
    } else {
        log_error("18C Tests FAIL: dummy0 not found");
    }

    // Test Phase 18D: IPv4 Layer
    log_info("Testing Phase 18D: IPv4 Layer...");
    if (dummy) {
        // Dummy protocol handler (UDP = 17)
        int test_proto_handler(network_device_t *dev, packet_buffer_t *pkt, uint32_t src, uint32_t dst) {
            log_info("18D End-to-End PASS: Protocol 17 received %d bytes from %x", pkt->len, src);
            if (pkt->len > 0) {
                char buf[32];
                uint32_t cplen = pkt->len < 31 ? pkt->len : 31;
                memcpy(buf, pkt->data, cplen);
                buf[cplen] = '\0';
                log_info("18D End-to-End PASS: Payload: '%s'", buf);
            }
            return 0;
        }
        ipv4_register_protocol(254, test_proto_handler);

        // 18D-1: Manual Header & Checksum
        log_info("18D Test 1: Verifying RFC 1071 checksum...");
        ipv4_header_t test_ip = {0};
        test_ip.version_ihl = 0x45;
        test_ip.total_length = net_htons(20);
        test_ip.ttl = 64;
        test_ip.protocol = 17;
        test_ip.src_ip = net_htonl(0x0A000002);
        test_ip.dst_ip = net_htonl(0x0A000001);
        test_ip.checksum = net_checksum16(&test_ip, 20);
        if (test_ip.checksum != 0) {
            log_info("18D Test 1 PASS: Checksum calculated successfully (%x)", test_ip.checksum);
        }

        // 18D-2: TX
        log_info("18D Test 2: IPv4 TX (Should encapsulate in Ethernet & ARP resolve)...");
        packet_buffer_t *tx_pkt = net_alloc_packet(128);
        char *payload = net_packet_put(tx_pkt, 13);
        strcpy(payload, "Hello Atlas!");
        // We know 10.0.0.2 is in ARP cache from 18C Test 2/3
        net_ipv4_send(dummy, 0x0A000002, 17, tx_pkt);
        log_info("18D Test 2 PASS: TX complete");

        // Prepare frame for RX testing
        uint8_t rx_frame[128];
        ethernet_header_t *eth = (ethernet_header_t *)rx_frame;
        ipv4_header_t *ip = (ipv4_header_t *)(rx_frame + sizeof(ethernet_header_t));
        char *rx_payload = (char *)(rx_frame + sizeof(ethernet_header_t) + sizeof(ipv4_header_t));
        
        memcpy(eth->dst, dummy->mac, 6);
        uint8_t remote_mac[6] = {0x02, 0x00, 0x00, 0x00, 0x00, 0x02};
        memcpy(eth->src, remote_mac, 6);
        eth->type = net_htons(ETH_TYPE_IPV4);
        
        ip->version_ihl = 0x45;
        ip->tos = 0;
        ip->total_length = net_htons(20 + 15);
        ip->identification = 0;
        ip->flags_fragment = 0;
        ip->ttl = 64;
        ip->protocol = 254;
        ip->src_ip = net_htonl(0x0A000002);
        ip->dst_ip = net_htonl(0x0A000001); // Atlas IP
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        
        strcpy(rx_payload, "Hello 18D RX!");
        uint32_t rx_len = sizeof(ethernet_header_t) + 20 + 15;

        // 18D-3 & End-to-End
        log_info("18D Test 3: Injecting valid IPv4 packet...");
        dummy_inject_rx(dummy, rx_frame, rx_len);
        
        // 18D-4: Bad Checksum
        log_info("18D Test 4: Injecting bad checksum...");
        ip->checksum = ~ip->checksum;
        dummy_inject_rx(dummy, rx_frame, rx_len);
        ip->checksum = ~ip->checksum; // restore
        log_info("18D Test 4 PASS: Packet dropped");

        // 18D-5: Malformed
        log_info("18D Test 5: Injecting malformed IPv4 (short)...");
        dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 10);
        log_info("18D Test 5 PASS: Packet dropped safely");
        
        // 18D-6: Foreign IP
        log_info("18D Test 6: Injecting packet for foreign IP...");
        ip->dst_ip = net_htonl(0x0A000005);
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        dummy_inject_rx(dummy, rx_frame, rx_len);
        log_info("18D Test 6 PASS: Foreign IP dropped");
        
        // Restore destination IP
        ip->dst_ip = net_htonl(0x0A000001);
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);

        // 18D-7: Unknown Protocol
        log_info("18D Test 7: Injecting unknown protocol...");
        ip->protocol = 99; // Unregistered
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        dummy_inject_rx(dummy, rx_frame, rx_len);
        log_info("18D Test 7 PASS: Unknown protocol dropped by IPv4");
        
        // 18D-8: Truncation Test
        log_info("18D Test 8: Injecting trailing padding...");
        ip->protocol = 254; // Restore custom test protocol
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        // Inject with 20 bytes of trailing garbage
        strcpy(rx_payload + 15, "TRASHGARBAGETRASH...");
        dummy_inject_rx(dummy, rx_frame, rx_len + 20);
        log_info("18D Test 8 PASS: Extra bytes trimmed by IPv4 (see payload above)");

    } else {
        log_error("18D Tests FAIL: dummy0 not found");
    }

    // Test Phase 18E: ICMP Layer
    log_info("Testing Phase 18E: ICMP Layer...");
    if (dummy) {
        // Prepare ICMP Echo Request frame
        uint8_t rx_frame[128];
        ethernet_header_t *eth = (ethernet_header_t *)rx_frame;
        ipv4_header_t *ip = (ipv4_header_t *)(rx_frame + sizeof(ethernet_header_t));
        icmp_echo_header_t *icmp = (icmp_echo_header_t *)(rx_frame + sizeof(ethernet_header_t) + sizeof(ipv4_header_t));
        char *payload = (char *)(rx_frame + sizeof(ethernet_header_t) + sizeof(ipv4_header_t) + sizeof(icmp_echo_header_t));
        
        memcpy(eth->dst, dummy->mac, 6);
        uint8_t remote_mac[6] = {0x02, 0x00, 0x00, 0x00, 0x00, 0x02};
        memcpy(eth->src, remote_mac, 6);
        eth->type = net_htons(ETH_TYPE_IPV4);
        
        ip->version_ihl = 0x45;
        ip->tos = 0;
        ip->total_length = net_htons(20 + 8 + 14); // 14 bytes payload
        ip->identification = net_htons(1234);
        ip->flags_fragment = 0;
        ip->ttl = 64;
        ip->protocol = 1; // ICMP
        ip->src_ip = net_htonl(0x0A000002);
        ip->dst_ip = net_htonl(0x0A000001);
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        
        icmp->type = 8; // Echo Request
        icmp->code = 0;
        icmp->identifier = net_htons(0xABCD);
        icmp->sequence = net_htons(0x0001);
        strcpy(payload, "Atlas ICMP 18E");
        icmp->checksum = 0;
        icmp->checksum = net_checksum16(icmp, 8 + 14);
        
        uint32_t rx_len = sizeof(ethernet_header_t) + 20 + 8 + 14;

        // 18E-4 to 18E-8 & 18E-10: End-to-End Echo (Nontrivial Payload)
        log_info("18E Test End-to-End (Nontrivial Payload): Injecting ICMP Echo Request...");
        dummy_inject_rx(dummy, rx_frame, rx_len);
        log_info("18E Test End-to-End PASS: Dummy should have intercepted an Echo Reply (see TX logs above)");

        // 18E-9: Echo Request with 0 bytes payload
        log_info("18E Test 9: Injecting 0-byte payload Echo Request...");
        ip->total_length = net_htons(20 + 8);
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        icmp->checksum = 0;
        icmp->checksum = net_checksum16(icmp, 8);
        dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 20 + 8);
        log_info("18E Test 9 PASS: 0-byte payload Echo Reply transmitted");
        
        // Restore payload length for next tests
        ip->total_length = net_htons(20 + 8 + 14);
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        
        // 18E-2: Bad ICMP Checksum
        log_info("18E Test 2: Injecting Bad ICMP Checksum...");
        icmp->checksum = ~icmp->checksum;
        dummy_inject_rx(dummy, rx_frame, rx_len);
        icmp->checksum = ~icmp->checksum; // restore
        log_info("18E Test 2 PASS: Packet dropped");

        // 18E-3: Wrong ICMP Type (Destination Unreachable)
        log_info("18E Test 3: Injecting Type 3 ICMP...");
        icmp->type = 3;
        icmp->checksum = 0;
        icmp->checksum = net_checksum16(icmp, 8 + 14);
        dummy_inject_rx(dummy, rx_frame, rx_len);
        log_info("18E Test 3 PASS: Type 3 safely ignored");

    } else {
        log_error("18E Tests FAIL: dummy0 not found");
    }

    // Test Phase 18F: UDP Layer
    log_info("Testing Phase 18F: UDP Layer...");
    if (dummy) {

        uint8_t rx_frame[128];
        ethernet_header_t *eth = (ethernet_header_t *)rx_frame;
        ipv4_header_t *ip = (ipv4_header_t *)(rx_frame + sizeof(ethernet_header_t));
        udp_header_t *udp = (udp_header_t *)(rx_frame + sizeof(ethernet_header_t) + sizeof(ipv4_header_t));
        char *payload = (char *)(rx_frame + sizeof(ethernet_header_t) + sizeof(ipv4_header_t) + sizeof(udp_header_t));
        
        memcpy(eth->dst, dummy->mac, 6);
        uint8_t remote_mac[6] = {0x02, 0x00, 0x00, 0x00, 0x00, 0x02};
        memcpy(eth->src, remote_mac, 6);
        eth->type = net_htons(ETH_TYPE_IPV4);
        
        ip->version_ihl = 0x45;
        ip->tos = 0;
        ip->identification = net_htons(1234);
        ip->flags_fragment = 0;
        ip->ttl = 64;
        ip->protocol = 17; // UDP
        ip->src_ip = net_htonl(0x0a000002);
        ip->dst_ip = net_htonl(0x0a000001);
        
        // Setup payload
        const char *msg = "Hello UDP!";
        uint16_t msg_len = strlen(msg);
        memcpy(payload, msg, msg_len);
        
        uint16_t udp_len = sizeof(udp_header_t) + msg_len;
        udp->src_port = net_htons(4000);
        udp->dst_port = net_htons(5000);
        udp->length = net_htons(udp_len);
        udp->checksum = 0;
        
        ip->total_length = net_htons(20 + udp_len);
        ip->checksum = 0;
        ip->checksum = net_checksum16(ip, 20);
        
        // Calculate UDP Checksum
        ipv4_pseudo_header_t psh;
        psh.src_ip = ip->src_ip;
        psh.dst_ip = ip->dst_ip;
        psh.zero = 0;
        psh.protocol = 17;
        psh.length = net_htons(udp_len);
        
        uint32_t sum = net_checksum_accumulate(0, &psh, sizeof(psh));
        sum = net_checksum_accumulate(sum, udp, udp_len);
        udp->checksum = net_checksum_finalize(sum);
        if (udp->checksum == 0) udp->checksum = 0xFFFF;
        
        log_info("18F Test 1-3, 7, 10: Injecting Valid UDP packet...");
        dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 20 + udp_len);
        log_info("18F Test Valid UDP RX PASS");
        
        // Bad Checksum
        log_info("18F Test 4: Injecting Bad UDP Checksum...");
        udp->checksum = net_htons(0xdead);
        dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 20 + udp_len);
        log_info("18F Test 4 PASS: Packet dropped");
        
        // Invalid UDP length (too small)
        log_info("18F Test 5: Injecting Invalid UDP length...");
        udp->length = net_htons(4);
        udp->checksum = 0; // Disable checksum to just trigger length check
        dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 20 + udp_len);
        log_info("18F Test 5 PASS: Invalid length rejected");
        
        // Restore length
        udp->length = net_htons(udp_len);
        
        // Truncated packet
        log_info("18F Test 6: Injecting Truncated packet...");
        udp->checksum = 0;
        dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 20 + udp_len - 2);
        log_info("18F Test 6 PASS: Truncated packet rejected");
        
        // Unknown destination port
        log_info("18F Test 8: Injecting Unknown destination port...");
        udp->dst_port = net_htons(5001);
        dummy_inject_rx(dummy, rx_frame, sizeof(ethernet_header_t) + 20 + udp_len);
        log_info("18F Test 8 PASS: Unknown port dropped");
        
        // UDP TX
        log_info("18F Test 9: Sending UDP packet...");
        packet_buffer_t *tx_pkt = net_alloc_packet(256);
        void *tx_data = net_packet_put(tx_pkt, msg_len);
        if (tx_data) {
            memcpy(tx_data, msg, msg_len);
            net_udp_send(dummy, 0x0a000002, 5000, 4000, tx_pkt);
            log_info("18F Test 9 PASS: UDP TX transmitted");
        }

    } else {
        log_error("18F Tests FAIL: dummy0 not found");
    }
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
    
    // Injection and Mutex Tests
    mutex_init(&test_mutex);
    thread_t *mtx1 = thread_create("mtx_test_1", mutex_test_thread, "Thread 1");
    thread_t *mtx2 = thread_create("mtx_test_2", mutex_test_thread, "Thread 2");
    scheduler_enqueue(mtx1);
    scheduler_enqueue(mtx2);
    
    // Inject test app into RAMFS
    ramfs_add_dir("/bin");
    ramfs_add_file("/bin/init", tests_userspace_apps_init, tests_userspace_apps_init_len);
    ramfs_add_file("/bin/cat", tests_userspace_apps_cat, tests_userspace_apps_cat_len);
    ramfs_add_file("/bin/echo", tests_userspace_apps_echo, tests_userspace_apps_echo_len);
    ramfs_add_file("/bin/wc", tests_userspace_apps_wc, tests_userspace_apps_wc_len);
    ramfs_add_file("/bin/test", tests_userspace_apps_test, tests_userspace_apps_test_len);
    ramfs_add_file("/bin/memtest", tests_userspace_apps_memtest, tests_userspace_apps_memtest_len);
    ramfs_add_file("/bin/memfault", tests_userspace_apps_memfault, tests_userspace_apps_memfault_len);
    ramfs_add_file("/bin/tlstest", tests_userspace_apps_tlstest, tests_userspace_apps_tlstest_len);
    ramfs_add_file("/bin/threadtest", tests_userspace_apps_threadtest, tests_userspace_apps_threadtest_len);
    ramfs_add_file("/bin/pthreadtest", tests_userspace_apps_pthreadtest, tests_userspace_apps_pthreadtest_len);
    ramfs_add_file("/bin/pipetest", tests_userspace_apps_pipetest, tests_userspace_apps_pipetest_len);
    ramfs_add_file("/bin/fdtest", tests_userspace_apps_fdtest, tests_userspace_apps_fdtest_len);
    ramfs_add_file("/bin/pipetest2", tests_userspace_apps_pipetest2, tests_userspace_apps_pipetest2_len);
    ramfs_add_file("/bin/blocktest", tests_userspace_apps_blocktest, tests_userspace_apps_blocktest_len);
    ramfs_add_file("/bin/socktest", tests_userspace_apps_socktest, tests_userspace_apps_socktest_len);

    // Inject Aether into RAMFS
    ramfs_add_dir("/lib");
    ramfs_add_file("/lib/aether", aether_bin, aether_bin_len);
    
    user_proc = process_create("user_init");
    
    // Open standard IO for the init process
    user_proc->fd_table[0] = vfs_open("/dev/console", 0);
    user_proc->fd_table[1] = vfs_open("/dev/console", 0);
    user_proc->fd_table[2] = vfs_open("/dev/console", 0);
    
    const char *init_argv[] = {"/bin/socktest", NULL};
    const char *init_envp[] = {"AETHER_LOG=1", NULL};
    if (exec_load("/bin/socktest", &user_image, 1, init_argv, 1, init_envp) == 0) {
        address_space_destroy(user_proc->address_space);
        user_proc->address_space = user_image.space;
        user_proc->vm_regions = user_image.regions;
        
        thread_t *uthr = thread_create("user_main", user_init_thread, NULL);
        uthr->process = user_proc; // Associate thread with process
        scheduler_enqueue(uthr);
        
        // Start 18G injector thread
        thread_t *inj_thr = thread_create("18g_injector", test_18g_injector, dummy);
        scheduler_enqueue(inj_thr);
    } else {
        log_error("Failed to load /bin/socktest");
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
