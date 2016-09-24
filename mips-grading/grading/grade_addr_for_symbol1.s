# Tests using string literal

.include "grading_core.s"
.include "../tmp/symbol_list.s"

.data
# Test strings
test_label1:	.asciiz "Label 1"
test_label2:	.asciiz "Label 2"
test_label3:	.asciiz "Label 3"

# Test nodes
node1:		.word 1234 test_label1 0
node2:		.word 3456 test_label2 node1
node3:		.word 5678 test_label3 node2

temporary_space:	.word 0

.globl main
.text

main:	
	la $a0, node3
	la $a1, test_label1
	jal addr_for_symbol
	la $t0, temporary_space
	sw $v0, 0($t0)
	
	la $a0, node3
	la $a1, test_label3
	jal addr_for_symbol
	
	xori $t0, $v0, 5678
	la $t1, temporary_space
	lw $t1, 0($t1)
	xori $t1, $t1, 1234
	or $v0, $t0, $t1
	
	bne $v0, $0, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
