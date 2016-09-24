# Grading strlen()

.include "grading_core.s"
.include "../tmp/string.s"

.data
test_str:		.asciiz "hello this is a string"

.globl main
.text

main:
	la $a0, test_str
	jal strlen
	
	bne $v0, 22, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
