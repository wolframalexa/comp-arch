/* Alexa Jakob Program 2 ECE251, Spring 2020 */

/* This program takes "input.txt"  max 100 lines of 32 bit integers and sorts them, outputting them to "output.txt"
 Assumption that all lines in the file will contain ints, not some other datatype
*/

.data

.balign 4
scan_pattern_number: .asciz "%d"

.balign 4
output_pattern: .asciz "%d\n"

.balign 4
read: .asciz "r"

.balign 4
write: .asciz "w"

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

.text

.global main

// load numbers from file into array
main:
	push {r7, lr}
	subs sp, sp, #4			// free up space on stack

	ldr r0, address_inputfile
	ldr r1, address_read
	bl fopen			// r0 is the address of the filename

	str r0, [sp]			// putting location of file on the stack

check_file_exists:
	cmp r0, #0			// if file is not present, throw error
	beq print_error_dne

	ldr r10, address_numbersin	// store address of numbers array

	mov r6, #0			// iterator for upcoming loop

read_file:
	cmp r6, #400
	beq print_error_length

	ldr r0, [sp]			// load address of file
	ldr r1, address_scan_pattern_number
	add r2, r10, r6			// scan to the location in array
	bl fscanf

	ldr r0, [sp]			// address of file
	add r6, r6, #4
	bl feof				// read end-of-file indicator to r0

	cmp r0, #0			// check if end of file
	beq read_file

next:
	sub r6, r6, #4			// account for looking for end of file. r6 stores size of array.
	mov r8, #0			// iterator for numbersin
	mov r9, #0			// iterator for numbersout
	mov r12, #0			// r7 will store position of minimum
	ldr r2, address_numbersout

set_up_min:
	ldr r3, [r10, r8]		// first number of numbersin, r3 stores "minimum"
	mov r5, #0			// r6 will tell us whether there have been swaps or not

find_min:
	add r8, r8, #4
	ldr r4, [r10, r8]		// load consecutive value into r4

	cmp r8, r6			// if r8 is larger than the size of the array, move min to numbersout
	beq move_numbersout

	cmp r3, r4
	bgt new_min			// if r3 > r4, r4 is the new min. note that if they are equal they are not swapped

//	cmp r5, #0
//	beq sorted			// if no swaps have been made, the numbers are sorted
//	bl set_up_min


//new_min:
//	mov r3, r4
//	mov r12, r8			// stores position of minimum
//	mov r5, #1
//	bl find_min

move_numbersout:
	cmp r9, r6
	beq sorted

	str r3, [r2, r9]		// stores minimum value at position r9 in new array
	add r9, r9, #4

	mov r11, #2147483647		// max value with 32 bits
	str r11, [r10, r12]		// replace position of min with max value
	mov r8, #0
	bl set_up_min

new_min:
	mov r3, r4
	mov r12, r8
	mov r5, #1
	bl find_min

sorted:
	mov r5, #0
	ldr r0, address_outputfile
	ldr r1, address_write
	bl fopen			// open file in write mode
	str r0, [sp]
	ldr r10, address_numbersout

write_output:
	ldr r0, [sp]
	ldr r1, address_output_pattern
	add r2, r10, r5

	ldr r2, [r2]
	bl fprintf

	add r5, r5, #4
	cmp r5, r6				// if more elements left to print, do it again
	bne write_output

exit:
	adds sp, sp, #4
	pop {r7, lr}
	bx lr

print_error_dne:
	ldr r0, address_error_dne
	bl printf
	mov r0, #1
	bl exit

print_error_length:
	ldr r0, address_error_length
	bl printf
	mov r0, #2

	bl exit

address_scan_pattern_number:	.word scan_pattern_number
address_inputfile:		.word inputfile
address_error_dne:		.word error_dne
address_error_length:		.word error_length
address_outputfile:		.word outputfile
address_numbersin:		.word numbersin
address_numbersout:		.word numbersout
address_read:			.word read
address_write:			.word write
address_output_pattern:		.word output_pattern

/* C-style functions */

.global fprintf
.global fscanf
.global fopen
.global feof
