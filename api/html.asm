; Will Dignazio
; HTML Control Module 
; ASMBLOG 2012

[BITS 64]

[section .data] 

content_header_text_css db 'Content-Type: text/css', 10, 10, 0
content_header_text_plain db 'Content-Type: text/plain', 10, 10, 0
content_header_text_html db 'Content-Type: text/html', 10, 10, 0

html_tag db '<html>', 0
html_end_tab db '</html>', 0
writeflag db 'w', 0
readflag db 'r', 0
readwriteflag db 'rw', 0

header_html_file db 'html/header.html', 0   ; HTML file path
headerfp dq 0                               ; HTML file handler field


[section .code]

; Serve the content header string, and allow for 
; content header to be passed in through the rax 
; register.
;
; USES: 
;   - rax, rdi
; ARGS: 
;   - rdi
serve_content_header: 
  push rax 
  mov rax, stdout           ; The usual fcgi standard output
  call FCGI_printf          ; rdi should be set at this point
  pop rax
  ret

; Serves header HTML file for ASMBLOG, this 
; is another example of cheating by not using
; syscalls, and will have to be changed in the 
; future. I am not sure of the repercussions 
; however; FCGI functionality seems to be written
; specifically for this kind of thing. It might be 
; because they have extra routines to check for 
; potential malicious code.
;
; USES: 
;   - rax, rdi, rsi, rdx
; ARGS: 
;   -
serve_header: 
  push rax
  mov rdi, header_html_file
  mov rsi, READ_ONLY
  call FCGI_fopen
  mov qword[headerfp], rax
 .read:
  mov rdx, qword[headerfp]  ; Initialized during the base.asm's initialize call
  mov rdi, linebuffer       ; TODO: make dynamically allocated so not 500B max
  mov rsi, 500              ; Pull up to 500 bytes from line
  call FCGI_fgets
  cmp rax, 0                ; Compare the pulled line with the end of file
  je .done      
  mov rsi, linebuffer       ; Point to beginning of line
  mov rdi, strout           ; Prep a container for printf
  mov rax, stdout           ; Set standard output
  call FCGI_printf          
  jmp .read
 .done:
  mov rdi, qword[headerfp]
  call FCGI_fclose
  pop rax
  ret
