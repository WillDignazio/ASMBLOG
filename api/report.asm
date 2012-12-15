; Will Dignazio
; ASMBLOG 2012 
; 
; Versioning and reporting subroutine module.

[extern FCGI_printf]
%include "base.asm"

%define NGINX_QUERY_STRING 'query_string'
%define NGINX_REQUEST_METHOD 'request_method' 
%define NGINX_CONTENT_TYPE 'content_type'
%define NGINX_CONTENT_LENGTH 'content_length' 
%define NGINX_SCRIPT_NAME 'fastcgi_script_name' 
%define NGINX_REQUEST_URI 'request_uri'
%define NGINX_DOCUMENT_URI 'document_uri'
%define NGINX_SERVER_PROTOCOL 'server_protocol'
%define NGINX_GATEWAY_INTERFACE 'CGI/1.1'
%define NGINX_SERVER_SOFTWARE 'nginx/'
%define NGINX_VERSION 'nginx_version'
%define NGINX_REMOTE_ADDR 'remote_addr'
%define NGINX_REMOTE_PORT 'remote_port'
%define NGINX_SERVER_ADDR 'server_addr' 
%define NGINX_SERVER_PORT 'server_port' 
%define NGINX_SERVER_NAME 'server_name'

%define report_header 'ASMBLOG Version: %s'

[section .data] 

version db "0.0.1", 10, 0

[section .code] 

testreport: 
  mov rdi, version
  mov rax, stdout
  call FCGI_printf 
  ret 

report:
  mov rsi, version
  mov rdi, report_header
  call FCGI_printf
  ret
