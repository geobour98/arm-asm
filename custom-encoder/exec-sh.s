.global _start
.text

_start:
	ldr x0, =0x68732f2f6e69622f	// "/bin//sh"

	sub sp, sp, #16		// stack space
	
	str x0, [sp] 		// string on stack
	str xzr, [sp, #8]	// null terminate string
	mov x0, sp		// address of string

	mov x1, xzr 		// argv (NULL)
	mov x2, xzr 		// envp (NULL)
	mov x8, #221		// execve (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke execve syscall
