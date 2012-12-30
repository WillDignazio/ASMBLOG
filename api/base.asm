;;This file is part of ASMBLOG.
;;
;;ASMBLOG is free software: you can redistribute it and/or modify
;;it under the terms of the GNU General Public License as published by
;;the Free Software Foundation, either version 3 of the License, or
;;(at your option) any later version.
;;
;;ASMBLOG is distributed in the hope that it will be useful,
;;but WITHOUT ANY WARRANTY; without even the implied warranty of
;;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;GNU General Public License for more details.
;;
;;You should have received a copy of the GNU General Public License
;;along with ASMBLOG.  If not, see <http://www.gnu.org/licenses/>

; Will Dignazio <wdignazio@gmail.com>
; ASMBLOG 2012 
; 
; Base assembly API, defines base system call values, such as 
; the stdin, stdout, and stderr. 

[extern FCGI_Accept]
[extern FCGI_printf]
[extern FCGI_fopen]
[extern FCGI_fgets]
[extern FCGI_fclose]
[extern FCGI_fflush]
[extern _fcgi_sF]

[extern opendir]
[extern closedir]
[extern readdir]
[extern printf]
[extern malloc]
[extern sbrk]

[section .bss] 

linebuffer: resb 500

[section .data] 

unifail db "Subroutine Failed", 10, 0
brkaddr dd 0

%define stdin   0
%define stdout  1
%define stderr  2

                   ;EAX     EBX         ECX         EDX
%define SYS_nosys   0       ; 
%define SYS_exit    1       ;int  
%define SYS_fork    2       ;pt_regs
%define SYS_read    3       ;uint       |char*
%define SYS_write   4       ;uint       |const char *
%define SYS_open    5       ;const char*|int
%define SYS_close   6       ;uint       
%define SYS_brk     12     

%define READ_WRITE readwriteflag
%define WRITE_ONLY writeflag
%define READ_ONLY readflag

%define HEADER_HTML content_header_text_html
%define HEADER_PLAIN content_header_text_plain
%define HEADER_CSS content_header_text_css

[section .code] 

[extern edata]  ; First address past end of data segment
[extern etext]  ; First address past end of test (code) segment
[extern end]    ; First address past end of uninitialized data segment

; Initialize AMBLOG
; Runs a series of routines to construct the proper 
; structures, and initialize the backend. 
initialize: 
  push rax
  mov rdi, 0            ; We need the program break point
  call sbrk             ; Retrieve it 
  mov [brkaddr], rax    ; Store it in a variable
  pop rax
  ret

; Gets the location of the program break interrupt point
;   USES: 
;       - rax (non-desctructive)
;       - rdi
;   RETURNS: 
;       - rsi: Convenient storing location for output
get_program_break: 
  push rax 
  mov rdi, 0
  call sbrk
  mov rsi, rax
  pop rax 
  ret

; Increment Break Point
;   USES: 
;       - rbx 
;   ARGS: 
;       - rdi: Increase by amount
incbreak: 
  push rax
  mov rbx, [brkaddr] 
  add rax, rbx
  mov rdi, rax
  mov rax, SYS_brk
  int 80h
  pop rax
  ret
