/* Alexa Jakob Program 3 ECE251, Spring 2020 */

/* This program takes an argument of max 4 operations and 4 operands on the command line, and performs the operations. All numbers must be 32-bit ints or floats. Allowed operations: +-*^/() */

.data

.balign 4
scan_pattern: .asciz "%c"

.balign 4
prompt: .asciz "Please enter the calculation: "

.balign 4
error_length: .asciz "ERROR: your operations are too long!\n"

.balign 4
error_char: .asciz "ERROR: you have used an unsupported character\n"

.balign 4
input: .skip 40

.balign 4
temp: .skip 50

.balign 4
queue: .skip 50

.balign 4
precedence: .asciz "011223445" 		// likely issue with how we assign precedence

.balign 4
separator: .asciz "n"

.balign 4
newline: .asciz "\n"

.balign 4
operators: .asciz "t*/+-^()&"

.balign 4
space: .asciz " "

.balign 4
output: .asciz "%.3f\n"

.balign 4
result: .skip 4 

.text

.global main


// load numbers from command line using argv, r1. if too long, exit with error code

main:
        push {r7, ip, lr}		// save lr, ip
	
	ldr r5, address_newline
	ldrb r5, [r5]

	ldr r0, address_prompt
	bl printf

	mov r6, #0

load_str:
	cmp r6, #40
	beq print_error_length

	ldr r0, address_scan_pattern
	ldr r1, address_input
	add r1, r1, r6
	bl scanf

	ldr r1, address_input
//	add r1, r1, r6
	ldrb r1, [r1, r6]
	cmp r1, r5			// if r1 is a new line
	beq following

	add r6, r6, #1
	b load_str


following:
	mov r10, #0			// iterator for input array
	mov r9, #0			// queue pointer
	mov r8, #0 			// operator pointer

	ldr r5, address_operators
	mov r1, #8
	ldrb r3, [r5, r1]		// end of the operators
	push {r3}			// push & onto stack

	ldr r4, address_queue
	ldr r2, address_precedence

	mov r1, #8
	ldrb r3, [r2, r1]		// r3 will be used to check for current element
					// potential issue
	mov r7, #0


outer:
	ldr r1, address_input
	ldrb r0, [r1, r10]		// load first element of input array
// potential problem w iterator
	cmp r10, r6			// if end of array, branch to end
	beq pop_stack


check_operator:
	add r8, r8, #1
	ldrb r1, [r5, r8]
	cmp r1, #0	
	beq continue			// if at end of operator array, continue

	ldrb r1, [r5, r8]
	cmp r0, r1
	bne check_operator		// if element of input array not equal to the operator, go back (and check until it is)

hit_operator:				// if they're equal, continue
	ldr r2, address_precedence
	ldrb r2, [r2, r8]
//	cmp r2, #51
//	beq open_parenthesis
	cmp r2, #52 
	beq close_parenthesis 
	cmp r2, r3 
	bgt cmp_current_stack

	ldrb r1, [r5, r8] 	
	push {r1} 			// push operator onto stack 
	add r10, r10, #1 
	ldr r2, address_precedence 
	ldrb r3, [r2, r8] 		// assign previous precedence to r3 
	mov r8, #0 
	b outer


close_parenthesis:			// pop operators from stack when reaching closed parenthesis, complying with rules of postfix notation
	pop {r1}
	cmp r1, #40			// is r1 (
	beq continue2			// if yes, continue


	strb r1, [r4, r9]		// store operator in r4
	add r9, r9, #1
	b close_parenthesis		// if you haven't hit the ( yet, continue popping

continue:
	ldr r1, address_input
	ldrb r0, [r1, r10]
	ldr r4, address_queue
 	strb r0, [r4, r9]

/* use atof to make this a float
//	sub r0, r0, #48
	ldr r0, address_input
	add r0, r0, r10
	bl atof
	vpush {d0}			// D0 IS CONSISTENTLY 0??
*/
	mov r7, r10
	add r7, r7, #1
	
	ldr r1, address_input
	ldrb r0, [r1, r7]
	cmp r0, #46
	beq no_separator		// check for . separating expression
	cmp r0, #47
	bgt no_separator

yes_separator:
	add r9, r9, #1
	ldr r2, address_separator
	ldrb r2, [r2]
	strb r2, [r4, r9]

no_separator:
	add r9, r9, #1
	add r10, r10, #1
	mov r8, #0
	b outer 			// start again to find new expression

continue2:
	add r10, r10, #1
	mov r8, #0
	b outer				// loop over the expression again

cmp_current_stack:			// if the current operator is of lower precedence
	pop {r1}
	mov r12, #0

loop:					// need to find value of popped item
	add r12, r12, #1
	ldrb r0, [r5, r12]
	cmp r1, r0			// compare operator to value from stack
	bne loop

