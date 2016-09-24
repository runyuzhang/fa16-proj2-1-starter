# Tests using string literal

.include "grading_core.s"
.include "../tmp/symbol_list.s"

.data
test_label1:	.asciiz "Label 1"

.globl main
.text

main:	
	la $a0, 0
	la $a1, test_label1
	jal addr_for_symbol
	
	li $t0, -1
	xor $v0, $v0, $t0

	bne $v0, $0, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
