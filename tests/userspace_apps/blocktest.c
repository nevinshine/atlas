#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <fcntl.h>

#define RAMDISK_PATH "/dev/ram0"
#define BLOCK_SIZE 512
#define RAMDISK_SIZE (1024 * 1024)

void test_bounds(int fd) {
    printf("[blocktest] Testing boundary conditions...\n");
    char buf[2048];
    memset(buf, 'X', sizeof(buf));
    
    // offset 0, length 5
    lseek(fd, 0, SEEK_SET);
    int res = write(fd, "12345", 5);
    if (res != 5) printf("FAIL: offset 0 len 5 returned %d\n", res);
    
    // offset 1, length 5
    lseek(fd, 1, SEEK_SET);
    res = write(fd, "abcde", 5);
    if (res != 5) printf("FAIL: offset 1 len 5 returned %d\n", res);
    
    // Check what we have so far
    char readbuf[16];
    memset(readbuf, 0, sizeof(readbuf));
    lseek(fd, 0, SEEK_SET);
    read(fd, readbuf, 10);
    // Should be "1abcde" + 0s. Wait, original at 0 was "12345". 
    // Writing at 1 overwrites "2345" and the byte after it.
    // So "1abcde" + 4 null bytes.
    if (strncmp(readbuf, "1abcde", 6) != 0) {
        printf("FAIL: Readback mismatch for offset 0/1: %s\n", readbuf);
    }
    
    // offset 511, length 5
    lseek(fd, 511, SEEK_SET);
    res = write(fd, "CROSS", 5);
    if (res != 5) printf("FAIL: offset 511 len 5 returned %d\n", res);
    
    // offset 512, length 5
    lseek(fd, 512, SEEK_SET);
    res = write(fd, "BLOCK", 5);
    // Wait, the previous write put "CROSS" at 511..515.
    // This one writes "BLOCK" at 512..516. 
    // So 511 is 'C', 512..516 is "BLOCK".
    
    // Check
    lseek(fd, 511, SEEK_SET);
    memset(readbuf, 0, sizeof(readbuf));
    read(fd, readbuf, 6);
    if (strncmp(readbuf, "CBLOCK", 6) != 0) {
        printf("FAIL: Readback mismatch across boundary: %s\n", readbuf);
    }
    
    // offset 510, length 10
    lseek(fd, 510, SEEK_SET);
    res = write(fd, "TEN_BYTES!", 10);
    if (res != 10) printf("FAIL: offset 510 len 10 returned %d\n", res);
    
    // offset 0, length 512
    lseek(fd, 0, SEEK_SET);
    res = write(fd, buf, 512);
    if (res != 512) printf("FAIL: offset 0 len 512 returned %d\n", res);
    
    // offset 0, length 1024
    lseek(fd, 0, SEEK_SET);
    res = write(fd, buf, 1024);
    if (res != 1024) printf("FAIL: offset 0 len 1024 returned %d\n", res);
    
    // last valid byte
    lseek(fd, RAMDISK_SIZE - 1, SEEK_SET);
    res = write(fd, "Z", 1);
    if (res != 1) printf("FAIL: write last byte returned %d\n", res);
    
    // read past end
    lseek(fd, RAMDISK_SIZE - 5, SEEK_SET);
    res = read(fd, buf, 10);
    if (res != 5) printf("FAIL: read past end returned %d (expected 5)\n", res);
    
    // write past end
    lseek(fd, RAMDISK_SIZE - 5, SEEK_SET);
    res = write(fd, "1234567890", 10);
    if (res != 5) printf("FAIL: write past end returned %d (expected 5)\n", res);
    
    printf("[blocktest] Boundary conditions test complete.\n");
}

void test_corruption(int fd) {
    printf("[blocktest] Testing unaligned write corruption...\n");
    // Write AAAA | BBBB | CCCC
    // offset 0, 512, 1024
    
    char bufA[512]; memset(bufA, 'A', 512);
    char bufB[512]; memset(bufB, 'B', 512);
    char bufC[512]; memset(bufC, 'C', 512);
    
    lseek(fd, 0, SEEK_SET);
    write(fd, bufA, 512);
    write(fd, bufB, 512);
    write(fd, bufC, 512);
    
    // Unaligned write in the middle of B
    lseek(fd, 512 + 256, SEEK_SET);
    char *msg = "UNALIGNED_WRITE";
    write(fd, msg, strlen(msg));
    
    // Verify A is intact
    char verifyBuf[512];
    lseek(fd, 0, SEEK_SET);
    read(fd, verifyBuf, 512);
    for (int i = 0; i < 512; i++) {
        if (verifyBuf[i] != 'A') {
            printf("FAIL: Block A corrupted at index %d\n", i);
            break;
        }
    }
    
    // Verify B is intact except the middle
    lseek(fd, 512, SEEK_SET);
    read(fd, verifyBuf, 512);
    for (int i = 0; i < 256; i++) {
        if (verifyBuf[i] != 'B') {
            printf("FAIL: Block B prefix corrupted at index %d\n", i);
            break;
        }
    }
    if (strncmp(verifyBuf + 256, msg, strlen(msg)) != 0) {
        printf("FAIL: Unaligned write data mismatch\n");
    }
    for (int i = 256 + strlen(msg); i < 512; i++) {
        if (verifyBuf[i] != 'B') {
            printf("FAIL: Block B suffix corrupted at index %d\n", i);
            break;
        }
    }
    
    // Verify C is intact
    lseek(fd, 1024, SEEK_SET);
    read(fd, verifyBuf, 512);
    for (int i = 0; i < 512; i++) {
        if (verifyBuf[i] != 'C') {
            printf("FAIL: Block C corrupted at index %d\n", i);
            break;
        }
    }
    
    printf("[blocktest] Unaligned write corruption test complete.\n");
}

int main() {
    int fd = open(RAMDISK_PATH, 0); // Need O_RDWR or similar if defined. 0 usually maps to O_RDONLY in some minimal libcs, let's check.
    // In Atlas, open flags are just passed. 
    if (fd < 0) {
        printf("blocktest FAILED: Could not open %s (ret %d)\n", RAMDISK_PATH, fd);
        return 1;
    }
    
    test_bounds(fd);
    test_corruption(fd);
    
    close(fd);
    printf("blocktest PASS\n");
    return 0;
}
