void WriteXY (int x, int y, char c, char attr)
{
 asm {
	push ax
	push bx
	push di
	push es
	mov ax,0xb800
	mov es,ax
	mov ax,160
	mul y
	mov bx,x
	shl bx,1
	add ax,bx
	mov di,ax
	mov al,c
	mov es:[di],al
	mov al,attr
	mov es:[di+1],al
	pop es
	pop di
	pop bx
	pop ax
     }
}

void InitVideo (void)
{
 asm {
	push ax
	push es
	push di
	push cx
	mov ax,3
	int 0x10
	mov ax,0xb800
	mov es,ax
	mov di,0
	mov ax,0x3020
	mov cx,2000
	rep stosw
	pop cx
	pop di
	pop es
	pop ax
      }
}

void Window (int x, int y, int w, int h,char* title,char attr)
{
 int i,j;

 for (i=y; i <= (y+h); i++)
  for (j=x; j <= (x+w); j++)
   {
    WriteXY (j,i,'Û',(attr & 0xF));
    WriteXY (j,y-1,'Ü',0x70 | (attr >> 4));
    WriteXY (j,y+1+h,'ß',(attr >> 4));
    WriteXY (j-1,y+1,'ß',attr);
    WriteXY (x+w+1,i,'Û',0x00);
    WriteXY (x-1,i,'Û',0x70 | (attr >> 4));
    WriteXY (x+w,i,'Û',(attr >> 4));
   }
 WriteXY (x-1,y+1,'Û',0x70 | (attr >> 4));
 WriteXY (x-1,y-1,'Ü',0x70 | (attr >> 4));
 WriteXY (x-1,y+h+1,'ß',0x70 | (attr >> 4));
 WriteXY (x+w+1,y+1+h,'Û',0x0);
}
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             