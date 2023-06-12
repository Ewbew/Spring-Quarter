# Name: Otto Sejrskild Santesson
# Cruz ID: 2008415
# 2023, Spring quarter
# CSE 12, Lab 3, first assignment w. RISC-V
# The following program prompts the user for a positive integer, which denotes the height of the output pattern.
# The output pattern follows a "tattooed right-angled triangle", using stars (asterisks), dollar signs, '0' and newline.
# Code can be run after having assembled successfully – afterwords, run the code and follow the instructions 
# of the 'Run I/O' box



.macro exit #macro to exit program
	li a7, 10
	ecall
	.end_macro	

.macro print_str(%string1) #macro to print any string
	li a7,4 
	la a0, %string1
	ecall
	.end_macro
	
	
.macro read_n(%x)#macro to input integer n into register x
	li a7, 5
	ecall 		
	#a0 now contains user input
	addi %x, a0, 0
	.end_macro
	
.macro print_n(%x)#macro to input integer n into register x
	addi a0,%x, 0
	li a7, 1
	ecall
.end_macro

.macro 	file_open_for_write_append(%str)
	la a0, %str
	li a1, 1
	li a7, 1024
	ecall
.end_macro
	
.macro  initialise_buffer_counter
	#buffer begins at location 0x10040000
	#location 0x10040000 to keep track of which address we store each character byte to 
	#actual buffer to store the characters begins at 0x10040008
	
	#initialize mem[0x10040000] to 0x10040008
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t1, 8(sp)
	
	li t0, 0x10040000
	li t1, 0x10040008
	sd t1, 0(t0)
	
	ld t0, 0(sp)
	ld t1, 8(sp)
	addi sp, sp, 16
	.end_macro
	

.macro write_to_buffer(%char)
	#NOTE:this macro can add ONLY 1 character byte at a time to the file buffer!
	
	addi sp, sp, -16
	sd t0, 0(sp)
	sd t4, 8(sp)
	
	
	li t0, 0x10040000
	ld t4, 0(t0)#t4 is starting address
	#t4 now points to location where we store the current %char byte
	
	#store character to file buffer
	li t0, %char
	sb t0, 0(t4)
	
	#update address location for next character to be stored in file buffer
	li t0, 0x10040000
	addi t4, t4, 1
	sd t4, 0(t0)
	
	ld t0, 0(sp)
	ld t4, 8(sp)
	addi sp, sp, 16
	.end_macro

.macro fileRead(%file_descriptor_register, %file_buffer_address)
#macro reads upto first 10,000 characters from file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a2, 10000
	li a7, 63
	ecall
.end_macro 

.macro fileWrite(%file_descriptor_register, %file_buffer_address,%file_buffer_address_pointer)
#macro writes contents of file buffer to file
	addi a0, %file_descriptor_register, 0
	li a1, %file_buffer_address
	li a7, 64
	
	#a2 needs to contains number of bytes sent to file
	li a2, %file_buffer_address_pointer
	ld a2, 0(a2)
	sub a2, a2, a1
	
	ecall
.end_macro 

.macro print_file_contents(%ptr_register)
	li a7, 4
	addi a0, %ptr_register, 0
	ecall
	#entire file content is essentially stored as a string
.end_macro
	


.macro close_file(%file_descriptor_register)
	li a7, 57
	addi a0, %file_descriptor_register, 0
	ecall
.end_macro

.data
	prompt: .asciz  "Enter the height of the pattern (must be greater than 0):"
	invalidMsg: .asciz  "Invalid Entry!"
	newLine: .asciz  "\n"
	star_dollar: .asciz  "*$"
	dollar: .asciz  "$"
	star: .asciz "*"
	blankspace: .asciz " "
	outputMsg: .asciz  " display pattern saved to lab3_output.txt "
	filename: .asciz "lab3_output.txt"
	Zero:.asciz"0"
	
.text

	file_open_for_write_append(filename)
	#a0 now contaimns the file descriptor (i.e. ID no.)
	#save to t6 register
	addi t6, a0, 0
	
	initialise_buffer_counter
	
	#for utilsing macro write_to_buffer, here are tips:
	#0x2a is the ASCI code input for star(*)
	#0x24 is the ASCI code input for dollar($)
	#0x30  is the ASCI code input for  the character '0'
	#0x0a  is the ASCI code input for  newLine (/n)

	
	#START WRITING YOUR CODE FROM THIS LINE ONWARDS
	#DO NOT  use the registers a0, a1, a7, t6, sp anywhere in your code.
	
	#................ your code starts here..........................................................#
TryInput:
	# First we show the user the message, that tells them to enter a positive integer
	print_str(prompt)
	read_n(t0)
	
	#t0 now contains the value n 
	
	# If the user input is less than or equal to zero, then the program branches to ErrorInput
	blt t0, zero, ErrorInput
	beq t0, zero, ErrorInput
	
	# Counter for the current iteration (of line)
	li t1, 0
	
	# Counter for the length of the file data
	li t2, 0
	
	# Counter for the current subiteration (of $*)
	li t3, 1
	
	# We jump into the loop
	j Loop

ErrorInput:
	# Prints a message to the user that input is invalid
	print_str(invalidMsg)
	# Prints a new line
	print_str(newLine)
	
	# Jumps back to prompting the user for a new, valid input
	# This process keeps repeating  for as long as the input is invalid
	j TryInput
	

IndentedLoop:
	print_str(dollar)
	
	print_str(star)
	
	# Dollar sign
	write_to_buffer(0x24)
	addi t2, t2, 1
	
	# Star/asteriks
	write_to_buffer(0x2a)
	addi t2, t2, 1
	
	# Increase our counter for t3
	addi t3, t3, 1
	
	# We do another iteration of adding "$*", if the line is still too short
	blt t3, t1, IndentedLoop

Loop:
	# The end to each of every line has the following: "$0\n"
	print_str(dollar)
	
	print_str(Zero)
	
	print_str(newLine)
	
	# Dollar sign
	write_to_buffer(0x24)
	addi t2, t2, 1
	
	# Zero
	write_to_buffer(0x30)
	addi t2, t2, 1
	
	# New line
	write_to_buffer(0x0a)
	addi t2, t2, 1
	
	# Increasing the counter for t1 with 1 
	addi t1, t1, 1
	
	# We reset the counter of t3
	li t3, 0
	
	# If we reached the desired amount of lines, which is the input, then it doesn't branch, 
	# and the program will start going into exit
	# If not, we do another iteration of the top level loop
	blt t1, t0, IndentedLoop
	
	#................ your code ends here..........................................................#
	
	#END YOUR CODE ABOVE THIS COMMENT
	#Don't change anything below this comment!
Exit:	
	#write null character to end of file
	write_to_buffer(0x00)
	
	#write file buffer to file
	fileWrite(t6, 0x10040008,0x10040000)
	addi t5, a0, 0
	
	print_str(newLine)
	print_str(outputMsg)
	
	exit
	
	
