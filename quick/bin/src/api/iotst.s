; ** iotst.s
; ** simple example of I/O functions

jmp .entry

.msg2:         ; msg2
 .word $0a0d   ; CR/LF
 .string "you typed: "

.str:          ; str ( buffer )
 .array 20 0   ; array of 20 bytes

.msg1:         ; msg1
 .word $0a0d   ; CR/LF Carriage Return / Line Feed
 .string "write a text: "
 .byte 0       ; ASCIIZ = last character must be Zero

.entry:

 mov ax,cs    ; ** all segments equals (tiny prg)
 mov ds,ax    ; ** CS=DS=ES
 mov es,ax

 mov ah,$10      ; ** function x10: write a string
 mov si,offset .msg1 ; ** DS:SI = pointer to buffer
 int $44       ; ** call dream.Kernel (int x44)

 mov ah,$11    ; ** function x11: read a string
 mov bx,offset .str ; ** ES:BX = pointer to buffer
 mov cx,19 ; ** characters count ( 20th = 0 ASCIIZ )
 int $44 ; ** call dream.Kernel

 mov ah,$10
 mov si,offset .msg2 ; ( msg2 + str )
 int $44

 retf   ; ** return to caller
