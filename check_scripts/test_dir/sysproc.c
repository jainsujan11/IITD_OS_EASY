#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscall.h"
#include "trace.h"

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

/* first 2 system calls */

int 
sys_toggle(void)
{
		
	state ^= 1;
	if(state == 0){
		for(int i = 0; i < SYS_MAX+1; i++)
    			syscall_counts[i] = 0;
	}
	else{
		// nothing to be done 
	}
	return 0;
}


int 
sys_print_count(void)
{
	for(int i = 0;i < SYS_MAX+1;i++)
	{
		if(syscall_counts[i] > 0){
			if(i == 1){
				cprintf("sys_fork %d\n",syscall_counts[i]);
			}
			else if(i == 15){
				cprintf("sys_open %d\n",syscall_counts[i]);
			}
			else if(i == 16)
			{
				cprintf("sys_write %d\n",syscall_counts[i]);
			}
			else if(i == 21)
			{
				cprintf("sys_close %d\n",syscall_counts[i]);
			}
			else{
				cprintf("%d %d\n",i,syscall_counts[i]);
			}
			
		}
	}
	return 0;
}

/* next two calls */

int 
sys_add(void)
{
	int a, b;
	if (argint(0, &a) < 0 || argint(1, &b) < 0)
	return -1;
	return a + b;

}

int
sys_ps(void)
{
  struct proc *p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state != UNUSED){
      cprintf("pid:%d name:%s\n", p->pid, p->name);
    }
  }
  release(&ptable.lock);
  return 0;
}


int sys_send(void){
	int sender_pid, rec_pid;
	char* msg;
	struct proc *p; 
	if(argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, MSG_LEN) < 0) return -1;
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
	    if (p->pid == rec_pid) {
	      acquire(&p->msg_lock);
	      if (p->has_msg) {
		release(&p->msg_lock);
		return -1;  // Receiver already has a message
	      }

	      memmove(p->msg, msg, MSG_LEN);
	      p->has_msg = 1;
	      p->sender = myproc();  // Optional
	      wakeup(p);  // In case receiver is sleeping
	      release(&p->msg_lock);
	      return 0;
	    }
	}
	return -1; // no receiver found 
}


int sys_recv(void){
	char* msg;
	struct proc *p = myproc();
	if(argptr(0, &msg, MSG_LEN) < 0) return -1;
	acquire(&p->msg_lock);
	while(!p->has_msg){
		sleep(p, &p->msg_lock);
	}
	memmove(msg,p->msg,MSG_LEN);
	p->has_msg = 0;
	release(&p->msg_lock);
	
	return 0;
}

int
sys_send_multi(void)
{
  int sender_pid;
  int *rec_pids;
  char *msg;

  if (argint(0, &sender_pid) < 0 ||
      argptr(1, (void*)&rec_pids, sizeof(int) * NPROC) < 0 ||
      argptr(2, &msg, 8) < 0)
    return -1;

  struct proc *p;
  for (int i = 0; i < NPROC && rec_pids[i] != -1; i++) {
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
      if (p->pid == rec_pids[i]) {
        memmove(p->msg, msg, 8);
        p->has_msg = 1;

        if (p->msg_handler && p->tf) {
          p->saved_eip = p->tf->eip;
          p->tf->eip = (uint)p->msg_handler; // redirect to handler
        }
      }
    }
  }
  return 0;
}

int
sys_register_msg_handler(void)
{
  void *fn;
  if (argptr(0, (void*)&fn, sizeof(fn)) < 0)
    return -1;
  myproc()->msg_handler = fn;
  return 0;
}

int
sys_sigret(void)
{
  myproc()->tf->eip = myproc()->saved_eip;
  return 0;
}

