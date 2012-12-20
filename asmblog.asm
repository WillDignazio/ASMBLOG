; Will Dignazio <wdignazio@gmail.com>
; ASMBLOG 2012 
; 
; Main asmblog file, handles the front IO output and makes the 
; necessary syscalls to communicate with the fcgi handler. 

[BITS 64] 

%include "base.asm"
%include "report.asm"
%include "string.asm"

[extern sbrk]

[global main]
[section .data] 

data db 'Content-Type: text/plain',10, 10, 0
numout db 'Length: %p', 10, 0
err db 'Error', 10, 0

[section .code]

main: 
  
  push rbp              
  mov rbp, rsp          ; Save the base pointer 
  sub rsp, 16           ; Main loop two arguments argc, argv
  mov [rbp-4], edi      ; rsi 
  mov [rbp-16], rsi
  
  call initialize
 
 .initialize: 
  mov rax, [brkaddr]    ; Move stored data address
  add rax, 100          ; Adding 100 Bytes to data segment
  mov rdi, rax          
  mov rax, 0x0C         ; BRK syscall
  int 80h               ; Call system
  cmp rax, -1
  je .suc
  mov rdi, err
  mov rax, stdout
  call FCGI_printf
 .suc:
 
  jmp .faccept          ; Main loop for asmblog, serves the 
                        ; data that the end user will get. 

 .fprint: 
  mov rdi, data         ; Load content to display
  mov rax, stdout       ; FCGI's stdout
  call FCGI_printf      

  call nginxreport      ; Report details about nginx

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
