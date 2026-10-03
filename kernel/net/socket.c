#include <kernel/net/socket.h>
#include <kernel/net/udp.h>
#include <kernel/net/net.h>
#include <kernel/net/ipv4.h>
#include <kernel/net/ethernet.h>
#include <kernel/heap.h>
#include <kernel/log.h>
#include <lib/memory.h>
#include <lib/string.h>
#include <kernel/sync/spinlock.h>
#include <kernel/sync/waitqueue.h>
#include <kernel/scheduler/process.h>
#include <kernel/fs/vfs.h>
#include <kernel/uaccess.h>

#define MAX_SOCKETS 128

static socket_t *socket_registry[MAX_SOCKETS];
static spinlock_t socket_registry_lock;

static void socket_vfs_close(struct file *file) {
    socket_t *sock = (socket_t *)file->node->device;
    if (sock) {
        sock_close(sock);
    }
}

vfs_ops_t socket_ops = {
    .read = NULL,
    .write = NULL,
    .open = NULL,
    .close = socket_vfs_close,
    .readdir = NULL,
    .finddir = NULL,
    .mkdir = NULL,
    .create = NULL,
    .ioctl = NULL
};

void socket_init(void) {
    socket_registry_lock.lock = 0;
    for (int i = 0; i < MAX_SOCKETS; i++) {
        socket_registry[i] = NULL;
    }
}

socket_t *sock_create(int domain, int type, int protocol) {
    if (domain != AF_INET || type != SOCK_DGRAM) {
        log_error("Unsupported socket domain/type: %d/%d", domain, type);
        return NULL;
    }
    
    socket_t *sock = kmalloc(sizeof(socket_t), KMALLOC_ZERO);
    if (!sock) return NULL;
    
    sock->domain = domain;
    sock->type = type;
    sock->protocol = protocol;
    sock->local_port = 0;
    sock->local_ip = 0;
    
    sock->rx_queue_head = NULL;
    sock->rx_queue_tail = NULL;
    sock->rx_packet_count = 0;
    sock->rx_byte_count = 0;
    sock->rx_lock.lock = 0;
    waitqueue_init(&sock->rx_wait);
    
    // Add to registry
    spin_lock(&socket_registry_lock);
    for (int i = 0; i < MAX_SOCKETS; i++) {
        if (!socket_registry[i]) {
            socket_registry[i] = sock;
            break;
        }
    }
    spin_unlock(&socket_registry_lock);
    
    return sock;
}

int sock_bind(socket_t *sock, uint32_t ip, uint16_t port) {
    sock->local_port = port; // host byte order
    sock->local_ip = ip;
    return 0;
}

void sock_enqueue_rx(uint32_t dest_ip, uint16_t dest_port, uint32_t src_ip, uint16_t src_port, const void *payload, uint32_t payload_len) {
    (void)dest_ip;

    // Find socket bound to this port
    socket_t *sock = NULL;
    spin_lock(&socket_registry_lock);
    for (int i = 0; i < MAX_SOCKETS; i++) {
        if (socket_registry[i] && socket_registry[i]->local_port == dest_port) {
            sock = socket_registry[i];
            break;
        }
    }
    spin_unlock(&socket_registry_lock);
    
    if (!sock) {
        return; // No socket listening on this port
    }
    
    spin_lock(&sock->rx_lock);
    
    if (sock->rx_byte_count + payload_len > SOCKET_RX_MAX_BYTES || 
        sock->rx_packet_count >= SOCKET_RX_MAX_PACKETS) {
        spin_unlock(&sock->rx_lock);
        return; // Drop
    }
    
    socket_datagram_t *dgram = kmalloc(sizeof(socket_datagram_t), 0);
    if (!dgram) {
        spin_unlock(&sock->rx_lock);
        return;
    }
    
    dgram->len = payload_len;
    dgram->data = kmalloc(payload_len, 0);
    if (!dgram->data) {
        spin_unlock(&sock->rx_lock);
        return;
    }
    memcpy(dgram->data, payload, payload_len);
    
    dgram->src_ip = src_ip;
    dgram->src_port = src_port;
    dgram->next = NULL;
    
    if (!sock->rx_queue_head) {
        sock->rx_queue_head = dgram;
    } else {
        sock->rx_queue_tail->next = dgram;
    }
    sock->rx_queue_tail = dgram;
    
    sock->rx_byte_count += payload_len;
    sock->rx_packet_count++;
    
    waitqueue_wake_one(&sock->rx_wait);
    spin_unlock(&sock->rx_lock);
}

int sock_sendto(socket_t *sock, const void *buf, size_t len, uint32_t dest_ip, uint16_t dest_port) {
    if (sock->type != SOCK_DGRAM) {
        return -1; // ENOTSUP
    }
    
    uint32_t headroom = sizeof(ethernet_header_t) + sizeof(ipv4_header_t) + sizeof(udp_header_t);
    packet_buffer_t *pkt = net_alloc_packet(len + headroom);
    if (!pkt) return -1;
    
    // Explicitly set the data pointer so we have exactly 'headroom' bytes before it
    pkt->data = pkt->head + headroom;
    pkt->tail = pkt->data;
    pkt->len = 0;
    
    void *payload = net_packet_put(pkt, len);
    memcpy(payload, buf, len);
    
    network_device_t *dev = net_dev_get("dummy0");
    if (!dev) {
        dev = net_dev_get("eth0");
        if (!dev) {
            net_free_packet(pkt);
            return -1; // ENETUNREACH
        }
    }
    
    int ret = net_udp_send(dev, dest_ip, sock->local_port ? sock->local_port : 12345, dest_port, pkt);
    if (ret == 0) {
        return len;
    }
    return -1;
}

int sock_recvfrom(socket_t *sock, void *buf, size_t len, uint32_t *src_ip, uint16_t *src_port) {
    spin_lock(&sock->rx_lock);
    
    while (!sock->rx_queue_head) {
        waitqueue_sleep(&sock->rx_wait, &sock->rx_lock);
        // after waking up, rx_lock is re-acquired
    }
    
    socket_datagram_t *dgram = sock->rx_queue_head;
    sock->rx_queue_head = dgram->next;
    if (!sock->rx_queue_head) {
        sock->rx_queue_tail = NULL;
    }
    
    sock->rx_byte_count -= dgram->len;
    sock->rx_packet_count--;
    
    spin_unlock(&sock->rx_lock);
    
    size_t copy_len = len < dgram->len ? len : dgram->len;
    memcpy(buf, dgram->data, copy_len);
    
    if (src_ip) {
        *src_ip = dgram->src_ip;
    }
    if (src_port) {
        *src_port = dgram->src_port;
    }
    
    kfree(dgram->data);
    kfree(dgram);
    
    return copy_len;
}

void sock_close(socket_t *sock) {
    if (!sock) return;
    
    // Remove from registry
    spin_lock(&socket_registry_lock);
    for (int i = 0; i < MAX_SOCKETS; i++) {
        if (socket_registry[i] == sock) {
            socket_registry[i] = NULL;
            break;
        }
    }
    spin_unlock(&socket_registry_lock);
    
    // Cleanup queue (no kfree available so just detach)
    spin_lock(&sock->rx_lock);
    sock->rx_queue_head = NULL;
    sock->rx_queue_tail = NULL;
    sock->rx_byte_count = 0;
    sock->rx_packet_count = 0;
    spin_unlock(&sock->rx_lock);
}
