/*Alexa Jakob Program 1 ECE251, Spring 2020 */

/* This program concatenates two user-given strings in Assembly*/

.data

string1:
	.word 11 /* strings are null-terminated so we add 1 to length*/
string2:
	.word 11


.text
.global main

main:
/* load the strings as character arrays into registers r10 and r11 */
	
/* check if the strings exceed 10 characters: 0 must occur in the first 11 characters */
	
	mov r1, #0 /* stores position in array */	
	loop_str1:
		mul r9, r1, #8 
		add r12, r10, r9 /* r12 stores the address of the next char*/
		ldr r12, [r12, #0]
		cbz r12, valid	/* if the char is 0, it is finished, jump to valid */
		addi r1, #1
		sub r2, r1, #11
		cbz r2, invalid_str1
		b loop_str1
	/* at the end of this loop, r1 stores the length of string1 */

	valid: /* continue and check if string2 is valid*/


	invalid_str1:
		mov r0, #21
		bx lr

	/* get the length of strings */
	
