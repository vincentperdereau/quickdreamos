void mode13 (void)
{
 asm {
	mov ax,0x13
	int 0x10
     }
}

void mode3(void)
{
 asm {
	mov ax,3
	int 0x10
     }
}

void putpixel (int x,int y,char color)
{
 asm {
	push es
	push ax
	push bx
	mov ax,0xa000
	mov es,ax
	mov ax,320
	mul y
	add ax,x
	mov bx,ax
	mov al,color
	mov es:[bx],al
	pop bx
        pop ax
	pop es
 }
}


char peek (unsigned int ofs)
{
 asm {
        push es
        push bx
        mov ax,9000h
        mov es,ax
        mov bx,ofs
        mov al,es:[bx]
        pop bx
        pop es
     }
}

void pic (char* picname, char p)
{

handle stream;

unsigned int pici=0;
unsigned int picx=0,picy=200;
signed char picj=0;
unsigned char pixel;

 stream = fopen (picname);
 if (stream < 2) return;
 fread (stream,8062,0,0x9000);

 mode13();
 for (pici=0;pici<=8000;pici++)
 {
  for (picj=0;picj<=7;picj++)
   {
    pixel = (peek(pici+62) & (128>>picj));
    if (pixel) pixel = 7;
    putpixel (picx,picy,pixel );
    picx++;
    if (picx==320) { picy--;picx=0;}
   }
 }
 if (p=='p') getch ();
 mode3();
} 
