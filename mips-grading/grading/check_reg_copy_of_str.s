# copy_of_str(): single string

.include "grading_core.s"
.include "../tmp/string.s"

.data
test_str:		.asciiz "this is a string to copy"
dummy_str:		.asciiz "aaaaaaaaaaaaaaaaaaaaaaaaaaaa"

temporary_space: .word 0

.globl main
.text

main:
	jal setup_saved_registers_grading
	
	la $a0, test_str
	jal copy_of_str
	
	j check_saved_registers_grading
