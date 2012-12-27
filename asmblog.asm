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
%include "posts.asm"

[extern opendir]
[extern readdir]

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
  call serve_posts 
  ;mov rdi, qword[postfp]
  ;call readdir
  ;mov rdi, rax
  ;add rdi, 19
  ;call FCGI_printf

  ;mov rdi, qword[postfp]
  ;call readdir
  ;mov rdi, rax
  ;add rdi, 19
  ;call FCGI_printf

  ;mov rdi, rax
  ;add rdi, 19
  ;call FCGI_printf

  mov rdi, _fcgi_sF     ; I am honestly not sure why this needs to happen
  add rdi, 16           ; I believe FCGI has an interal stdout stream that 
                        ; has some funky initialization. I am pretty sure 
                        ; that _fcgi_sF is just a struct, and adding 16 
                        ; to is pointing to a certain property.

  mov rax, stdout       ; Just in case any data was left over
  call FCGI_fflush      ; flush it, it may not have has a newline.

 .faccept: 
  call FCGI_Accept
  test eax, eax         ; Test for 0
  jns .fprint           ; jns == Jump if condition is met

  mov rax, 60          ; Exit  Function
  mov rdi, 0           ; return status
  syscall
