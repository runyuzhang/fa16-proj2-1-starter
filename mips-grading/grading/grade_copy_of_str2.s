# copy_of_str(): multiple strings

.include "grading_core.s"
.include "../tmp/string.s"

.data
test_str:		.asciiz "this is a string to copy"
test_str2:		.asciiz "another string"
dummy_str:		.asciiz "aaaaaaaaaaaaaaaaaaaaaaaaaaaa"

temporary_space: .word 0
		
.globl main
.text

main:
	# Actual string
	la $a0, test_buffer
	la $a1, test_str
	li $a2, 25		# note: len + 1
	jal strncpy_grading
	
	la $a0, test_buffer
	jal copy_of_str
	la $t0, temporary_space
	sw $v0, 0($t0)
	
	# Another string
	la $a0, test_buffer
	la $a1, test_str
	li $a2, 15		# note: len + 1
	jal strncpy_grading
	
	la $a0, test_buffer
	jal copy_of_str
	
	la $a0, test_buffer
	la $a1, dummy_str
	li $a2, 29		# note: len + 1
	jal strncpy_grading
	
	la $t0, temporary_space
	lw $a0, 0($t0)
	la $a1, test_str
	jal streq_grading
	
	bne $v0, 0, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
