# Contains strncpy and streq (renamed to avoid conflicts)

.data
test_buffer:	.word 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF
		.word 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF
		.word 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF
		.word 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF
		.word 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF 0xFFFFFFFF
grading_out_file:	.asciiz "tmpout.txt"
grading_pass_str:	.asciiz "pass"
grading_fail_str:	.asciiz "fail"

.text
grading_test_pass:
	la $a0, grading_out_file
	li $a1, 1
	li $v0, 13
	syscall
	move $a0, $v0
	la $a1, grading_pass_str
	li $a2, 4
	li $v0, 15
	syscall
	li $v0, 16
	syscall
	li $a0, 1
	li $v0, 17
	syscall

grading_test_fail:
        la $a0, grading_out_file
        li $a1, 1
        li $v0, 13
        syscall
        move $a0, $v0
        la $a1, grading_fail_str
        li $a2, 4
        li $v0, 15
        syscall
        li $v0, 16
        syscall
        li $a0, 1
        li $v0, 17
        syscall

strncpy_grading:
	li $t0, 0	
strncpy_grading_start:
	beq $t0, $a2, strncpy_grading_end
	addu $t1, $a1, $t0
	addu $t2, $a0, $t0
	lb $t3, 0($t1)
	sb $t3, 0($t2)
	addiu $t0, $t0, 1
	j strncpy_grading_start
strncpy_grading_end:
	move $v0, $a0
	jr $ra
	
streq_grading:
	beq $a0, $0, streq_grading_false
	beq $a1, $0, streq_grading_false
streq_grading_loop:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	bne $t0, $t1, streq_grading_false
	beq $t0, $0, streq_grading_true
	j streq_grading_loop
streq_grading_true:
	li $v0, 0
	jr $ra
streq_grading_false:
	li $v0, -1
	jr $ra

setup_saved_registers_grading:
	li $sp 0x7fffefe0
	li $s0 1234
	li $s1 2345
	li $s2 3456
	li $s3 4567
	li $s4 5678
	li $s5 6789
	li $s6 7890
	li $s7 8901
	jr $ra

check_saved_registers_grading:
	bne $sp 0x7fffefe0 saved_registers_grading_false
	bne $s0 1234 saved_registers_grading_false
	bne $s1 2345 saved_registers_grading_false
	bne $s2 3456 saved_registers_grading_false
	bne $s3 4567 saved_registers_grading_false
	bne $s4 5678 saved_registers_grading_false
	bne $s5 6789 saved_registers_grading_false
	bne $s6 7890 saved_registers_grading_false
	bne $s7 8901 saved_registers_grading_false
	j grading_test_pass	
saved_registers_grading_false:
	j grading_test_fail
