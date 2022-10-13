asm {
  push ax
  push bx
  push cx
  push dx
  push si
  push di
  push es

  mov dx,0x3ce
  mov ax,517
  out dx,ax
  mov ax,0xa000
  mov es,ax
  mov si,y
  mov cx,y2
  dec si
  mov ah,128
}
boucle3:
asm {

 mov al,8
 mov dx,0x3ce
 out dx,ax
 shr ah,1
 mov si,y
 dec si
}
boucle2:
asm {
  inc si

  mov bx,si
  shl bx,4
  mov di,bx
  shl bx,2
  add di,bx
  mov dx,di

  mov bx,x2
  shr bx,3
  add dx,bx
  mov bx,x
  shr bx,3
  add di,bx
  inc dx
 // dec di
}
boucle1:
asm {
  mov al,es:[di]
  mov al,color
  mov es:[di],al
  inc di
  cmp di,dx
  jnge boucle1

  cmp si,cx
  jnge boucle2

  cmp ah,0
  jne boucle3

  pop es
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
}


