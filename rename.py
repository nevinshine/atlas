import os

replacements = {
    "task_t": "thread_t",
    "task_create": "thread_create",
    "task_destroy": "thread_destroy",
    "task_state_t": "thread_state_t",
    "current_task": "current_thread",
    "old_task": "old_thread",
    "new_task": "new_thread",
    "idle_task": "idle_thread",
    "task_a": "thread_a",
    "task_b": "thread_b",
    "task->": "thread->",
    "task.": "thread.",
    "TASK_READY": "THREAD_READY",
    "TASK_RUNNING": "THREAD_RUNNING",
    "TASK_BLOCKED": "THREAD_BLOCKED",
    "TASK_SLEEPING": "THREAD_SLEEPING",
    "TASK_TERMINATED": "THREAD_TERMINATED",
    "kernel/scheduler/task.h": "kernel/scheduler/thread.h",
    "kernel/scheduler/task.o": "kernel/scheduler/thread.o",
}

for root, dirs, files in os.walk("src"):
    for file in files:
        if file.endswith(".c") or file.endswith(".h") or file.endswith(".s"):
            path = os.path.join(root, file)
            with open(path, "r") as f:
                content = f.read()
            original_content = content
            for old, new in replacements.items():
                content = content.replace(old, new)
            
            # Additional targeted replacements
            content = content.replace("struct task ", "struct thread ")
            
            if content != original_content:
                with open(path, "w") as f:
                    f.write(content)

for root, dirs, files in os.walk("include"):
    for file in files:
        if file.endswith(".c") or file.endswith(".h") or file.endswith(".s"):
            path = os.path.join(root, file)
            with open(path, "r") as f:
                content = f.read()
            original_content = content
            for old, new in replacements.items():
                content = content.replace(old, new)
            
            content = content.replace("struct task ", "struct thread ")
            
            if content != original_content:
                with open(path, "w") as f:
                    f.write(content)

with open("Makefile", "r") as f:
    content = f.read()
content = content.replace("kernel/scheduler/task.o", "kernel/scheduler/thread.o")
with open("Makefile", "w") as f:
    f.write(content)

