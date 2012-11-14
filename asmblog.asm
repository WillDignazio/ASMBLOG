[BITS 64] 

[global main]
[extern FCGI_Accept]
[extern FCGI_printf]
[extern printf]

[section .data] 

data db 'Content-Type: text/plain',10, 10, 0
msg db 'Hello World!', 10, 0
len equ $-msg

[section .code]

main: 
  
  push rbp 
  mov rbp, rsp 
  sub rsp, 16
  mov [rbp-4], edi
  mov [rbp-16], rsi
  jmp .faccept

 .fprint: 
  mov rdi, data
  mov rax, 0
  call FCGI_printf
  mov rdi, msg
  mov rax, 0
  call FCGI_printf

 .faccept: 
  call FCGI_Accept
  test eax, eax     ; Test for 0
  jns .fprint

  ;mov rax, 60       ; Exit  Function
  ;mov rdi, 0        ; return status
  ;syscall
  mov eax, 0
  leave 
  ret

