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
new_line: .asciz "\n" /* new line character finishes every string*/

.balign 4
printf_msg: .asciz "Here is your concatenated string: %s\n"

.balign 4
error: .asciz "An error has occurred.\n"

.balign 4
string1: .skip 12  /* every string is actually an array of chars, which are 1 byte */

.balign 4
string2: .skip 12 /* I assume "10 characters" plus null-termination */

.balign 4
result: .skip 24

.balign 4
return: .word 0

.text
.global main

main:
/* load the strings as character arrays into registers r1 and r2 */
	ldr r1, address_of_return
	str lr, [r1]

	ldr r5, address_of_new_line
	ldrb r5, [r5]

	ldr r0, address_of_scanf_msg1
	bl printf

	mov r6, #0 /* iterator for 1st str */
	mov r7, #0 /* iterator for 2nd str */

load1: /* load the first string and check if it is <10 char */
	cmp r6, #11
	beq invalid_str1

	ldr r0, address_of_scan_pattern
	ldr r1, address_of_string1
	add r1, r1, r6
	bl scanf

	ldr r1, address_of_string1
	add r1, r1, r6
	ldrb r1, [r1]
	cmp r1, r5
	beq valid1

	add r6, r6, #1
	b load1

valid1:
	ldr r0, address_of_scanf_msg2
	bl printf

load2:
	cmp r7, #11
	beq invalid_str2

	ldr r0, address_of_scan_pattern
	ldr r1, address_of_string2
	add r1, r1, r7
	bl scanf

	ldr r1, address_of_string2
	add r1, r1, r7
	ldrb r1, [r1]
	cmp r1, r5
	beq valid2

	add r7, r7, #1
	b load2

invalid_str1: 			// if string1 is invalid, exit
	ldr r0, address_of_error
	bl printf
	mov r0, #21

	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr

invalid_str2: 			// if string2 is invalid, exit
	ldr r0, address_of_error
	mov r0, #22

	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr

valid2:				// copy byte by byte to a new array
	mov r9, #0
	ldr r1, address_of_result
	ldr r3, address_of_string1

concatenate1:
	ldrb r2, [r3, r9]
	strb r2, [r1, r9]
	cmp r6, r9
	beq continue
	add r9, r9, #1
	b concatenate1

continue:
	mov r9, #0
	add r0, r6, #0
	ldr r1, address_of_result
	ldr r3, address_of_string2

concatenate2:
	ldrb r2, [r3, r9]
	strb r2, [r1, r9]
	cmp r7, r9
	beq end
	add r9, r9, #1

end:
	ldr r0, address_of_printf_msg
	ldr r1, address_of_return
	bl printf

	add r0, r6, r7
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
.global string
