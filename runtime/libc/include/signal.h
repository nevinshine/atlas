#ifndef _SIGNAL_H
#define _SIGNAL_H

#include <sys/types.h>

#define SIGINT  2
#define SIGKILL 9
#define SIGTERM 15

typedef void (*__sighandler_t)(int);

#define SIG_DFL ((__sighandler_t)0)
#define SIG_IGN ((__sighandler_t)1)
#define SIG_ERR ((__sighandler_t)-1)

int kill(pid_t pid, int sig);

#endif
