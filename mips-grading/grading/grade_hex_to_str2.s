# hex_to_str(): 

.include "grading_core.s"
.include "../tmp/parsetools.s"

.data
hex_str:	.asciiz "00034532\n"

.globl main
.text

main:
	li $a0, 214322
	la $a1, test_buffer
	jal hex_to_str
	
	la $a0, test_buffer
	la $a1, hex_str
	jal streq_grading
	
	bne $v0, 0, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
