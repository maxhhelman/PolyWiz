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
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	.cfi_offset %rbx, -16
	movl	$0, 12(%rsp)
	leaq	.Lfmt(%rip), %rbx
	cmpl	$4, 12(%rsp)
	jg	.LBB0_3
	.p2align	4, 0x90
.LBB0_2:                                # %while_body
                                        # =>This Inner Loop Header: Depth=1
	movl	12(%rsp), %esi
	xorl	%eax, %eax
	movq	%rbx, %rdi
	callq	printf@PLT
	incl	12(%rsp)
	cmpl	$4, 12(%rsp)
	jle	.LBB0_2
.LBB0_3:                                # %merge
	leaq	.Lfmt(%rip), %rdi
	movl	$42, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	addq	$16, %rsp
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
