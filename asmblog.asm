; Will Dignazio
; ASMBLOG 2012 
; 
; Main asmblog file, handles the front IO output and makes the 
; necessary syscalls to communicate with the fcgi handler. 

[BITS 64] 

%include "base.asm"
%include "report.asm"

[global main]
[section .data] 

[extern puts]
[extern testfunc]
[extern getenv]

data db 'Content-Type: text/plain',10, 10, 0
msg db 'Hello World!', 10, 0
msg2 db 'SYS Calls: %d, %d', 10, 0
outstr db '%d', 10, 0
envvar db 'SERVER_NAME'
len equ $-msg

[section .code]

main: 
  
  push rbp              
  mov rbp, rsp          ; Save the base pointer 
  sub rsp, 16           ; Main loop two arguments argc, argv
  mov [rbp-4], edi      ; rsi 
  mov [rbp-16], rsi
  jmp .faccept

 .fprint: 
  mov rdi, data         ; Load content to display
  mov rax, stdout       ; FCGI's stdout
  call FCGI_printf      

  mov rdi, msg
  mov rax, stdout
  call FCGI_printf

  ;mov edx, SYS_open
  ;mov rsi, SYS_write
  ;mov rdi, msg2
  ;mov rax, stdout
  ;call FCGI_printf

  ;mov rdi, envvar
  ;call getenv
  ;mov rdi, 10
  ;mov rsi, 20
  ;mov rdx, 30
  ;call testfunc

  ;mov edi, envvar
  ;call getenv
  ;mov rdi, rax
  ;mov rax, stdout
  ;call FCGI_printf
  ;mov rdi, msg
  ;mov rax, stdout 
  ;call FCGI_printf

  ;call testreport

 .faccept: 
  call FCGI_Accept
  test eax, eax         ; Test for 0
  jns .fprint

  ;mov rax, 60          ; Exit  Function
  ;mov rdi, 0           ; return status
  ;syscall
  mov eax, 0
  leave 
  ret

