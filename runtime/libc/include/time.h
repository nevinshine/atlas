#ifndef _TIME_H
#define _TIME_H

#include <sys/types.h>

struct timespec {
    time_t tv_sec;
    long   tv_nsec;
};

#endif
