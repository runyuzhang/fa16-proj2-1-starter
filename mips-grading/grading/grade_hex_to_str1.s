# hex_to_str(): 

.include "grading_core.s"
.include "../tmp/parsetools.s"

.data
hex_str:	.asciiz "abcdef12\n"

.globl main
.text

main:
	li $a0, 2882400018
	la $a1, test_buffer
	jal hex_to_str
	
	la $a0, test_buffer
	la $a1, hex_str
	jal streq_grading
	
	bne $v0, 0, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
