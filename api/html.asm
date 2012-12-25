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

%define READ_WRITE readwriteflag
%define WRITE_ONLY writeflag
%define READ_ONLY readflag

%define HEADER_HTML content_header_text_html
%define HEADER_PLAIN content_header_text_plain
%define HEADER_CSS content_header_text_css

; Serve the Content Header String
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

; Serves header HTML file for ASMBLOG
; USES: 
;   - rax, rdi, rsi
; ARGS: 
;
serve_header: 
  push rax

  pop rax
  ret

[section .code]

