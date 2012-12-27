; Will Dignazio <wdignazio@gmail.com> 
; ASMBLOG 2012 
; 
; Post directory and parsing routines. 

[section .data]

postpath db 'posts/', 0
postfp dq 0

[section .code]

; Serve Posts
; Serves the posts located in the posts/ directory, which 
; will be pushed out through the FCGI_printf call.
; USES:
;   - rdi
; ARGS: 
;   -
serve_posts: 
  push rax
  mov rdi, postpath
  call opendir
  mov qword[postfp], rax
 .read:
  mov rdi, qword[postfp]
  call readdir
  cmp rax, 0
  je .done
  mov rdi, rax
  add rdi, 19
  mov rax, stdout
  call FCGI_printf
  jmp .read
 .done:
  pop rax
  ret
