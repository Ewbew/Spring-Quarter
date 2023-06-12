SubLoop:
	
	be t3, t1, checkLoop
	
	print_str(dollar)
	
	print_str(star)
	
	# Dollar sign
	write_to_buffer(0x24)
	
	# Star/asteriks
	write_to_buffer(0x2a)
	
	# Wrote to characters, a byte each, so we increment t2 with 2
	addi t2, t2, 2
	
	addi t3, t3, 1
	
	blt t3, t1, SubLoop
	
StringEnd:
	print_str(dollar)
	
	print_str(Zero)
	
	print_str(newLine)
	
	# Dollar sign
	write_to_buffer(0x24)
	
	# Zero
	write_to_buffer(0x30)
	
	# New line
	write_to_buffer(0x0a)
	
	addi t2, t2, 3
	
	#update t1
	addi t1, t1, 1
	
	li t3, 0
	
checkLoop:
	blt t1, t0, Loop
	
	#exit loop