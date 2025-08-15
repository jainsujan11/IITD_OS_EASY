
struct message {
    char msg[8]; // each messsage will be 8 bytes long
    int bp; // this is the position in buffer (buffer_position)
    struct message *next; // pointer to the next message
};

struct msgQueue {
    struct message *front;  // front of the message queue
    struct message *last;   // last of the message queue
};