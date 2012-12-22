; Will Dignazio
; HTML Control Module 
; ASMBLOG 2012

[BITS 64]

[section .data] 

content_header_text_plain db 'Content-Type: text/plain', 10, 10, 0
content_header_text_html db 'Contetn-Type: text/html', 10, 10, 0
html_tag db '<html>', 0

[section .code]

