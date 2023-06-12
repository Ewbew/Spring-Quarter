
#Note that this file only contains a function xyCoordinatesToAddress
#As such, this function should work independent of any caller funmction which calls it
#When using regisetrs, you HAVE to make sure they follow the register usage convention in RISC-V as discussed in lectures.
#Else, your function can potentially fail when used by the autograder and in such a context, you will receive a 0 score for this part

xyCoordinatesToAddress:

	#(x,y) in (a0,a1) arguments
	#a2 argument contains base address
	#returns pixel address in a0
	
	#since this is leaf function, no need to preserve ra 
	
	#Enter code below!
	#make sure to return to calling function after putting correct value in a0!
	
	# Loading the x value into the t0 register
	addi t0, a0, 0
	
	# Loading the y value into the t1 register
	addi t1, a1, 0
	
	# Loading the base address into the t2 register
	addi t2, a2, 0 
	
	slli t0, t0, 2
	
	slli t1, t1, 7
	
	add t0, t0, t1
	
	add a0, t0, t2
	
	ret
					
