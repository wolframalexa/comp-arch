/* Alexa Jakob Program 2 ECE251, Spring 2020 */

/* This program takes a program of max 100 lines of 32 bit integers and sorts them */

.data

.balign 4
msg1: .asciz "Enter the name of the input file: \n"

.balign 4
msg2: .asciz "Enter the name of the output file: \n"

.balign 4
scan_pattern: .asciz "%d"

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

	ldr r5, address_new_line
	ldrb r5, [r5]

	ldr r0, address_msg1
	bl printf



// sort array

// load numbers from array into output file

address_msg1:		.word msg1
address_msg2:		.word msg2
address_scan_pattern:	.word scan_pattern
address_new_line:	.word new_line
address_error_dne:	.word error_dne
address_error_length:	.word error_length
address_numbersin:	.word numbersin
address_numbersout:	.word numbersout
address_return: 	.word return
address_read:		.word read
address_write:		.word write


/* C-style functions */

.global printf
.global scanf
.global fopen
.global fclose
