# strncpy(): non-empty string

.include "grading_core.s"
.include "../tmp/string.s"

.data
test_str:		.asciiz "this is a string to copy"

.globl main
.text

main:
	jal setup_saved_registers_grading

	la $a0, test_buffer
	la $a1, test_str
	li $a2, 25		# note: len + 1
	jal strncpy
	
	j check_saved_registers_grading
