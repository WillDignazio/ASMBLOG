; Will Dignazio <wdignazio@gmail.com>
; ASMBLOG 2012 
; 
; Versioning and reporting subroutine module.

[extern getenv]



[section .data] 

NGINX_QUERY_STRING db 'QUERY_STRING', 0
NGINX_REQUEST_METHOD db 'REQUEST_METHOD', 0 
NGINX_CONTENT_TYPE db 'CONTENT_TYPE', 0
NGINX_CONTENT_LENGTH db 'CONTENT_LENGTH', 0 
NGINX_SCRIPT_NAME db 'SCRIPT_NAME', 0 
NGINX_REQUEST_URI db 'REQUEST_URI', 0
NGINX_DOCUMENT_URI db 'DOCUMENT_URI', 0
NGINX_SERVER_PROTOCOL db 'SERVER_PROTOCOL', 0
NGINX_GATEWAY_INTERFACE db 'GATEWAY_INTERFACE', 0
NGINX_SERVER_SOFTWARE db 'SERVER_SOFTWARE', 0
NGINX_REMOTE_ADDR db 'REMOTE_ADDR', 0
NGINX_REMOTE_PORT db 'REMOTE_PORT', 0
NGINX_SERVER_ADDR db 'SERVER_ADDR', 0 
NGINX_SERVER_PORT db 'SERVER_PORT', 0 
NGINX_SERVER_NAME db 'SERVER_NAME', 0

version db '0.0.1', 10, 0

outstub db '%s', 10, 0
report_header db 'ASMBLOG Version: %s', 10, 0
query db 'query_string', 10, 0

%macro nreport 1
    mov rdi, %1
    call getenv
    mov rsi, rax
    mov rdi, outstub
    mov rax, stdout
    call FCGI_printf
%endmacro

[section .code] 

nginxreport: 
  push rax              ; Save return point for later
 
  mov rsi, version 
  mov rdi, report_header
  mov rax, stdout
  call FCGI_printf      ; ASMBLOG report header

  ; Print recieved request method
  nreport NGINX_REQUEST_METHOD
  ; Print the script name, this is basically whatever 
  ; the extension after root is when the user navigates 
  ; to this application. 
  ; If this is forwarded from spawn-fcgi as the root 
  ; file, it will be labeled as index.fcgi
  nreport NGINX_SCRIPT_NAME 
  ; Print the remote request address
  nreport NGINX_REMOTE_ADDR
  ; Print the remote request port
  nreport NGINX_REMOTE_PORT
  ; Print this servers address 
  nreport NGINX_SERVER_ADDR
  ; Print this servers host port 
  nreport NGINX_SERVER_PORT
  ; Print the nginx version used to host this module
  nreport NGINX_SERVER_SOFTWARE
  ; Print Protocol this was served over 
  nreport NGINX_SERVER_PROTOCOL

  pop rax               ; Pop restored return value
  ret 

report:
  push rax
  mov rsi, version
  mov rdi, report_header
  call FCGI_printf
  pop rax
  ret