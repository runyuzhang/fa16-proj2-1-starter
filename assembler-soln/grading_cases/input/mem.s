# Lower bound
lb $t0 -32768($t1)
lb $t0 -32769($t1)	# should fail

lb $t0 32767($t1)
lb $t0 32768($t1)	# should fail

lb $t0 0x7FFF($t1)
lb $t0 0x8000($t1)	# should fail
lb $t0 0xFFFF($t1)	# should fail

lb $t0 0 ($t1)
lbu $t0 0 ($t1)
lw $t0 0 ($t1)
sb $t0 0 ($t1)
sw $t0 0 ($t1)