# Empty list

.include "grading_core.s"
.include "../tmp/symbol_list.s"

.data
# Test strings
test_label1:	.asciiz "Label 1"
test_label2:	.asciiz "Label 2"
test_label3:	.asciiz "Label 3"

.globl main
.text
main:	
	li $a0, 0			
	li $a1, 1234
	la $a2, test_label1
	jal add_to_list			# Test label 1
	move $a0, $v0
	li $a1, 3456
	la $a2, test_label2
	jal add_to_list			# Test label 2
	move $a0, $v0
	li $a1, 5678
	la $a2, test_label3			
	jal add_to_list			# Test label 3
	move $s0, $v0
	
	la $a0, grading_out_file
	li $a1, 1
	li $v0, 13
	syscall
	move $s1, $v0
	
	move $a0, $s0
	la $a1, write_symbol
	move $a2, $s1
	jal print_list
	
	move $a0, $s1
	li $v0, 16
	syscall
	
	li $a0, 1
	li $v0, 17
	syscall
