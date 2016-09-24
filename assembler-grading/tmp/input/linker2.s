func2:
	sll $a0, $a0, 3
	blt $a0, $a1, done
	jal func3
	addiu $v0, $v0, -1
done:
	jr $ra