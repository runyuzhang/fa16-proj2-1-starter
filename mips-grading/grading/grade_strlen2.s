# Grading strlen()

.include "grading_core.s"
.include "../tmp/string.s"

.data
test_str:		.asciiz ""

.globl main
.text

main:
	la $a0, test_str
	jal strlen
	
	bne $v0, 0, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
