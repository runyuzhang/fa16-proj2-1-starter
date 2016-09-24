lui $t0 0
lui $t0 -1	# should fail

lui $t0 65535
lui $t0 65536 # should fail

lui $t0 0xFFFF