	.arch armv8-a
	.file	"copy.c"
	.text
	.align	2
	.global	_Z6copy_cPKjPm
	.type	_Z6copy_cPKjPm, %function
_Z6copy_cPKjPm:
.LFB16:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, 8]
	str	x1, [sp]
	ldr	x0, [sp, 8]
	ldr	w0, [x0]
	uxtw	x1, w0
	ldr	x0, [sp]
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 4
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 8
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 12
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 16
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 20
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	ldr	x0, [sp, 8]
	add	x0, x0, 24
	ldr	w1, [x0]
	ldr	x0, [sp]
	add	x0, x0, 8
	uxtw	x1, w1
	str	x1, [x0]
	nop
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE16:
	.size	_Z6copy_cPKjPm, .-_Z6copy_cPKjPm
	.ident	"GCC: (GNU) 12.2.1 20221121 (Red Hat 12.2.1-4)"
	.section	.note.GNU-stack,"",@progbits
