/*Alexa Jakob Program 1 ECE251, Spring 2020 */

/* This program concatenates two user-given strings in Assembly*/

.data

.balign 4
scanf_msg1: .asciz "Enter the first string: "

.balign 4
scanf_msg2: .asciz "Enter the second string: "

.balign 4
scan_pattern: .asciz "%s"

.balign 4
printf_msg: .asciz "Here is your concatenated string: %s\n"

.balign 4
string1: .word 10  /* every string is actually an array of chars, which are 1 byte */

.balign 4
string2: .word 10 /* I assume "10 characters" includes null-termination */

.balign 4
return: .word 0

.text
.global main

main:
/* load the strings as character arrays into registers r10 and r11 */
	ldr r1, address_of_return
	str lr, [r1]

	ldr r0, address_of_scanf_msg1
	bl printf

	ldr r0, address_of_scan_pattern
	ldr r1, address_of_string1
	bl scanf

	ldr r0, address_of_printf_msg
	ldr r1, address_of_string1
	ldr r1, [r1]
	bl printf

	ldr r0, address_of_string1
	ldr r0, [r0]

	ldr lr, address_of_return
	ldr lr, [lr]
	bx lr

address_of_printf_msg: .word printf_msg
address_of_scanf_msg1: .word scanf_msg1
address_of_scanf_msg2: .word scanf_msg2
address_of_scan_pattern: .word scan_pattern
address_of_string1: .word string1
address_of_string2: .word string2
address_of_return: .word return

/* External */
.global printf
.global scanf







/*	
/* check if the strings exceed 10 characters: 0 must occur in the first 11 characters */
	
	mov r1, #0 /* stores position in array */	
	loop_str1:
		mov r9, #8
		mul r9, r1, r9 
		add r12, r10, r9 /* r12 stores the address of the next char*/
		ldr r12, [r12, #0]
		cmp r12,#0
		beq valid1	/* if the char is 0, it is finished, jump to valid */

		add r1, #1
		subs r2, r1, #11
		bne loop_str1 /* if we've reached the end and not found a 0, invalid str */

		b invalid_str1

	/* at the end of this loop, r1 stores the length of string1 */

	valid1: /* continue and check if string2 is valid*/
		mov r2, #0
		loop_str2:
			mov r9, #8
			mul r9, r2, r9
			add r12, r11, r9
			ldr r12, [r12, #0]
			cmp r12, #0
			beq valid2 /* if the char is 0 the str is valid*/

			add r2, #1
			subs r2, r1, #11
			bne loop_str2 /* if at end and haven't found 0, invalid */
			b invalid_str2
	invalid_str1:
		mov r0, #21
		bx lr

	invalid_str2:
		mov r0, #22
		bx lr
	valid2:
/*now copy these strings byte by byte to a new array to concatenate */
		mov r0, #0
		bx lr
