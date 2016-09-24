# hex_to_str(): 

.include "grading_core.s"
.include "../tmp/parsetools.s"

.data
hex_str:	.asciiz "abcdef12\n"

.globl main
.text

main:
	jal setup_saved_registers_grading

	li $a0, 2882400018
	la $a1, test_buffer
	jal hex_to_str
	
	j check_saved_registers_grading
