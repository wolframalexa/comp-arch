/* Alexa Jakob Program 2 ECE251, Spring 2020 */

/* This program takes "input.txt"  max 100 lines of 32 bit integers and sorts them, outputting them to "output.txt"
 Assumption that all lines in the file will contain ints, not some other datatype
*/

.data

.balign 4
msg1: .asciz "Enter the name of the input file: \n"

.balign 4
msg2: .asciz "Enter the name of the output file: \n"

.balign 4
scan_pattern_number: .asciz "%d"

.balign 4
scan_pattern_string: .asciz "%s"

.balign 4
read: .asciz "r"

.balign 4
write: .asciz "w"

.balign 4
new_line: .asciz "\n" // unix-style line endings

.balign 4
error_dne: .asciz "ERROR: the file does not exist\n"

.balign 4
error_length: .asciz "ERROR: the file is too long\n"

.balign 4
inputfile: .asciz "input.txt"

.balign 4
outputfile: .asciz "output.txt"

.balign 4
numbersin: .skip 400 // 32 bit ints = 4 bytes, * up to 100 ints

.balign 4
numbersout: .skip 400

.balign 4
return: .word 0

.text

.global main

// load numbers from file into array
main:
	ldr r1, address_return
	str lr, [r1]

	ldr r5, address_new_line	// compare to r5 to find null characters
	ldrb r5, [r5]

/*	ldr r0, address_msg1		// prompt user for filename 1
	bl printf
*/
	ldr r0, address_inputfile
	ldr r1, address_read
	bl fopen			// r0 is the address of the filename

	cmp r0, #0			// if file is not present, throw error
	beq print_error_dne

	str r0, [r7]			// r7 stores ptr to file
	ldr r10, address_numbersin	// store address of numbers array

check_file_exists:
	cmp r0, r5
	beq print_error_dne

	mov r6, #0			// iterator

read_file:
	cmp r6, #400
	beq print_error_length

	ldr r0, [r7]			// load address of file
	ldr r1, address_scan_pattern_number
	add r2, r10, r6			// scan to the location in array
	bl fscanf

	ldr r0, [r7]			// address of file
	add r6, r6, #4
	bl feof				// read end-of-file indicator to r0

	cmp r0, #0			// check if end of file
	bne read_file

next:
	sub r6, r6, #4			// account for looking for end of file
	mov r8, #0			// iterator for numbersin
	mov r9, #0			// iterator for numbersout
	ldr r2, address_numbersout

	ldr r3, [r10, r8]		// first number of numbersin, r3 stores "minimum"

find_min:
	add r8, r8, #1
	ldr r4, [r10, r8]

	cmp r4, #0			// if r4 is after the last value of the array, sort
	beq sort

	cmp r3, r4
	bge new_min			// if r3 > r4, r4 is the new min

	bl find_min

new_min:
	mov r3, r4
	bl find_min

sort:










print_error_dne:
	ldr r0, address_error_dne
	bl printf
	mov r0, #0

	ldr lr, address_return
	ldr lr, [lr]
	bx lr

print_error_length:
	ldr r0, address_error_length
	bl printf
	mov r0, #0

	ldr lr, address_return
	ldr lr, [lr]
	bx lr

// sort array

// load numbers from array into output file

address_msg1:			.word msg1
address_msg2:			.word msg2
address_scan_pattern_number:	.word scan_pattern_number
address_inputfile:		.word inputfile
address_new_line:		.word new_line
address_error_dne:		.word error_dne
address_error_length:		.word error_length
address_outputfile:		.word outputfile
address_numbersin:		.word numbersin
address_numbersout:		.word numbersout
address_return: 		.word return
address_read:			.word read
address_write:			.word write


/* C-style functions */

.global printf
.global fscanf
.global fopen
.global fclose
