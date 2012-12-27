; Will Dignazio <wdignazio@gmail.com>
; ASMBLOG 2012 
;
; String Manipulation Module

[section .data]

curdir db '.', 0
updir db '..', 0

[section .code]

; String Length 
; Parameters: 
;   rsi - String to get length of
; Returns: 
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
