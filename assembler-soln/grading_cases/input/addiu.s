# Lower bound
addiu $t0 $t0 -32768
addiu $t0 $t0 -32769	# should fail

# Upper bound
addiu $t0 $t0 32767
addiu $t0 $t0 32768		# should fail

addiu $t0 $t0 0x7FFF
addiu $t0 $t0 0x8000	# should fail

# Others
addiu $t0 $t0 0
addiu $t0 $t0 2541

# Hex
addiu $t0 $t0 0x63BF
addiu $t0 $t0 0x25