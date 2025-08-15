#define NPROC        64  // maximum number of processes

enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

struct process_state{
  int inuse [ NPROC ]; /* whether this slot of the process table is in use (1 or 0) */
  int pid [ NPROC ]; // PID of each process
  enum procstate state [ NPROC ]; /* current state of each process */

  int sched_policy [ NPROC ]; /* current scheduling policy of the process ( -1: XV6 default policy or 0: EDF or 1: RMA ) */
  int priority [ NPROC ]; /* current priority level of each process (1 -3) ( higher value represents lower priority ) */
  int rate [ NPROC ];
  int execution_time [ NPROC ];
  int elapsed_time [ NPROC ];
  int wait_time [ NPROC ];
  int deadline [ NPROC ];

  // struct spinlock state_lock;
};