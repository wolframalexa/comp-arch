.data

.balign 4
file: .asciz "test.txt"

.balign 4
output_file: .asciz "output.txt"

.balign 4
mode: .asciz "r"

.balign 4
mode2: .asciz "w"

.balign 4
scan_pattern: .asciz "%d"

.balign 4
output_pattern: .asciz "%d\n"
//line 20

.balign 4
myArr: .skip 400


.text

.global main
.global fopen
.global fscanf

//setup registers, open the input file
main:
	push {r7, lr}				//save lr
	subs sp, sp, #4				//free up space on stack
	ldr r0, addr_of_file			//store address of file into r0, prep fopen
	ldr r1, addr_of_mode			//store address of file mode into r1, prep fopen
	bl fopen				//call fopen
	str r0, [sp]				//FILE ptr is now in r0, save value in stack
	ldr r10, addr_of_myArr
	mov r4, #0				//r4 will be the iteration counter for the upcoming loop

//loop through the input file, reading in ints and storing them into myArr
loop:
	ldr r0, [sp]				//load stack pointer, prep for fscanf
        ldr r1, addr_of_scan_pattern		//load appropriate address
	add r2, r10, r4
	bl fscanf				//call fscanf
	ldr r0, [sp]				//load in current fscanf result
	add r4, r4, #4
	bl feof
	cmp r0, #0				//check for end of file
	beq loop				//repeat loop if not end of file

//cleanup, preparation for sorting
next:
	sub r4, r4, #4				//account for the final iteration of the loop to find the EOF
	mov r5, #0				//i
	sub r8, r4, #4 				//n-1

//sort the ints by bubbleSort
outer:
	cmp r5, r8				//compare i with  n-1
	beq end					//if i = n-1, branch out
	mov r6, r10				//copy addr_of_myArr into r6;
	sub r9, r8, r5				//r9 = (n-1) - i
	add r9, r9, r10				//r9 = myArr[n-1-i]

inner:
	cmp r6, r9				//compare &myArr[j] to &myArr[(n-1) - i], branch out if equal
	beq nextI				//branch to incrementer for i
	ldr r2, [r6]				//myArr[j]
	add r1, r6, #4				//&myArr[j+1]
	ldr r3, [r1]				//r3 = myArr[j+1]
	cmp r2, r3				//if myArr[j] <= myArr[j+1] (elements in proper order)
	ble nextJ				//continue
	str r2, [r1]				//else, perform swap
	str r3, [r6]

nextJ:
	add r6, r6, #4				//increment j
	b inner					//loop to inner

nextI:
	add r5, r5, #4				//increment i
	b outer					//loop to outer

end:
	mov r5, #0				//reset r5
	ldr r0, addr_of_output_file		//need to open file to write to
	ldr r1, addr_of_mode2			//load in "w" instead of "r" to write
	bl fopen				//call fopen
	str r0, [sp]
	ldr r6, addr_of_myArr

//print out the sorted array
loop1:
	ldr r0, [sp]
	ldr r1, addr_of_output_pattern		//prep fprintf
	add r2, r6, r5				//increment address
	ldr r2, [r2]				//load value from address
	bl fprintf				//call fprintf
	add r5, r5, #4				//increment
	cmp r5, r4				//compare to total length of array
	bne loop1				//if elements left to print, branch again

//exit the file
	adds sp, sp, #4				//restore stack pointer
	pop {r7, lr}				//retore lr
	bx lr					//exit program

addr_of_file: .word file
addr_of_mode: .word mode
addr_of_mode2: .word mode2
addr_of_scan_pattern: .word scan_pattern
addr_of_myArr: .word myArr
addr_of_output_pattern: .word output_pattern
addr_of_output_file: .word output_file
