; ** mmap.s

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

.adr:
 .string "segment:"
 .byte 0
.size:
 .string "size:"
 .byte 0
.owner:
 .string "owner:"
 .byte 0

.entry:

 mov al,13
 int $29
 mov al,10
 int $29

 mov ah,3
 mov bh,0
 int $10

 mov ah,2
 mov bh,0
 mov dl,4
 int $10

 mov si,offset .adr
 mov ah,$10
 int $44

 mov ah,2
 mov bh,0
 mov dl,20
 int $10

 mov si,offset .size
 mov ah,$10
 int $44

 mov ah,2
 mov bh,0
 mov dl,40
 int $10

 mov si,offset .owner
 mov ah,$10
 int $44

 mov al,13
 int $29
 mov al,10
 int $29


 mov ax,$2000
 mov es,ax
 mov bx,0

.loop:
 mov bx,0
 .es
 mov al,[bx]
 cmp al,'V'
 je .mcb
 cmp al,'P'
 je .mcb
.l:
 mov bx,1
 .es
 mov cx,[bx]
 mov ax,es
 add ax,cx
 inc ax
 mov es,ax
 jmp .loop

.mcb:

 mov ah,3
 mov bh,0
 int $10

 mov ah,2
 mov bh,0
 mov dl,4
 int $10

 mov ax,es
 inc ax
 call .print_hex_word

 mov ah,2
 mov dl,20
 int $10

 mov bx,1
 .es
 mov ax,[bx]
 shl ax,4
 call .print_int

 mov ah,2
 mov bh,0
 mov dl,40
 int $10

 mov ax,es
 mov ds,ax
 mov si,3
 mov ah,$10
 int $44

 mov al,13
 int $29
 mov al,10
 int $29

 mov ax,cs
 mov ds,ax

 mov bx,0
 .es
 mov al,[bx]
 cmp al,'P'
 je .stop
 jmp .l

.stop:
 retf
