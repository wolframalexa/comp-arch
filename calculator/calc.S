/* Alexa Jakob Program 3 ECE251, Spring 2020 */

/* This program takes an argument of max 4 operations and 4 operands on the command line, and performs the operations. All numbers must be 32-bit ints or floats. Allowed operations: +-*^/() */

.data

.balign 4
scan_pattern: .asciz "%s"

.balign 4
error_length: .asciz "ERROR: your operations are too long!"

.balign 4
error_char: .asciz "ERROR: you have used an unsupported character"

.balign 4
input: .skip 40

.balign 4
newline: .asciz "\n"

string: .asciz "Argc: %d\n"
string2: .asciz "Argv: %s\n"

.text

.global main


// load numbers from command line using argv, r1. if too long, exit with error code

main:
        push {ip, lr}			// save lr, ip
	ldr r7, [r1, #4] 		// input string using argv

	mov r8, #0 			// iterator for loop
//	ldr r6, =r7			// address of the input string

	ldr r5, address_newline
	ldrb r5, [r5]

load_char:
	// take address of input string and input continually by 4, then load r1, [r1]

	ldr r0, address_scan_pattern
	ldr r1, address_input
	add r1, r1, r8
	bl scanf


	ldr r1, address_input
	add r1, r1, r8
	ldr r1, [r1]
//	cmp r1, r5
	cmp r8, #3			// TODO: code runs infinitely, I think this line is to blame
	beq postfix

	add r8, r8, #4			// increment
	bl load_char
	
postfix:
	mov r0, #0
        pop {ip, pc}




// transform expression into postfix notation: if find unfamiliar character, exit with error
// evaluate postfix expression
// exit and return r0

address_scan_pattern:	.word scan_pattern
address_error_length: 	.word error_length
address_error_char:	.word error_char
address_input:		.word input
address_newline:	.word newline

// C-style functions
.global printf
.global scanf
