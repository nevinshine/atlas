#include <sys/socket.h>
#include <atlas/syscall.h>
#include <atlas/sysnums.h>

int socket(int domain, int type, int protocol) {
    return (int)__atlas_syscall3(ATLAS_SYS_SOCKET, (long)domain, (long)type, (long)protocol);
}

int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen) {
    return (int)__atlas_syscall3(ATLAS_SYS_BIND, (long)sockfd, (long)addr, (long)addrlen);
}

int sendto(int sockfd, const void *msg, size_t len, int flags, const struct sockaddr *to, socklen_t tolen) {
    return (int)__atlas_syscall6(ATLAS_SYS_SENDTO, (long)sockfd, (long)msg, (long)len, (long)flags, (long)to, (long)tolen);
}

int recvfrom(int sockfd, void *buf, size_t len, int flags, struct sockaddr *from, socklen_t *fromlen) {
    return (int)__atlas_syscall6(ATLAS_SYS_RECVFROM, (long)sockfd, (long)buf, (long)len, (long)flags, (long)from, (long)fromlen);
}
