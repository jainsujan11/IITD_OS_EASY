#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "communication.h"

#define NULL 0

void setup(struct msgQueue *Q) {
  Q->front = NULL;
  Q->last = NULL;
}

void add_in_queue(struct message *n, struct msgQueue *Q) {
  n->next = NULL;

  if (Q->last == NULL) {
    Q->front = n;
    Q->last = n;
  } else {
    Q->last->next = n;
    Q->last = n;
  }
}

struct message *remove_from_queue(struct msgQueue *Q) {
  if (Q->front == NULL) {
    return NULL;
  }

  struct message *m = Q->front;
  Q->front = Q->front->next;

  if (Q->front == NULL) {
    Q->last = NULL;
  }

  return m;
}
