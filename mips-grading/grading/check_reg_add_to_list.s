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
	jal setup_saved_registers_grading
	
	li $a0, 0			
	li $a1, 1234
	la $a2, test_label1
	jal add_to_list			# Test label 1
	
	j check_saved_registers_grading
