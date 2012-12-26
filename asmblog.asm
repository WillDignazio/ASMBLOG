; Will Dignazio <wdignazio@gmail.com>
; ASMBLOG 2012 
; 
; Main asmblog file, handles the front IO output and makes the 
; necessary syscalls to communicate with the fcgi handler. 

[BITS 64] 

%include "base.asm"
%include "report.asm"
%include "string.asm"
%include "html.asm"

[extern sbrk]

[global main]
[section .data] 

numout db '%p', 10, 0
strout db '%s', 0
err db 'Error', 10, 0

[section .code]

main: 
  
  push rbp              
  mov rbp, rsp          ; Save the base pointer 
  sub rsp, 16           ; Main loop two arguments argc, argv
  mov [rbp-4], edi      ; rsi 
  mov [rbp-16], rsi
  
  call initialize

  jmp .faccept          ; Main loop for asmblog, serves the 
                        ; data that the end user will get. 
 .fprint: 
  mov rdi, HEADER_HTML
  call serve_content_header

  call serve_header
  call nginxreport      ; Report details about nginx


 .faccept: 
  call FCGI_Accept
  test eax, eax         ; Test for 0
  jns .fprint           ; jns == Jump if condition is met

  mov rax, 60          ; Exit  Function
  mov rdi, 0           ; return status
  syscall
