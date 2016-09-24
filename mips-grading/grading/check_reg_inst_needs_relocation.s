# inst_needs_relocation(): jal

.include "grading_core.s"
.include "../tmp/linker_utils.s"

.globl main
.text

main:
	jal setup_saved_registers_grading

	li $a0, 0x0c001234
	jal inst_needs_relocation

	j check_saved_registers_grading
