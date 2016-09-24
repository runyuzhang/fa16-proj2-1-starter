	lw $a0, 0($sp)
	jal func2
	addiu $t3, $v0, 0
	jr $ra
	
func3:
	li $v0, 0xABCD1234
	jr $ra
	
	
