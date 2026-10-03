#ifndef ATLAS_NET_SOCKET_H
#define ATLAS_NET_SOCKET_H

#include <stdint.h>
#include <stddef.h>
#include "kernel/sync/waitqueue.h"
#include "kernel/sync/spinlock.h"

// Address families
#define AF_INET     2

// Socket types
#define SOCK_STREAM 1
#define SOCK_DGRAM  2

// Protocol families
#define IPPROTO_UDP 17

// Queue limits
#define SOCKET_RX_MAX_PACKETS 16
#define SOCKET_RX_MAX_BYTES   (64 * 1024)

// Socket Address structure
struct sockaddr {
    uint16_t sa_family;
    char sa_data[14];
};

struct sockaddr_in {
    uint16_t sin_family;
    uint16_t sin_port;
    uint32_t sin_addr;
    char sin_zero[8];
};

typedef uint32_t socklen_t;

typedef struct socket_datagram {
    uint8_t  *data;
    uint32_t  len;
    uint32_t  src_ip;
    uint16_t  src_port;
    struct socket_datagram *next;
} socket_datagram_t;

typedef struct socket {
    int domain;
    int type;
    int protocol;

    uint32_t local_ip;
    uint16_t local_port;
    
    // RX Queue
    spinlock_t rx_lock;
    wait_queue_t rx_wait;
    socket_datagram_t *rx_queue_head;
    socket_datagram_t *rx_queue_tail;
    
    uint32_t rx_packet_count;
    uint32_t rx_byte_count;

    // Next socket in global registry
    struct socket *next;
} socket_t;

// Initialization
void socket_init(void);

// Kernel Socket API
socket_t *sock_create(int domain, int type, int protocol);
int sock_bind(socket_t *sock, uint32_t ip, uint16_t port);
int sock_sendto(socket_t *sock, const void *buf, size_t len, uint32_t dest_ip, uint16_t dest_port);
int sock_recvfrom(socket_t *sock, void *buf, size_t len, uint32_t *src_ip, uint16_t *src_port);
void sock_close(socket_t *sock);

// UDP packet delivery
void sock_enqueue_rx(uint32_t dest_ip, uint16_t dest_port, uint32_t src_ip, uint16_t src_port, const void *payload, uint32_t payload_len);

#endif // ATLAS_NET_SOCKET_H
