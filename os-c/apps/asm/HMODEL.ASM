mov dx,$1f7
mov al,$ec
out dx,al
mov dx,$1f0
mov cx,32
l1:
in al,dx
loop l1
l2:
in al,dx
or al,al
jz l3
int $29
jmp l2
l3:
retf
