#ifndef _LIBC_ERRNO_H
#define _LIBC_ERRNO_H

int *__get_thread_errno_ptr(void);
#define errno (*__get_thread_errno_ptr())

#endif
