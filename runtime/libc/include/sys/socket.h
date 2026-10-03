#ifndef _SYS_SOCKET_H
#define _SYS_SOCKET_H

#include <stdint.h>
#include <stddef.h>

#define AF_INET     2
#define SOCK_STREAM 1
#define SOCK_DGRAM  2
#define IPPROTO_UDP 17

typedef uint32_t socklen_t;

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

int socket(int domain, int type, int protocol);
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
int sendto(int sockfd, const void *msg, size_t len, int flags, const struct sockaddr *to, socklen_t tolen);
int recvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *from, socklen_t *fromlen);

#endif
