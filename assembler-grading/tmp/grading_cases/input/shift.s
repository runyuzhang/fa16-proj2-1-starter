sll $t0, $t3, 0
sll $t0, $t5, -1	# this should fail

sll $a3, $a5, 31
sll $t3, $a5, 32	# this should fail

sll $t3 $a2 0xFF
sll $t3 $a0 0x21
sll $t3 $a0 0x22
