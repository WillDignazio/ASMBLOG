[BITS 64] 

[global main]
[extern FCGI_Accept]
[extern FCGI_printf]
[extern printf]

[section .data] 

data db 'Content-Type: text/plain',10, 10, 0
msg db 'Hello World!', 10, 0
counter db '%d', 10, 0
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
  mov rdi, data
  mov rax, 0
  call FCGI_printf
  mov rdi, msg
  mov rax, 0
  call FCGI_printf

  mov rcx, 0
 .loop:
  inc rcx
  mov rdi, counter
  call FCGI_printf
  test rcx, 100
  jns .loop

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

