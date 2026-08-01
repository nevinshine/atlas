#ifndef ATLAS_KTHREAD_H
#define ATLAS_KTHREAD_H

#include "kernel/scheduler/thread.h"

thread_t *kthread_create(const char *name, void (*entry)(void *), void *arg);

#endif
