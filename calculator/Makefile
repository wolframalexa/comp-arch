all: calc.out

calc.out: calc.S
	arm-linux-gnueabi-gcc -mfpu=vfp $< -o $@ -static
clean:
	rm calc.out
