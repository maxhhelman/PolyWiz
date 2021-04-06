	.text
	.file	"PolyWiz"
	.globl	main                    # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:                                # %entry
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset %rbx, -16
	leaq	.Lfmt(%rip), %rbx
	movl	$3, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$-1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$2, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$50, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$99, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	xorl	%esi, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$99, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	xorl	%esi, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$99, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	xorl	%esi, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$99, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	xorl	%esi, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$99, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	xorl	%esi, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$99, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	xorl	%esi, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	movl	$1, %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	xorl	%eax, %eax
	popq	%rbx
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.type	.Lfmt,@object           # @fmt
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lfmt:
	.asciz	"%d\n"
	.size	.Lfmt, 4

	.type	.Lfmt.1,@object         # @fmt.1
.Lfmt.1:
	.asciz	"%g\n"
	.size	.Lfmt.1, 4

	.type	.Lfmt.2,@object         # @fmt.2
.Lfmt.2:
	.asciz	"%s\n"
	.size	.Lfmt.2, 4


	.section	".note.GNU-stack","",@progbits
