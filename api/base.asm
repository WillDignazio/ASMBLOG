; Will Dignazio <wdignazio@gmail.com>
; ASMBLOG 2012 
; 
; Base assembly API, defines base system call values, such as 
; the stdin, stdout, and stderr. 

[extern FCGI_Accept]
[extern FCGI_printf]
[extern FCGI_fopen]
[extern printf]

[section .data] 

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

; Increment data segment
;   USES: 
;       - rbx (non-destructive)
;   ARGS: 
;       - rax: Increase by amount
incdata: 
  push rax
  mov rbx, [brkaddr] 
  push rbx
  add rbx, rax
  mov rdi, rbx
  mov rax, SYS_brk
  int 80h
  pop rbx
  pop rax
  ret
