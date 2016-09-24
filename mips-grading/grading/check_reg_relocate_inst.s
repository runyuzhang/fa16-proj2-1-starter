# relocate_inst()

.include "grading_core.s"
.include "../tmp/linker_utils.s"

.data
# Test strings
test_label1:	.asciiz "Label 1"
test_label2:	.asciiz "Label 2"
test_label3:	.asciiz "Label 3"
test_label4:	.asciiz "Label 4"
test_label5:	.asciiz "Label 5"
test_label6:	.asciiz "Label 6"
test_label7:	.asciiz "Label 7"
test_label8:	.asciiz "Label 8"

# Symbol Table
sym_7:		.word 0xc test_label7 0
sym_6:		.word 0xf4 test_label6 sym_7
sym_5:		.word 0xabc test_label5 sym_6
sym_4:		.word 0x24 test_label4 sym_5
sym_3:		.word 0xa8 test_label3 sym_4
sym_2:		.word 0x0aaaaaac test_label2 sym_3
sym_tbl:		.word 0x0ababab0 test_label1 sym_2

# Relocation Table
rel_5:		.word 40 test_label5 0
rel_4:		.word 100 test_label8 rel_5
rel_3:		.word 128 test_label2 rel_4
rel_2:		.word 32 test_label1 rel_3
rel_tbl:		.word 24 test_label3 rel_2

.globl main
.text

main:
	jal setup_saved_registers_grading

	la $a0, 0x0c001234
	li $a1, 40
	la $a2, sym_tbl
	la $a3, rel_tbl
	jal relocate_inst
	
	j check_saved_registers_grading
