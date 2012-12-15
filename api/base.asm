; Will Dignazio 
; ASMBLOG 2012 
; 
; Base assembly API, defines base system call values, such as 
; the stdin, stdout, and stderr. 

[extern FCGI_Accept]
[extern FCGI_printf]
[extern printf]

%define stdin   0
%define stdout  1
%define stderr  2

                   ;EAX     EBX         ECX         EDX
%define SYS_nosys   0       ; 
%define SYS_exit    1       ;int  
%define SYS_fork    2       ;pt_regs
%define SYS_read    3       ;uint       |char*
%define SYS_write   4       ;uint       |const char *
%define SYS_open    5       ;const char*|int
%define SYS_close   6       ;uint       
