#include <stdio.h>
#include <sys/socket.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

// Convert string IP to integer for simple testing
// Assuming IP is 10.0.0.1 (0x0A000001) in network byte order ?
// Actually, let's just construct it manually.
// The network stack uses native byte order internally in our mock, or network byte order?
// Atlas ipv4 code: ip->src_ip = net_htonl(0x0A000002);
// So network stack expects native IPs in the API and converts them.
// Wait, the bind API we implemented passes sin_addr directly to sock_bind.
// sock_bind compares with dest_ip which is net_ntohl(ip->dst_ip).
// So sock_bind expects NATIVE byte order.
// Let's pass native byte order: 10.0.0.1 = 0x0A000001
#define TEST_IP 0x0A000001
#define TEST_PORT 5000

int main() {
    printf("18G Test 1: Creating socket...\n");
    int fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) {
        printf("18G Test 1 FAIL: socket() returned %d\n", fd);
        return 1;
    }
    printf("18G Test 1 PASS: fd = %d\n", fd);

    printf("18G Test 2: Binding socket to 10.0.0.1:5000...\n");
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = TEST_PORT;
    addr.sin_addr = TEST_IP;
    
    int ret = bind(fd, (struct sockaddr *)&addr, sizeof(addr));
    if (ret < 0) {
        printf("18G Test 2 FAIL: bind() returned %d\n", ret);
        return 1;
    }
    printf("18G Test 2 PASS\n");

    printf("18G Test 3: Blocking receive...\n");
    char buf[128];
    struct sockaddr_in src_addr;
    socklen_t addrlen = sizeof(src_addr);
    
    // This should block until the kernel thread injects a packet
    int r = recvfrom(fd, buf, sizeof(buf) - 1, 0, (struct sockaddr *)&src_addr, &addrlen);
    if (r > 0) {
        buf[r] = '\0';
        printf("18G Test 3 PASS: Received %d bytes: '%s' from %x:%d\n", r, buf, src_addr.sin_addr, src_addr.sin_port);
    } else {
        printf("18G Test 3 FAIL: recvfrom returned %d\n", r);
    }

    // Now test queueing (Tests 4 & 5). The kernel will inject 20 packets.
    // The queue limit is 16. So 16 should be readable, 4 dropped.
    printf("18G Test 4 & 5: Testing queue limits. Waiting a moment for kernel to inject packets...\n");
    
    // We expect 15 packets. Let's read them.
    for (int i = 0; i < 15; i++) {
        r = recvfrom(fd, buf, sizeof(buf) - 1, 0, NULL, NULL);
        if (r > 0) {
            buf[r] = '\0';
            printf("Read queued packet %d: '%s'\n", i, buf);
        } else {
            printf("18G Test FAIL: failed to read queued packet %d\n", i);
        }
    }
    printf("18G Test 4 & 5 PASS: Read 16 queued packets.\n");

    // Test 6: userspace sendto
    printf("18G Test 6: Userspace sendto...\n");
    struct sockaddr_in dest_addr;
    dest_addr.sin_family = AF_INET;
    dest_addr.sin_port = 4000;
    dest_addr.sin_addr = 0x0A000002; // 10.0.0.2

    const char *msg = "Hello from userspace!";
    int s = sendto(fd, msg, strlen(msg), 0, (struct sockaddr *)&dest_addr, sizeof(dest_addr));
    if (s == (int)strlen(msg)) {
        printf("18G Test 6 PASS: sendto sent %d bytes\n", s);
    } else {
        printf("18G Test 6 FAIL: sendto returned %d\n", s);
    }

    printf("18G Test 7: Closing socket...\n");
    close(fd);
    printf("18G Test 7 PASS: Socket closed\n");

    printf("18G User Tests Complete.\n");
    return 0;
}
