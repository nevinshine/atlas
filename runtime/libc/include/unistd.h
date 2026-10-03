#ifndef _UNISTD_H
#define _UNISTD_H

#include <stddef.h>

#define STDIN_FILENO  0
#define STDOUT_FILENO 1
#define STDERR_FILENO 2

typedef int pid_t;
typedef long ssize_t;

int getpid(void);
int fork(void);
int execve(const char *pathname, char *const argv[], char *const envp[]);

ssize_t read(int fd, void *buf, size_t count);
ssize_t write(int fd, const void *buf, size_t count);
int close(int fd);

int pipe(int fds[2]);
int dup(int oldfd);
int dup2(int oldfd, int newfd);
int yield(void);

typedef long off_t;
off_t lseek(int fd, off_t offset, int whence);

#define SEEK_SET 0
#define SEEK_CUR 1
#define SEEK_END 2

void _exit(int status);

#endif
