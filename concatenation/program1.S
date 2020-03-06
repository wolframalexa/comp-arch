/*Alexa Jakob Program 1 ECE251, Spring 2020 */

/* This program concatenates two user-given strings in Assembly*/

.data

.balign 4
msg1: .asciz "Enter the first string: \n"

.balign 4
msg2: .asciz "Enter the second string: \n"

.balign 4
scan_pattern: .asciz "%c"

.balign 4
new_line: .asciz "\n" /* strings are \n terminated, use this to detect end*/

.balign 4
printf_msg: .asciz "Here is your concatenated string: %s"

.balign 4
error: .asciz "An error has occurred: your string is too long.\n"

.balign 4
string1: .skip 11  /* every string is actually an array of chars, which are 1 byte each */

.balign 4
string2: .skip 11 /* I assume "10 characters" plus null-termination */

.balign 4
result: .skip 22

.balign 4
return: .word 0

.text
.global main

main:
	ldr r1, address_of_return
	str lr, [r1]

	ldr r5, address_of_new_line	// will compare to r5 to find end
	ldrb r5, [r5]

	ldr r0, address_of_scanf_msg1	// prompt user for string1
	bl printf

	mov r6, #0 			// iterator for 1st str, will store length
	mov r7, #0 			// iterator for 2nd str 

load1: 					// load the first string and check if it is <10 chars
	cmp r6, #11
	beq invalid_str1

	ldr r0, address_of_scan_pattern	// scan the string char by char
	ldr r1, address_of_string1
	add r1, r1, r6
	bl scanf

	ldr r1, address_of_string1
	add r1, r1, r6
	ldrb r1, [r1]
	cmp r1, r5			// if char = \n, it is valid. check string 2
	beq valid1

	add r6, r6, #1
	b load1

valid1:
	ldr r0, address_of_scanf_msg2	// prompt user for string2
	bl printf

load2:
	cmp r7, #11
	beq invalid_str2		// if string > 11 chars w/ \n, invalid

	ldr r0, address_of_scan_pattern
	ldr r1, address_of_string2
	add r1, r1, r7
	bl scanf			// scan char by char

	ldr r1, address_of_string2
	add r1, r1, r7			// increment string length
	ldrb r1, [r1]
	cmp r1, r5			// if char = \n, it is valid: continute to concatenation
	beq valid2

	add r7, r7, #1
	b load2

invalid_str1: 				// if string1 is invalid, exit
	ldr r0, address_of_error
	bl printf			// print error message
	mov r0, #21			// return error code

	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr

invalid_str2: 				// if string2 is invalid, exit
	ldr r0, address_of_error
	bl printf			// print error message
	mov r0, #22			// return error code

	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr

valid2:				// load addresses of final string and string1 in preparation for concatenation
	mov r9, #0		// r9 is an iterator storing the position of the char in str1
	ldr r1, address_of_result
	ldr r3, address_of_string1

concatenate1:			// copy string1 char by char to the new array, r1
	ldrb r2, [r3, r9]	// take char from str1 and copy to result
	strb r2, [r1, r9]
	cmp r6, r9		// if at end of str1, go to str2
	beq continue
	add r9, r9, #1
	b concatenate1

continue:			// load addresses of result and str2 in preparation to concatenate
	mov r9, #0		// reset iterator: r9 stores pos of char in str2
	add r0, r6, #0		// iterator r0 stores pos of char in result
	ldr r1, address_of_result
	ldr r3, address_of_string2

concatenate2:			// copy string2 char by char to same array r1
	ldrb r2, [r3, r9]
	strb r2, [r1, r0]
	add r0, r0, #1
	cmp r9, r7		// if at end of str2, go to end
	beq end
	add r9, r9, #1
	b concatenate2

end:
	ldr r0, address_of_printf_msg // print results
	ldr r1, address_of_result
	bl printf

	add r0, r6, r7			// return code: length of result
	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr

// addresses of variables
address_of_printf_msg: 		.word printf_msg
address_of_scanf_msg1: 		.word msg1
address_of_scanf_msg2: 		.word msg2
address_of_scan_pattern:	.word scan_pattern
address_of_string1: 		.word string1
address_of_string2: 		.word string2
address_of_return: 		.word return
address_of_error: 		.word error
address_of_result:		.word result
address_of_new_line:		.word new_line

/* External */
.global printf
.global scanf
