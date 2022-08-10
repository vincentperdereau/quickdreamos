; shot.s

jmp .entry

msg$:
.string "shot.txt"
.byte 0


.entry:
mov ax,$b800
mov ds,ax
mov si,0

mov ah,$12
mov bx,125  ; 125 = 80 * 25 / 16
int $44

mov es,ax   ; reserved segment
mov di,0
mov cx,2000

.loop:

mov al,[si]
.es
mov [di],al
add si,2
inc di

dec cx
jnz .loop

mov ax,cs
mov ds,ax
mov si,offset msg$
mov ah,3
int $44
.byte $66
mov dx,ax
.byte $66
xor cx,cx
mov cx,2000
mov ax,es
mov ds,ax
mov si,0
mov ah,5
int $44
mov ah,$13
mov bx,ds
int $44

retf


