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
  mov rbx, 0
  mov rax, 0                ; Set out incrementor

 .cmploop:                  ; Main comparison loop
  mov dl, byte[rdi+rax]
  cmp byte[rsi+rax], dl
  jne .notequal             ; If at any point they are not 
                            ; equal, we're done here

  cmp byte[rsi+rax], 0      ; If equal, is zero?
  je .breakfirst 
  cmp byte[rdi+rax], 0      ; How about the other?
  je .breaksecond

  inc rax                   ; If neither are zero, increment.
  jmp .cmploop              

 .breakfirst:               ; If the first was equal to zero (EOS)
  cmp byte[rdi+rax], 0      ; Check the second for also being zero (EOS)
  jne .notequal
 .breaksecond:              ; Do the same in the opposite situation
  cmp byte[rsi+rax], 0
  jne .notequal

 .equal:                    ; If determined equal, passing until now
  mov rbx, 1                ; Set our return value to 1
 .notequal:                 ; Something was off, return 0, as set in beginning
  pop rax
  ret

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
