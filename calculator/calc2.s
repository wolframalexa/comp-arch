.data

.balign 4
input: .asciz "2*(3+5)"

.balign 4
input_string: .skip 40

.balign 4
string: .asciz "%s\n"

.balign 4
string2: .asciz "%c\n"

.balign 4
null: .asciz "\0"

.balign 4
operators: .asciz "t*/+-()&"

.balign 4
precedence: .asciz "011223456"

.balign 4
separator: .asciz "n"

.balign 4
queue: .skip 50

.balign 4
output_string: .asciz "%.3f\n"

.balign 4
temp: .skip 50

.balign 4
char: .asciz "%c\n"

.balign 4
clear: .asciz " "

.text
.global main
.extern printf
main:
//line 44
        push {r7, ip, lr}
/*
        subs sp, sp, #4
        ldr r1, [r1, #4]
        str r1, [sp, #4]

        ldr r1, [sp, #4]
        ldr r0, =string
        bl printf

        mov r10, #0
        ldr r1, [sp, #4]
        ldrb r0, [r1, r10]
        mov r1, r0
        ldr r0, =string2
        bl printf
*/
        ldr r2, =input_string
        ldr r1, [r1, #4]
        str r1, [r2]
/*
        ldr r1, =input_string
        ldr r1, [r1]
        ldrb r1, [r1, #0]
        ldr r0, =string2
        bl printf
*/
        mov r10, #0                     //iterate through input array
        mov r9, #0                      //queue pointer
        mov r8, #0                      //operators pointer
        ldr r6, addr_of_null            //null character
        ldrb r6, [r6]                   //properly load null character in r6
        //mov r6, #10
        ldr r5, addr_of_operators
        mov r1, #7
        ldrb r3, [r5, r1]
        push {r3}                       //push onto stack so we know the end of the stack
        ldr r4, addr_of_queue
        ldr r2, addr_of_precedence
        mov r1, #7
        ldrb r3, [r2, r1]               //prep r3, which will be used to check for the current elemen$
        mov r7, #0
	outer:
        //add r7, r7, #1
        //mov r1, r7
        //ldr r0, addr_of_output_string
        //bl printf
        ldr r1, =input_string
        ldr r1, [r1]
        ldrb r0, [r1, r10]              //load element from array
        cmp r0, r6                      //if you reach the end of the string, branch to the end
        beq pop_stack

check_operator: //line 100
        add r8, r8, #1
        ldrb r1, [r5, r8]
        //ldr r0, addr_of_output_string
        //bl printf
        //ldrb r1, [r5, r8]
        cmp r1, r6
        beq continue                    //potential problem point
        ldrb r1, [r5, r8]               //remove this after debugging
        cmp r0, r1
        bne check_operator

hit_operator:
        ldr r2, addr_of_precedence
        ldrb r2, [r2, r8]
        //mov r1, #6
        //ldrb r0, [r2, r1]
        cmp r2, #51
        beq open_parentheses
        cmp r2, #52
        beq close_parentheses
        cmp r2, r3
        bgt cmp_current_stack                   //compare current element to the one on the stack
        ldrb r1, [r5, r8]
        push {r1}
        add r10, r10, #1
        ldr r2, addr_of_precedence
        ldrb r3, [r2, r8]               //assign previous precedence to r3
        mov r8, #0
        b outer
	close_parentheses:                      //pop elements from the stack if a close paranthesis is reach$
        //ldr r2, addr_of_precedence
        //mov r1, #5
        //ldrb r0, [r2, r1]
        pop {r1}
        cmp r1, #40
        beq continue2
        strb r1, [r4, r9]
        add r9, r9, #1
        b close_parentheses

continue:
        ldr r1, =input_string
        ldr r1, [r1]
        ldrb r0, [r1, r10]
        strb r0, [r4, r9]
        mov r7, r10
        add r7, r7, #1
        ldrb r0, [r1, r7]
        cmp r0, #46                     //checks for the "."
        beq no_separator
        cmp r0, #47
        bgt no_separator

separator_:
        add r9, r9, #1
        ldr r2, addr_of_separator
        ldrb r2, [r2]
        strb r2, [r4, r9]

no_separator:
        add r9, r9, #1
        add r10, r10, #1
        mov r8, #0
        b outer

continue2:
        add r10, r10, #1
        mov r8, #0
	b outer

cmp_current_stack:                              //if the current operator is of lower precedence, beg$
        pop {r1}
        mov r12, #0

loop:                                   //need to find the value of the popped item, in C I would hav$
        add r12, r12, #1
        ldrb r0, [r5, r12]
        cmp r1, r0
        bne loop

continue4:
        ldr r0, addr_of_precedence      //r12 now holds the pointer to the current precedence value o$
        ldrb r0, [r0, r12]
        cmp r0, #53                     //this checks for that & character on the stack
        beq next2
        cmp r0, r2
        ble next1

next:
        ldrb r2, [r5, r8]
        push {r2}
	add r10, r10, #1
        ldr r2, addr_of_precedence
        ldrb r3, [r2, r8]
        mov r8, #0
        b outer

next1:
        strb r1, [r4, r9]
        add r9, r9, #1
        b cmp_current_stack

next2:
        mov r1, #7
        ldrb r1, [r5, r1]               //repush the & element onto the stack
        push {r1}
        ldrb r2, [r5, r8]
        push {r2}                       //repush the current element onto the stack
        add r10, r10, #1
        ldr r2, addr_of_precedence
        ldrb r3, [r2, r8]
        mov r8, #0
        b outer
	pop_stack:
        pop {r1}
        cmp r1, #38
        beq reverse_polish
        strb r1, [r4, r9]
        add r9, r9, #1
        b pop_stack
/*
end2:
        mov r10, #0
        mov r5, r9

print_out_array:
        ldrb r1, [r4, r10]
        ldr r0, =char
        bl printf
        add r10, r10, #1
        cmp r10, r5
        blt print_out_array
*/
reverse_polish:
        ldr r5, addr_of_operators
        mov r10, #7
	ldrb r10, [r5, r10]             //repush the &
        push {r10}
        mov r10, #0
        mov r7, #0
//r9 still holds the size of the queue
//r4 still has addr_of_queue
//r5 still has the addr_of_operators
execute_rpn:
        cmp r10, r9                     //end if hit the end of the string
        beq end
        ldrb r1, [r4, r10]              //access element from the queue
        cmp r1, #110                    //hit the separator
        beq push_float
        cmp r1, #46
        beq next3
        cmp r1, #47                     //cmp to the / operator, which is the highest in ASCII
        ble execute_operation           //hit an operator
        //sub r1, r1, #48                       //convert to int
        //push {r1}
next3:
        ldr r2, addr_of_temp
        strb r1, [r2, r7]
        add r7, r7, #1
	add r10, r10, #1
        b execute_rpn

push_float:
        ldr r0, addr_of_temp
        bl atof
        vpush {d0}
        mov r7, #0
        add r10, r10, #1

clear_loop:
        ldr r0, addr_of_temp
        ldr r2, =clear
        ldrb r2, [r2]
        strb r2, [r0, r7]
        add r7, r7, #1
        cmp r7, #50
        blt clear_loop
        b execute_rpn

execute_operation:
        vpop {d2}                       //denominator
        //vmov r2, r3, d2
	//ldr r0, addr_of_output_string
        //bl printf
        vpop {d3}                       //numerator
        //vmov r2, r3, d3
        //ldr r0, addr_of_output_string
        //bl printf
        cmp r1, #42
        beq multiply
        cmp r1, #47
        beq divide
        cmp r1, #43
        beq add

subtract:
        vsub.f64 d2, d3, d2
        vpush {d2}
        add r10, r10, #1
        b execute_rpn

multiply:
        vmul.f64 d2, d3, d2
        vpush {d2}
        add r10, r10, #1
	b execute_rpn

divide:
        vdiv.f64 d2, d3, d2
        vpush {d2}
        add r10, r10, #1
        b execute_rpn
/*
        mov r0, #0

divide_loop:
        cmp r3, r2
        blt divide_end
        add r0, r0, #1
        sub r3, r3, r2
        b divide_loop

divide_end:
        push {r0}
        add r10, r10, #1
        b execute_rpn
*/
add:
vadd.f64 d2, d3, d2
        vpush {d2}
        add r10, r10, #1
        b execute_rpn

end:

/*
        mov r10, #0
        mov r5, r9

print_out_array:
        ldrb r1, [r4, r10]
        ldr r0, addr_of_output_string
        bl printf
        add r10, r10, #1
        cmp r10, r5
        blt print_out_array
*/
        vpop {d0}
        vmov r2, r3, d0
        ldr r0, addr_of_output_string
        bl printf
	pop {r1}                                //clear out the remaining & in the stack
/*
        pop {r1}
        ldr r0, addr_of_output_string
        bl printf

        pop {r1}
        ldr r0, addr_of_output_string
        bl printf
/*
        pop {r1}
        ldr r0, addr_of_output_string
        bl printf
*/

        pop {r7, ip, pc}


addr_of_input: .word input
addr_of_null: .word null
addr_of_operators: .word operators
addr_of_queue: .word queue
addr_of_output_string: .word output_string
addr_of_precedence: .word precedence
addr_of_separator: .word separator
addr_of_temp: .word temp
