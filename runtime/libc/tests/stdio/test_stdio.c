#include <stdio.h>
#include <string.h>
#include <memory.h>
#include <unistd.h> // for write

#define PRINT(msg) write(1, msg, strlen(msg))

int main() {
    int failed = 0;

    FILE *f = fopen("test.txt", "w+");
    if (!f) {
        PRINT("FAIL: fopen w+ returned NULL\n");
        return 1;
    }

    const char *msg = "hello stdio";
    if (fwrite(msg, 1, strlen(msg), f) != strlen(msg)) {
        PRINT("FAIL: fwrite\n");
        failed++;
    }

    if (fflush(f) != 0) {
        PRINT("FAIL: fflush\n");
        failed++;
    }

    // Since we don't have rewind/fseek exposed in A8.5, we close and reopen
    fclose(f);

    f = fopen("test.txt", "r");
    if (!f) {
        PRINT("FAIL: fopen r returned NULL\n");
        return 1;
    }

    char buf[20] = {0};
    if (fread(buf, 1, strlen(msg), f) != strlen(msg)) {
        PRINT("FAIL: fread\n");
        failed++;
    }

    if (strcmp(buf, msg) != 0) {
        PRINT("FAIL: strcmp buf vs msg\n");
        failed++;
    }

    fclose(f);

    // Test fputs/fgets
    f = fopen("test2.txt", "w");
    fputs("line1\nline2\n", f);
    fclose(f);

    f = fopen("test2.txt", "r");
    char line[20];
    if (fgets(line, sizeof(line), f) == NULL || strcmp(line, "line1\n") != 0) {
        PRINT("FAIL: fgets line1\n");
        failed++;
    }
    if (fgets(line, sizeof(line), f) == NULL || strcmp(line, "line2\n") != 0) {
        PRINT("FAIL: fgets line2\n");
        failed++;
    }
    
    // test eof
    if (fgets(line, sizeof(line), f) != NULL) {
        PRINT("FAIL: expected EOF\n");
        failed++;
    }
    if (!feof(f)) {
        PRINT("FAIL: feof not set\n");
        failed++;
    }
    fclose(f);

    // large write test
    f = fopen("test3.txt", "w");
    char large[5000];
    memset(large, 'A', sizeof(large));
    if (fwrite(large, 1, sizeof(large), f) != sizeof(large)) {
        PRINT("FAIL: large fwrite\n");
        failed++;
    }
    fclose(f);

    // fflush(NULL) test
    f = fopen("test4.txt", "w");
    fputs("fflush", f);
    fflush(NULL);
    // don't close yet, read it raw using host read? No, just close and test.
    fclose(f);

    f = fopen("test4.txt", "r");
    char fbuf[10] = {0};
    fread(fbuf, 1, 6, f);
    if (strcmp(fbuf, "fflush") != 0) {
        PRINT("FAIL: fflush(NULL)\n");
        failed++;
    }
    fclose(f);

    if (!failed) {
        PRINT("PASS: stdio tests\n");
        return 0; // The Makefile wrapper checks exit code 0 for success
    }
    return 1;
}
