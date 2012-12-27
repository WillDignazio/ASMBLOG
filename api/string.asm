; Will Dignazio <wdignazio@gmail.com>
; ASMBLOG 2012 
;
; String Manipulation Module

[section .data]

curdir db '.', 0
updir db '..', 0

[section .code]

; String Comparison
; Compares two strings for equivalence, returns 
; the comparison (0 for false, 1 for true) in the 
; rbx as the return value.
; ARGS: 
;   - rsi, Address of first string
;   - rdi, Address of second string
; RETURNS
;   - rbx, return value (0 for false, 1 for true)
strcmp: 
  push rax 
    
  pop rax

; String Length 
; Gets the length of the string whose address
; is placed in the rsi register. 
; ARGS: 
;   rsi - String to get length of
; RETURNS: 
;   rbx - Length of string
strlen: 
  push rax              ; Store return register 
  mov rax, 0            ; Make sure counter is zeroed
 .loop: 
  cmp byte[rsi+rax], 0  ; Compare only a bytes worth of data
  je .exit
  inc rax
  jmp .loop
 .exit:
  mov rbx, rax          ; rbx is the return value register
  pop rax
  ret
