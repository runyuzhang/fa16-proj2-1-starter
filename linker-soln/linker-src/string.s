# CS 61C Summer 2015 Project 2-2 
# string.s

#==============================================================================
#                              Project 2-2 Part 1
#                               String README
#==============================================================================
# In this file you will be implementing some utilities for manipulating strings.
# The functions you need to implement are:
#  - strlen()
#  - strncpy()
#  - copy_of_str()
# Test cases are in linker-tests/test_string.s
#==============================================================================

.data
newline:	.asciiz "\n"
tab:	.asciiz "\t"

.text
#------------------------------------------------------------------------------
# function strlen()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string input
#
# Returns: the length of the string
#------------------------------------------------------------------------------
# Checks to see if there is a string. If so, it loops through each element
# until it finds the first element of the string input that evaluates to $0.

strlen:
	beq $a0, $0, strlen_ret		# Begin strlen()
	li $v0, 0
strlen_loop:
	lb $t0, 0($a0)
	beq $t0, $0, strlen_ret
	addiu $a0, $a0, 1
	addiu $v0, $v0, 1
	j strlen_loop
strlen_ret:
	jr $ra			# End strlen()

#------------------------------------------------------------------------------
# function strncpy()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = pointer to destination array
#  $a1 = source string
#  $a2 = number of characters to copy
#
# Returns: the destination array
#------------------------------------------------------------------------------
# Checks to see how many characters must be copied. While there are characters
# to be copied, loads one char from source and stores into respective address 
# in the destination array.

strncpy:
	li $t0, 0			# Begin strncpy()
strncpy_start:
	beq $t0, $a2, strncpy_end
	addu $t1, $a1, $t0
	addu $t2, $a0, $t0
	lb $t3, 0($t1)
	sb $t3, 0($t2)
	addiu $t0, $t0, 1
	j strncpy_start
strncpy_end:
	move $v0, $a0
	jr $ra			# End strncpy()

#------------------------------------------------------------------------------
# function copy_of_str()
#------------------------------------------------------------------------------
# Creates a copy of a string. You will need to use sbrk (syscall 9) to allocate
# space for the string. strlen() and strncpy() will be helpful for this function.
#
# Arguments:
#   $a0 = string
#
# Returns: pointer to the copy of the string
#------------------------------------------------------------------------------
# Calls strlen in order to get the length of the string and the amount of 
# bytes necessary to allocate for through syscall 9. Returns this allocated
# space after copying the original sting into it.

copy_of_str:
	addiu $sp, $sp, -8		# Begin copy_of_str()
	sw $s0, 4($sp)
	sw $ra, 0($sp)
	
	move $s0, $a0
	jal strlen		# $v0 = length of string
	addiu $a0, $v0, 1	# +1 for null terminator
	li $v0, 9
	syscall		# $v0 = buffer of strlen() + 1 bytes
	move $a2, $a0 
	move $a0, $v0	# $a0 = pointer to destination
	move $a1, $s0
	jal strncpy		# $v0 = dest array
	
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addiu $sp, $sp, 8
	jr $ra			# End copy_of_str()

###############################################################################
#                 DO NOT MODIFY ANYTHING BELOW THIS POINT                       
###############################################################################

#------------------------------------------------------------------------------
# function streq() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string 1
#  $a1 = string 2
#
# Returns: 0 if string 1 and string 2 are equal, -1 if they are not equal
#------------------------------------------------------------------------------
streq:
	beq $a0, $0, streq_false	# Begin streq()
	beq $a1, $0, streq_false
streq_loop:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	bne $t0, $t1, streq_false
	beq $t0, $0, streq_true
	j streq_loop
streq_true:
	li $v0, 0
	jr $ra
streq_false:
	li $v0, -1
	jr $ra			# End streq()

#------------------------------------------------------------------------------
# function dec_to_str() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Convert a number to its unsigned decimal integer string representation, eg.
# 35 => "35", 1024 => "1024". 
#
# Arguments:
#  $a0 = int to write
#  $a1 = character buffer to write into
#
# Returns: the number of digits written
#------------------------------------------------------------------------------
dec_to_str:
	li $t0, 10			# Begin dec_to_str()
	li $v0, 0
dec_to_str_largest_divisor:
	div $a0, $t0
	mflo $t1		# Quotient
	beq $t1, $0, dec_to_str_next
	mul $t0, $t0, 10
	j dec_to_str_largest_divisor
dec_to_str_next:
	mfhi $t2		# Remainder
dec_to_str_write:
	div $t0, $t0, 10	# Largest divisible amount
	div $t2, $t0
	mflo $t3		# extract digit to write
	addiu $t3, $t3, 48	# convert num -> ASCII
	sb $t3, 0($a1)
	addiu $a1, $a1, 1
	addiu $v0, $v0, 1
	mfhi $t2		# setup for next round
	bne $t2, $0, dec_to_str_write
	jr $ra			# End dec_to_str()
