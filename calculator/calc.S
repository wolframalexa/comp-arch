/* Alexa Jakob Program 3 ECE251, Spring 2020 */

/* This program takes an argument of max 4 operations and 4 operands on the command line, and performs the operations. All numbers must be 32-bit ints or floats. Allowed operations: +-*^/() */

.data

.balign 4
scan_number: .asciz "%f" // we will treat all ints as floats

.balign 4
error_length: .asciz "ERROR: your operations are too long!"

.balign 4
error_char: .asciz "ERROR: you have used an unsupported character"

.balign 4
input: .skip 40

string: .asciz "Argc: %d\n"
string2: .asciz "Argv: %s\n"

.text

.global main


// load numbers from command line using argv, r1. if too long, exit with error code

main:
        push {ip, lr}
	mov r7, r1 		// ptr to input string
        mov r1, r0
        ldr r0, =string
        bl printf		// prin

	ldr r1, [r7, #4]
	ldr r0, =string2
	bl printf

        pop {ip, pc}




// transform expression into postfix notation: if find unfamiliar character, exit with error
// evaluate postfix expression
// exit and return r0


address_scan_number: 	.word scan_number
address_error_length: 	.word error_length
address_error_char:	.word error_char
address_input:		.word input

// C-style functions
.global printf