continue4:
	ldr r0, address_precedence	// r12 has ptr to current precedence
	ldrb r0, [r0, r12]
	cmp r0, #38			// checks for & on stack
	beq next2

	cmp r0, r2			// what is r2?
	ble next1

next:
	ldrb r2, [r5, r8]
	push {r2}
	add r10, r10, #1
	ldr r2, address_precedence
	ldrb r3, [r2, r8]
	mov r8, #0
	b outer

next1:
	strb r1, [r4, r9]
	add r9, r9, #1
	b cmp_current_stack

next2:
	mov r1, #8
	ldrb r1, [r5, r1]	// push the & element onto stack
	push {r1}
	ldrb r2, [r5, r8]
	push {r2}		// push current element onto stack
	add r10, r10, #1
	ldr r2, address_precedence
	ldrb r3, [r2, r8]
	mov r8, #0
	b outer

pop_stack:
	pop {r1}
	cmp r1, #38		// compare to &
	beq postfix

//	ldr r4, address_temp
	strb r1, [r4, r9]	// THIS IS THE ISSUE - was overwriting operands
	add r9, r9, #1
	b pop_stack		// continue popping from stack until we reach &

	
postfix:
	ldr r5, address_operators
	mov r10, #8
	ldrb r10, [r5, r10]
	push {r10}		// push &
	mov r10, #0
	mov r7, #0

postfix_loop:
	cmp r10, r9
	beq end_program		// r9 stores size of postfix queue
	
	ldrb r1, [r4, r10]	// access operator
	cmp r1, #110		// separator 'n'
	beq push_float

	cmp r1, #46		// compare to '.'	
	beq next3

	cmp r1, #47		// compare to / operator: highest ascii operator except ^
	ble operate

	cmp r1, #94
	beq operate

next3:				
	ldr r2, address_temp
	strb r1, [r2, r7]
	add r7, r7, #1		// character = 1 byte
	add r10, r10, #1
	b postfix_loop

push_float:
	ldr r0, address_temp
	bl atof				// turn string into float
	vpush {d0}
	mov r7, #0
	add r10, r10, #1

clear_operation:
	ldr r0, address_temp
	ldr r2, =space
	ldrb r2, [r2]
	strb r2, [r0, r7]	// clear the temporary array
	add r7, r7, #1
	cmp r7, #50
	blt clear_operation

	b postfix_loop

operate:

	vpop {d3}
	vpop {d2}		// potentially problematic

	mov r12, #1		// for exponents

	cmp r1, #42		// if operation is *
	beq multiply

	cmp r1, #47		// if operation is /
	beq divide

	cmp r1, #43		// if operation is +
	beq add

	cmp r1, #45		// if operation is -
	beq subtract

	cmp r1, #94		// if operation is ^
	beq exponentiate

	b print_error_char

multiply:
	vmul.f64 d2, d3, d2
	vpush {d2}
	add r10, r10, #1
	b postfix_loop

subtract:
	vsub.f64 d2, d3, d2
	vpush {d2}
	add r10, r10, #1
	b postfix_loop

add:
	vadd.f64 d2, d3, d2
	vpush {d2}
	add r10, r10, #1
	b postfix_loop

divide:
	vdiv.f64 d2, d3, d2
	vpush {d2}
	add r10, r10, #1
	b postfix_loop

exponentiate:
//	vmov d12, r2
//	vmov d3, r3
	vmul.f64 d12, d3, d12	// an exponent is multiplying something by itself
	sub r2, r2, #1
	cmp r2, #0
	blt print_error_char

	cmp r2, #0
	bne exponentiate

//	vmov r12, d12
	vpush {d12}
	add r10, r10, #1
	b postfix_loop	



end_program: 			// problem in end_program
	vpop {d0}
	vmov r2, r3, d0

//	ldr r6, address_result
//	str r3, [r6]		// potentially problematic

	ldr r0, address_output
//	ldr r1, address_result
	bl printf		// this always prints 0.000
	pop {r1}		// clear remaining &

	pop {r7, ip, pc}

print_error_char:
	ldr r0, address_error_char
	bl printf
	mov r0, #0
	bl end_program

print_error_length:
	ldr r0, address_error_length
	bl printf
	mov r0, #0
	bl end_program



address_scan_pattern:	.word scan_pattern
address_error_length: 	.word error_length
address_error_char:	.word error_char
address_input:		.word input
address_newline:	.word newline
address_operators:	.word operators
address_queue: 		.word queue
address_precedence:	.word precedence
address_separator:	.word separator
address_temp:		.word temp
address_space:		.word space
address_output:		.word output
address_prompt:		.word prompt
address_result:		.word result

// C-style functions
.global printf
.global scanf
.global atof

