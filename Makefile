CC= clang 
CFLAGS= -lfcgi
LD= ld 
LDFLAGS= -lfcgi
AS= nasm 
ASFLAGS= -f elf64

test: asmblog.asm 
	$(AS) $(ASFLAGS) asmblog.asm 
	$(CC) $(CFLAGS) -o asmblog asmblog.o

clean: 
	rm -f *.o 
	rm -f asmblog
