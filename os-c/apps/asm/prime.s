; ** prime.s

jmp .text

.proc:

.print_int:
 push ax
 push bx
 push cx
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
 pop cx
 pop bx
 pop ax
 ret

.text:

 mov ax,es
 mov ds,ax
 mov si,bx

 mov al,32
 int $29

 .parser:
 mov al,[si]
 or al,al
 jz .extract
 inc si
 jmp .parser

.extract:
 dec si
 mov al,[si]
 dec si
 xor ah,ah
 mov cx,1
 xor bx,bx

.extract_l1:
 cmp al,'0'
 jl .extract_l2
 cmp al,'9'
 jg .extract_l2
 sub al,48
 mul cx
 add bx,ax
 mov al,[si]
 xor ah,ah
 dec si
 mov dx,cx
 shl cx,3
 shl dx,1
 add cx,dx
 jmp .extract_l1

.extract_l2:
 mov ax,bx

 xor dx,dx
 cmp ax,2
 jl .end

 mov bx,2

.divide:
 mov cx,ax
 xor dx,dx
 div bx
 cmp dx,0
 jz .no_remainder
 mov ax,cx
 inc bx
 jmp .divide
.no_remainder:
 mov si,ax
 mov ax,bx
 call .print_int
 cmp ax,cx
 je .end
 mov al,'*'
 int $29
 mov ax,si
 jmp .divide

.end:
 retf
