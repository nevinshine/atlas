#ifndef ATLAS_PROCESS_H
#define ATLAS_PROCESS_H

int getpid(void);
int waitpid(int pid, int *wstatus, int options);
int fork(void);
int execve(const char *pathname, char *const argv[], char *const envp[]);
int kill(int pid, int sig);
void _exit(int status);

#endif
