#include "stdlib.h"
#include <atlas/process.h>

void abort(void) {
    // 6 is SIGABRT on Linux
    kill(getpid(), 6);
    while (1) {}
}
