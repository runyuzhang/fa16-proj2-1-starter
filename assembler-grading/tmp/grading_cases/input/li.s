# Lower bound:
li $t0 -2147483648	# -2^31 is lowest
li $t0 -2147483649	# this should fail

# Upper bound? - no wraparound
li $t0 4294967295	# 2^32 - 1 is highest
li $t0 4294967296	# this should fail

# Lower bound for addiu:
li $t0 -32768	# -2^15
li $t0 -32769	# should be two lines

# Upper bound for addiu:
li $t0 32767	# 2^15 - 1 is highest
li $t0 32768	# should be two lines

# Try some in decimal:
li $t0 0
li $t0 -235242
li $t0 12345
li $t0 123456789
li $t0 -67235

# Try some in hex:
li $t0 0xABCDEF12
li $t0 0x78F3B
li $t0 0xFFFF