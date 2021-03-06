# strncpy(): non-empty string

.include "grading_core.s"
.include "../tmp/string.s"

.data
test_str:		.asciiz "this is a string to copy"

.globl main
.text

main:
	la $a0, test_buffer
	la $a1, test_str
	li $a2, 25		# note: len + 1
	jal strncpy
	
	la $a0, test_buffer
	la $a1, test_str
	jal streq_grading

	bne $v0, 0, grading_false
	j grading_test_pass
grading_false:
	j grading_test_fail
