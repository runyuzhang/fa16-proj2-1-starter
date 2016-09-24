# inst_needs_relocation(): other

.include "grading_core.s"
.include "../tmp/linker_utils.s"

.globl main
.text

main:
	li $a0, 0x2a00c0f0
	jal inst_needs_relocation

	bne $v0, 0, grading_false
	j grading_test_pass	
grading_false:
	j grading_test_fail
	