# inst_needs_relocation(): jump

.include "grading_core.s"
.include "../tmp/linker_utils.s"

.globl main
.text

main:
	li $a0, 0x09100010
	jal inst_needs_relocation

	bne $v0, 1, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
