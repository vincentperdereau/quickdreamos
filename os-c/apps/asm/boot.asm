; ** bootsector

jmp start

writestr:
mov ah,$e
.l1:
mov al,[si]
or al,al
jz .l2
int $10
inc si
jmp .l1
.l2:
ret

msg:
.string "Hello World!"
.byte 0

start:

 mov ax,$7c0
 mov ds,ax
 mov es,ax
 mov si,offset msg
 call writestr

 .inf:
 jmp .inf

.org 510
.word $aa55
