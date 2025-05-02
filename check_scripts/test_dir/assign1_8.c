#include "types.h"
#include "stat.h"
#include "user.h"

#define WORKERS 8
#define MSG_LEN 8
#define SIZE 1000


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
}
