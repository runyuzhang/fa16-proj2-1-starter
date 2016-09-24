# Grading strlen()

.include "grading_core.s"
.include "../tmp/string.s"

.data
test_str:		.asciiz "hello this is a string"

.globl main
.text

main:
	jal setup_saved_registers_grading

	la $a0, test_str
	jal strlen
	
	j check_saved_registers_grading
	