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
unsigned int colors = 1;
unsigned int sizeBuffer = 8000;
unsigned int sizeHeader = 62;
unsigned char red, green, blue;

 stream = fopen (picname);
 if (stream < 2) return;
 if (fsize(stream) > (sizeBuffer + sizeHeader)) {
    colors = 16;
    sizeBuffer = 32000;
    sizeHeader = 118;
 }   
 if (fsize(stream) > (sizeBuffer + sizeHeader)) {
    colors = 256;
    sizeBuffer = 48000;
    sizeHeader = 1078;
    picy = 160;
 } 
     
 fread (stream,sizeBuffer + sizeHeader,0,0x9000);

 mode13();
 for (pici=0;pici<=sizeBuffer;pici++)
 {
  if (colors == 1)
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
   if (colors == 16)
  {
        
        pixel = (peek(pici+sizeHeader) & 0xf0) >> 4 ;
        red = peek(0x36 + 2 + (pixel * 4)) >> 2;
        green = peek(0x36 + 1 + (pixel * 4)) >> 2;
        blue = peek(0x36 + 0 + (pixel * 4)) >> 2;
        asm {
            // Set entry 4
mov dx, 0x3c8
mov al, pixel
out dx, al

inc dx
mov al, red 
out dx, al
mov al, green
out dx, al
mov al, blue
out dx, al
        }
        
        putpixel (picx,picy,pixel );
        picx++;
        
        pixel = (peek(pici+sizeHeader) & 0x0f);
        red = peek(0x36 + 2 + (pixel * 4)) >> 2;
        green = peek(0x36 + 1 + (pixel * 4)) >> 2;
        blue = peek(0x36 + 0 + (pixel * 4)) >> 2;
        asm {
            // Set entry 4
mov dx, 0x3c8
mov al, pixel
out dx, al

inc dx
mov al, red 
out dx, al
mov al, green
out dx, al
mov al, blue
out dx, al
        }
        putpixel (picx,picy,pixel );
        picx++;
        
        if (picx==320) { picy--;picx=0;}
  }
  
  if (colors == 256)
  {
        
        pixel = peek(pici+sizeHeader);
        red = peek(0x36 + 2 + (pixel * 4)) >> 2;
        green = peek(0x36 + 1 + (pixel * 4)) >> 2;
        blue = peek(0x36 + 0 + (pixel * 4)) >> 2;
        asm {
            // Set entry 4
mov dx, 0x3c8
mov al, pixel
out dx, al

inc dx
mov al, red 
out dx, al
mov al, green
out dx, al
mov al, blue
out dx, al
        }
        
        putpixel (picx,picy,pixel );
        picx++;
        
        if (picx==300) { picy--;picx=0;}
  }
   
 }
 if (p=='p') getch ();
 mode3();
} 
