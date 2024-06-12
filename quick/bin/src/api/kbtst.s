; ** kbtst.s
; ** simple example of I/O functions

jmp .entry

.hex_map:
 .byte '0'
 .byte '1'
 .byte '2'
 .byte '3'
 .byte '4'
 .byte '5'
 .byte '6'
 .byte '7'
 .byte '8'
 .byte '9'
 .byte 'A'
 .byte 'B'
 .byte 'C'
 .byte 'D'
 .byte 'E'
 .byte 'F'

.print_hex_byte:
 push ax
 push bx
 push cx
 mov cl,al
 shr al,4
 xor ah,ah
 mov bx,offset .hex_map
 add bx,ax
 mov al,[bx]
 int $29
 mov al,cl
 and al,$f
 mov bx,offset .hex_map
 add bx,ax
 mov al,[bx]
 int $29
 pop cx
 pop bx
 pop ax
 ret

.print_hex_word:
 xchg ah,al
 call .print_hex_byte
 xchg ah,al
 call .print_hex_byte
 ret

.print_int:
 push ax   
 push bx   
 push cx   
 push dx
 mov bx,10
 xor cx,cx
.print_int_l1:
 xor dx,dx
 div bx
 push dx
 inc cx
 or ax,ax
 jnz .print_int_l1
.print_int_l2:
 pop ax
 add al,'0'
 int $29
 loop .print_int_l2
 pop dx
 pop cx
 pop bx
 pop ax
 ret


.msg2:         ; msg2
 .word $0a0d   ; CR/LF
 .string "keycode : "

.msg1:         ; msg1
 .word $0a0d   ; CR/LF Carriage Return / Line Feed
 .string "waiting for getch() return : "
 .byte 0       ; ASCIIZ = last character must be Zero

.entry:

 mov ax,cs    ; ** all segments equals (tiny prg)
 mov ds,ax    ; ** CS=DS=ES
 mov es,ax

 mov ah,$10      ; ** function x10: write a string
 mov si,offset .msg1 ; ** DS:SI = pointer to buffer
 int $44       ; ** call dream.Kernel (int x44)

.loop2:

 mov ah,$18    ; ** function x11: read a key
 int $44 ; ** call dream.Kernel
 mov bx,ax

 mov ah,$10
 mov si,offset .msg2 ; ( msg2 + str )
 int $44

 mov ax, bx
 call .print_hex_word

 jmp .loop2 


 retf   ; ** return to caller
