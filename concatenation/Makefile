all: program1.out

program1.out: program1.S
	arm-linux-gnueabi-gcc $< -o $@ -static

clean:
	rm program1.out
