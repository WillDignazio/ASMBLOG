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
  mov rdi, postpath         ; Load constant posts path
                            ; TODO: make a settable directory
  call opendir              ; Set the directory file handler
  mov qword[postfp], rax

 .read:                     ; Read the directory contents
  mov rdi, qword[postfp]
  call readdir
  cmp rax, 0                ; Done reading contents
  je .done
  mov rdi, rax
  add rdi, 19               ; Name of entry pointer in directory entry struct
  mov rsi, curdir
  call strcmp               ; Compare for useless entries ('.', '..')
  cmp rbx, 0
  jne .read
  mov rsi, updir
  call strcmp
  cmp rbx, 0
  jne .read

  mov rax, stdout
  call FCGI_printf
  jmp .read

 .done:
  mov rdi, qword[postfp]
  call closedir
  pop rax
  ret
