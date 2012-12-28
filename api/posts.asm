; Will Dignazio <wdignazio@gmail.com> 
; ASMBLOG 2012 
; 
; Post directory and parsing routines. 

[section .bss]

postpathbuffer: resb 100

[section .data]

postprefix db 'posts/', 0
postfp dq 0

testpost db 'test.txt', 0

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
  mov rdi, postprefix         ; Load constant posts path
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
  jne .read                 ; If this passes, then the entry is most likely 
                            ; a valid post that needs to be served. 
 
  ; At this point, rdi contains the name 
  ; of the post within the directory. This will
  ; be used to encode the post, and serve it out to
  ; the reader.
  mov rax, stdout
  call FCGI_printf
  jmp .read

 .done:
  mov rdi, qword[postfp]
  call closedir
  pop rax
  ret

; Wipe Post Path Buffer 
; Wipes the post buffer to all zero's, 
; a necessity for multiple post paths.
zero_path_buffer: 
  push rax 
  mov rax, 0 
 .loop: 
  mov byte[postpathbuffer+rax], 0
  inc rax
  cmp rax, 100
  jne .loop
  pop rax
  ret

; Build Pathname 
; Given a name of a post, append the post/ path prefix 
; to it, and store then contents in the given buffer. 
; ARGS: 
;   - rdi, string of post name (in posts/ folder)
; USES: 
;   - rbx, rcx
buildpath:
  push rax
  call zero_path_buffer
  mov rax, 0                        ; Setup our incrementor
 
 .prefix:
  cmp byte[postprefix+rax], 0
  je .prefixdone
  mov rbx, 0
  mov bl, byte[postprefix+rax]
  mov byte[postpathbuffer+rax], bl
  inc rax
  jmp .prefix

 .prefixdone:                       ; The prefix has been setup
  mov rbx, 0
 .postfix:
  cmp byte[rdi+rbx], 0      
  je .postfixdone
  mov rcx, 0                       
  mov cl, byte[rdi+rbx]
  mov byte[postpathbuffer+rbx+rax], cl 
  inc rbx 
  jmp .postfix
 .postfixdone: 
  pop rax
  ret                               ; The buffer should be filled with the full path

; Serve A Single Post 
; Unlike it's counterpart, serve_posts, this function
; will serve a singular post based on some given path
; name in the rdi register. 
; ARGS: 
;   - rdi, entry name
; USES: 
;   - 
serve_post:
  push rax
   
  pop rax
