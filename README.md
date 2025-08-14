# Implementation of A1 in check_scripts_assg1 
1) Various system calls are implemented in this assignment 
2) Specifically for sys_send and sys_recv, I have implemented a very direct solution using spin_locks 
3) I have implemented sys_multi_send using interrupt handler 

# How to run 
1) Clone this repo 
2) cd check_scripts_assg1
3) bash check.sh assignment1_easy_2024AB.1234.tar.gz

# Lets talk about xv6 main ( work in progress - not uploaded in repo )

1) Some new implementation/improvement of syscalls as compared to check_scripts_assg1
    a) I have re-implemented sys_send and sys_recv using message queue for better performance 
    b) Simplified the sys_multi_send removing the use of interupt handler 

2) Real Time Scheduling Implementation - A2 
    a) System Calls:
        sys_sched_policy(pid, policy) — Switch process to EDF, RMS, or default RR.
        sys_exec_time(pid, exec_time) — Set execution time limit (process auto-terminated by kernel).
        sys_deadline(pid, deadline) — Set relative deadline.
        sys_rate(pid, rate) — Set RMS rate (in inv. seconds; determines priority).

    b) Kernel Extensions:
        Added scheduling-related fields to struct proc.

# A3 

1) Currently doing Part-1 of assignment related to buffer attack, but got no success 