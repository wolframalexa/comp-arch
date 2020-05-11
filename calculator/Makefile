all: calc.out

calc.out: calc.S
	arm-linux-gnueabi-gcc -mfpu=vfp $< -o $@ -static -ggdb3
clean:
	rm calc.out
