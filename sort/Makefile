all: program2.out

program2.out: program2.S
	arm-linux-gnueabi-gcc $< -o $@ -static

clean:
	rm program2.out
