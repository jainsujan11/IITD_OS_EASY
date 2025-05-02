#include "types.h"
#include "stat.h"
#include "user.h"

#define WORKERS 8
#define MSG_LEN 8
#define SIZE 1000


/* To be tested 
void msg_handler() {
  char msg[MSG_LEN];
  recv(msg);
  float mean;
  memmove(&mean, msg, sizeof(float));

  int start = myproc_id * (SIZE / WORKERS);
  int end = start + (SIZE / WORKERS);
  float local = 0;
  for (int j = start; j < end; j++) {
    float diff = arr[j] - mean;
    local += diff * diff;
  }

  memmove(msg, &local, sizeof(float));
  send(getpid(), coordinator_pid, msg);

  sigret(); should be exit() here 
}
*/


int
main(int argc, char *argv[])
{
	if(argc< 2){
		printf(1,"Need type and input filename\n");
		exit();
	}
	char *filename;
	filename=argv[2];
	int type = atoi(argv[1]);
	printf(1,"Type is %d and filename is %s\n",type, filename);
	
	int size=1000;
	short arr[size];
	char c;
	int fd = open(filename, 0);
	for(int i=0; i<size; i++){
		read(fd, &c, 1);
		arr[i]=c-'0';
		read(fd, &c, 1);
	}	
  	close(fd);
  	// this is to supress warning
  	printf(1,"first elem %d\n", arr[0]);
  
  	//----FILL THE CODE HERE for unicast sum


	int coordinator_pid = getpid();

	if (type == 0) {
		// Unicast sum
		int total = 0;
		printf(1,"first elem %d\n", arr[0]);
		for (int i = 0; i < WORKERS; i++) {
			int pid = fork();
			if (pid == 0) {
				printf(1,"first elem %d\n", arr[0]);
				int start = i * (SIZE / WORKERS);
				int end = start + (SIZE / WORKERS);
				int partial = 0;
				for (int j = start; j < end; j++)
				{  partial += arr[j];
				}

				char msg[MSG_LEN];
				printf(1,"Partial %d: %d\n",i,partial);
				*((int *)msg) = partial;
				send(getpid(), coordinator_pid, msg);
				exit();
			}
			else{
				char msg[MSG_LEN];
				recv(msg);
				total += *((int *)msg);
				wait();
			}
		}
		printf(1,"Sum of array for file %s is %d\n", filename,total);
		exit();
	}
	/*
	//----FILL the code for multicast sum 
	else if (type == 1) {
	    // Multicast version
	    for (int i = 0; i < WORKERS; i++) {
	      int pid = fork();
	      if (pid == 0) {
		myproc_id = i;
		register_msg_handler(msg_handler);

		int start = i * (SIZE / WORKERS);
		int end = start + (SIZE / WORKERS);
		int partial = 0;
		for (int j = start; j < end; j++)
		  partial += arr[j];

		char msg[MSG_LEN];
		*((int *)msg) = partial;
		send(getpid(), coordinator_pid, msg);

		while (1);  // wait for multicast-triggered signal
	      } else {
		child_pids[i] = pid;
	      }
	    }

	    int total = 0;
	    for (int i = 0; i < WORKERS; i++) {
	      char msg[MSG_LEN];
	      recv(msg);
	      total += *((int *)msg);
	    }

	    float mean = total / (float)SIZE;

	    // Multicast mean to children
	    char msg[MSG_LEN];
	    memmove(msg, &mean, sizeof(float));
	    int rec_pids[WORKERS + 1];
	    for (int i = 0; i < WORKERS; i++)
	      rec_pids[i] = child_pids[i];
	    rec_pids[WORKERS] = -1;
	    send_multi(getpid(), rec_pids, msg);

	    float total_var = 0;
	    for (int i = 0; i < WORKERS; i++) {
	      char msg[MSG_LEN];
	      recv(msg);
	      float part;
	      memmove(&part, msg, sizeof(float));
	      total_var += part;
	      wait();
	    }

	    printf(1, "Sum = %d\n", total);
	    printf(1, "Variance = %f\n", total_var / SIZE);
	}*/
	
}
