# Lower bound
ori $t0 $t0 0
ori $t0 $t0 -1	# should fail

# Upper bound
ori $t0 $t0 65535
ori $t0 $t0 65536		# should fail

ori $t0 $t0 0x0
ori $t0 $t0 0xFFFF	
ori $t0 $t0 0x10000	# should fail


# Others
ori $t0 $t0 0
ori $t0 $t0 2541

# Hex
ori $t0 $t0 0x63BF
ori $t0 $t0 0x25