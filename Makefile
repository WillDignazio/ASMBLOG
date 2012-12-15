CC= clang  -ggdb 
CFLAGS= -lfcgi
LD= ld 
LDFLAGS= -lfcgi
AS= nasm 
ASFLAGS= -f elf64 -ggdb -Iapi/
PID=`cat ./spawn.pid`

test: asmblog.asm 
	$(AS) $(ASFLAGS) asmblog.asm 
	$(CC) $(CFLAGS) -c test.c
	$(CC) $(CFLAGS) -o asmblog asmblog.o test.o

spawn: test
	spawn-fcgi -a127.0.0.1 -p9000 -P./spawn.pid asmblog
kill-spawn: 
	kill ${PID}
	rm -f ./spawn.pid

clean: 
	rm -f *.o 
	rm -f asmblog
