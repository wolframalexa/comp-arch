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
input: .skip 9 // set of paragraphs = 1 operation, so max 1/calc

.balign 4                                                                                                                                                                                                       .balign 4                                                                                                                                                                                                       .balign 4

.balign 4

.text

.global main


// load numbers from command line using argv, r1. if too long, exit with error code

main:

// transform expression into postfix notation: if find unfamiliar character, exit with error
// evaluate postfix expression
// exit and return r0
