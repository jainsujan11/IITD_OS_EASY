#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

#include "trace.h"
#include "syscall.h"



int current_trace_state = 0;

int system_call_count[TOT] = {0};


static char *syscall_name[] = {

[SYS_chdir]    "sys_chdir",
[SYS_close]    "sys_close",
[SYS_dup]      "sys_dup",
[SYS_exec]     "sys_exec",
[SYS_exit]     "sys_exit",
[SYS_fork]     "sys_fork",
[SYS_fstat]    "sys_fstat",
[SYS_getpid]   "sys_getpid",
[SYS_getyear]    "sys_getyear",
[SYS_kill]     "sys_kill",
[SYS_link]     "sys_link",
[SYS_mkdir]    "sys_mkdir",
[SYS_mknod]    "sys_mknod",
[SYS_open]     "sys_open",
[SYS_pipe]     "sys_pipe",
[SYS_print_count] "sys_print_count",
[SYS_read]     "sys_read",
[SYS_sbrk]     "sys_sbrk",
[SYS_sleep]    "sys_sleep",
[SYS_toggle]   "sys_toggle",
[SYS_unlink]   "sys_unlink",
[SYS_uptime]   "sys_uptime",
[SYS_wait]     "sys_wait",
[SYS_write]    "sys_write",
[SYS_ps]       "sys_ps",
[SYS_add]      "sys_add",
[SYS_send]     "sys_send",
[SYS_recv]     "sys_recv",
[SYS_send_multi]     "sys_send_multi",

[SYS_exec_time]   "sys_exec_time",
[SYS_deadline]    "sys_deadline",
[SYS_rate]        "sys_rate",
[SYS_sched_policy] "sys_sched_policy",
[SYS_get_pinfo]    "sys_get_pinfo"

};

int sorted_sys_calls[] = {
SYS_add,
SYS_chdir,
SYS_close,
SYS_deadline,
SYS_dup,
SYS_exec,
SYS_exec_time,
SYS_exit,
SYS_fork,
SYS_fstat,
SYS_getpid,
SYS_get_pinfo,
SYS_kill,
SYS_link,
SYS_mkdir,
SYS_mknod,
SYS_open,
SYS_pipe,
SYS_print_count,
SYS_ps,
SYS_rate,
SYS_read,
SYS_recv,
SYS_sbrk,
SYS_sched_policy,
SYS_send,
SYS_send_multi,
SYS_sleep,
SYS_toggle,
SYS_unlink,
SYS_uptime,
SYS_wait,
SYS_write
};

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int 
sys_getyear(void) {
  return 2003;
}


int 
sys_toggle() {    
  if (current_trace_state == TRACE_ON) {
    current_trace_state = TRACE_OFF;
  } else {
    current_trace_state = TRACE_ON;
  }
  for (int i = 0; i < TOT; i++) {
    system_call_count[i] = 0;
  }  
  return 0;
}

int 
sys_print_count() {
  int z = 0;
  for (int i = 0; i < NELEM(sorted_sys_calls); i++) {  // nelem function is defined in defs.h
    int j = sorted_sys_calls[i];
    if (system_call_count[j] > 0 && j != SYS_print_count && j != SYS_toggle) {
      cprintf("%s %d\n", syscall_name[j], system_call_count[j]);
      z += system_call_count[j];   // z is the count of all the system calls encountered
    }
  }
  return 0; 
}

int 
sys_ps() {
  return ps();
}

int
sys_add(void) {
    int a, b;
    int i = argint(0, &a);
    int j = argint(1, &b);

    if (i < 0 || j < 0) {
      return -1;
    }
    return a + b;
}

int
sys_exec_time(void) {
    int a, b;
    int i = argint(0, &a);
    int j = argint(1, &b);

    if (i < 0 || j < 0) {
      return -22;
    }
    // a: pid, b: exec_time
    return __exec_time(a, b);
}

int
sys_deadline(void) {
    int a, b;
    int i = argint(0, &a);
    int j = argint(1, &b);

    if (i < 0 || j < 0) {
      return -22;
    }
    // a: pid, b: deadline
    return __deadline(a, b);
}

int
sys_rate(void) {
    int a, b;
    int i = argint(0, &a);
    int j = argint(1, &b);

    if (i < 0 || j < 0) {
      return -22;
    }
    // a: pid, b: rate
    return __rate(a, b);
}

int
sys_sched_policy(void) {
    int a, b;
    int i = argint(0, &a);
    int j = argint(1, &b);

    if (i < 0 || j < 0) {
      return -22;
    }
    // a: pid, b: policy
    return __policy(a, b);
}

int 
sys_get_pinfo(void) {   // now of no use
    void* pstate;
    int i = argptr(0,(void*) &pstate, sizeof(void*));

    if (i < 0) {
      return -22;
    }
   return 0;

}







