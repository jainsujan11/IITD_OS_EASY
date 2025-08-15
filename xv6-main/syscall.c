#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

#include "trace.h"

#include "spinlock.h"
#include "communication.h"

// queue and spinlock, to be needed in this file.

// User code makes a system call with INT T_SYSCALL.
// System call number in %eax.
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
  *ip = *(int*)(addr);
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}

extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_fork(void);
extern int sys_fstat(void);
extern int sys_getpid(void);
extern int sys_kill(void);
extern int sys_link(void);
extern int sys_mkdir(void);
extern int sys_mknod(void);
extern int sys_open(void);
extern int sys_pipe(void);
extern int sys_read(void);
extern int sys_sbrk(void);
extern int sys_sleep(void);
extern int sys_unlink(void);
extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);
extern int sys_getyear(void);
extern int sys_print_count(void);
extern int sys_toggle(void);
extern int sys_ps(void);
extern int sys_add(void);
extern int sys_send(void);
extern int sys_recv(void);
extern int sys_send_multi(void);

extern int sys_exec_time(void);
extern int sys_deadline(void);
extern int sys_rate(void);
extern int sys_sched_policy(void);
extern int sys_get_pinfo(void);

static int (*syscalls[])(void) = {
[SYS_fork]    sys_fork,
[SYS_exit]    sys_exit,
[SYS_wait]    sys_wait,
[SYS_pipe]    sys_pipe,
[SYS_read]    sys_read,
[SYS_kill]    sys_kill,
[SYS_exec]    sys_exec,
[SYS_fstat]   sys_fstat,
[SYS_chdir]   sys_chdir,
[SYS_dup]     sys_dup,
[SYS_getpid]  sys_getpid,
[SYS_sbrk]    sys_sbrk,
[SYS_sleep]   sys_sleep,
[SYS_uptime]  sys_uptime,
[SYS_open]    sys_open,
[SYS_write]   sys_write,
[SYS_mknod]   sys_mknod,
[SYS_unlink]  sys_unlink,
[SYS_link]    sys_link,
[SYS_mkdir]   sys_mkdir,
[SYS_close]   sys_close,

[SYS_getyear] sys_getyear,
[SYS_print_count] sys_print_count,
[SYS_toggle]      sys_toggle,
[SYS_ps]          sys_ps,
[SYS_add]         sys_add,
[SYS_send]        sys_send,
[SYS_recv]        sys_recv,
[SYS_send_multi]  sys_send_multi,

[SYS_exec_time]   sys_exec_time,
[SYS_deadline]    sys_deadline,
[SYS_rate]        sys_rate,
[SYS_sched_policy] sys_sched_policy,
[SYS_get_pinfo]    sys_get_pinfo

};


extern int current_trace_state;  // made this variable for toggle on-off system call

extern int system_call_count[TOT]; // this thing is for tracing other system calls


void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {

    curproc->tf->eax = syscalls[num]();
    if (current_trace_state == TRACE_ON && num != SYS_toggle && num != SYS_print_count)  {  // incrememting the sys_call counts if trace state is ON
  		system_call_count[num]++;
    }
  } else {
    cprintf("%d %s: unknown sys call %d\n",curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
  
}

// now we need some data structures for bookkeeping each transaction

int allocated[512] = {0};
struct message msg_buffer[512];
struct spinlock buffer_lock;
struct spinlock msgQueue_locks[NPROC];

int setupp = 0; 
struct msgQueue QQ[NPROC];  // this is queue of messages for each process

int initialise(void) {
  if(setupp == 0) {
    for(int i = 0; i < NPROC; i++) {
      setup(&QQ[i]);
    }
    for(int i = 0; i < NPROC; i++) {
      initlock(&(msgQueue_locks[i]),"msgQueue_locks");
      initlock(&buffer_lock,"buffer_lock");
    }
    setupp = 1;
  } 
  return 0;
}

int 
sys_send(void) {
  
  initialise();  

  int sender_pid;
  int rec_pid;
  void* msg;

  // now we need to extract these function arguments from the stack

  int x = argint(0,&sender_pid);
  int y = argint(1,&rec_pid);
  int z = argptr(2,(void*)&msg, sizeof(void*));

  if (x < 0 || y < 0 || z < 0) {  // some error in extraction
    return -1;
  }

  // send(sender_pid, rec_pid, msg);
  struct message* final;   // this is the message struct we will add in our data 
  
  acquire(&buffer_lock);
  for(int i=0; i < NELEM(msg_buffer); i++) {
    if(allocated[i] == 0) {
      allocated[i] = 1;
      release(&buffer_lock);
      final = &msg_buffer[i];
      
      final->bp = i;
      memmove(final->msg,msg,8);
      final->next = 0;

      acquire(&msgQueue_locks[rec_pid]);
      add_in_queue(final, &QQ[rec_pid]);  // inserted in the receiver's queue
      unblock(rec_pid);
      release(&msgQueue_locks[rec_pid]);
      return 0;
    }
  }

  // struct message temp;
  // temp.bp = 0;
  // temp.sender_pid = sender_pid;
  // memmove(temp.msg, msg, 8);
  // temp.next = 0;
  // final = &temp;
  // acquire(&msgQueue_locks[rec_pid]);
  // add_in_queue(final, &QQ[rec_pid]);
  // unblock(rec_pid);
  // release(&msgQueue_locks[rec_pid]);

  return 0;
}

int
sys_send_multi(void) {

  initialise();

  int sender_pid;
  int *rec_pids;
  void* msg;

  int total = 8;  // assume array size is 8, 

  int x = argint(0, &sender_pid);
  int y = argptr(1, (void*) &rec_pids, total * sizeof(int));
  int z = argptr(2, (void*) &msg, sizeof(void*));

  if (x < 0 || y < 0 || z < 0) {
    return -1;
  }

  for(int j = 0; j < total; j++) {
    if(rec_pids[j] == -1) {
      continue;
    }
    if(rec_pids[j] != myproc()->pid) {
      int rec_pid = rec_pids[j];
      struct message* final;   // this is the message struct where we will add in our data 
  
      acquire(&buffer_lock);
      for(int i = 0; i < NELEM(msg_buffer); i++) {
        if(allocated[i] == 0) {
          allocated[i] = 1;
          release(&buffer_lock);
          final = &msg_buffer[i];
          
          final->bp = i;
          memmove(final->msg,msg,8);
          final->next = 0;

          acquire(&msgQueue_locks[rec_pid]);
          add_in_queue(final, &QQ[rec_pid]);  // inserted in the receiver's queue
          unblock(rec_pid);
          release(&msgQueue_locks[rec_pid]);
          break;
        }
      }
    }
  }
  return 0;
}

int 
sys_recv(void) {
 
  initialise();
  void *msg;
  int currentPID = myproc()->pid;
  
  int x = argptr(0, (void*)&msg, sizeof(void*));
  if(x < 0) {
    return -1;
  }

  acquire(&(msgQueue_locks[currentPID]));
  struct message* tempMSG = remove_from_queue(&QQ[currentPID]);
  
  if(tempMSG == 0) {
    block(&(msgQueue_locks[currentPID]));
    tempMSG = remove_from_queue(&QQ[currentPID]);
  }

  // cprintf("%s \n", tempMSG -> msg);  // for debugging

  release(&(msgQueue_locks[currentPID]));
  allocated[tempMSG->bp] = 0;
  memmove(msg,tempMSG->msg,8);

  return 0;
}

