CC= clang 
CFLAGS= -lfcgi
LD= ld 
LDFLAGS= -lfcgi
AS= nasm 
ASFLAGS= -f elf64

test: test.asm 
	$(AS) $(ASFLAGS) test.asm 
	$(CC) $(CFLAGS) -o test test.o

clean: 
	rm -f *.o 
	rm -f test
