# Tests using string literal

.include "grading_core.s"
.include "../tmp/symbol_list.s"

.data
# Test strings
test_label1:	.asciiz "Label 1"
test_label2:	.asciiz "Label 2"
test_label3:	.asciiz "Label 3"
test_label4:	.asciiz "Label 4"

# Test nodes
node1:		.word 1234 test_label1 0
node2:		.word 3456 test_label2 node1
node3:		.word 5678 test_label3 node2

.globl main
.text

main:	
	la $a0, node3
	la $a1, test_label4
	jal addr_for_symbol
	
	li $t0, -1
	xor $v0, $v0, $t0

	bne $v0, $0, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
