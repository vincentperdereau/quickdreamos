
typedef unsigned char BYTE;

extern init640480( void );
extern init800600( void );
extern void setpix1( int x, int y, unsigned char couleur);
extern BYTE getpix1( int x, int y );
extern void setpix2( int x, int y, unsigned char couleur);
extern BYTE getpix2( int x, int y );


extern void setpage( int page );
extern void showpage( int page );
extern void far *getfontptr( void );
extern void barasm1 (int x, int y, int x2, int y2, unsigned char color);
extern void barasm2 (int x, int y, int x2, int y2, unsigned char color);
extern void waitretrace (void);

void OutTextXY (int X, int Y,char* s);

#define         ON      0
#define         OFF     1
#define         BLUE            1
#define         GREEN           2
#define         LIGHTGREEN      3
#define         RED             4

int COLOR=15;

void setpix (int x, int y, unsigned char couleur)
{
 if (gmode == 1)
  setpix1 (x,y,couleur);
 else
  setpix2 (x,y,couleur);

}

unsigned char getpix (int x, int y)
{
 if (gmode == 1)
  return getpix1 (x,y);
 else
  return getpix2 (x,y);

}


void SetRGB (unsigned char Nr, unsigned char R, unsigned char G,
	       unsigned char B)
{
 asm {
       mov al,Nr
       mov dx,0x3c8
       out dx,al
       mov dx,0x3c9
       mov al,R
       out dx,al
       mov al,G
       out dx,al
       mov al,B
       out dx,al
 }
}

void scroll_down2 (unsigned int x, unsigned int y, unsigned int l,
		  unsigned int h, unsigned char speed)
{
 asm {
    push  ds

    mov   dx, 0x3CE
    mov   ax, 0x0105
    out   dx, ax

    cld

    mov   cx, h
    mov   ax, cx
    mov   si, cx
    shl   ax, 5
    shl   cx, 6
    shl   si, 2
    add   cx,si
    add   cx, ax

    mov   bx, y
    mov   si, bx
    mov   ax, bx
    shl   ax, 5
    shl   bx, 6
    shl   si,2
    add   bx, ax
    add   bx,si

    mov   ax, x
    shr   ax, 3
    add   bx, ax

    xor   dh, dh
    mov   dl, speed
    mov   ax, dx
    mov   di, dx
    shl   ax, 5
    shl   dx, 6
    shl   di, 2
    add   dx, ax
    add   dx, di

    mov   ax, cx

    mov   si, 0xA000
    mov   ds, si
    mov   es, si
}

yop8086:

asm {

    mov   si, bx
    add   si, ax
    mov   di, si
    add   di, dx

    mov   cx, l
    shr   cx, 3
    rep   movsb

    sub   ax, 100
    cmp   ax, 0
    ja    yop8086

    pop   ds

 }
}


void scroll_down1 (unsigned int x, unsigned int y, unsigned int l,
		  unsigned int h, unsigned char speed)
{
 asm {
    push  ds

    mov   dx, 0x3CE
    mov   ax, 0x0105
    out   dx, ax

    cld

    mov   cx, h
    mov   ax, cx
    shl   ax, 4
    shl   cx, 6
    add   cx, ax

    mov   bx, y
    mov   ax, bx
    shl   ax, 4
    shl   bx, 6
    add   bx, ax
    mov   ax, x
    shr   ax, 3
    add   bx, ax

    xor   dh, dh
    mov   dl, speed
    mov   ax, dx
    shl   ax, 4
    shl   dx, 6
    add   dx, ax    

    mov   ax, cx    

    mov   si, 0xA000
    mov   ds, si
    mov   es, si 
}

yop8086:               

asm {

    mov   si, bx
    add   si, ax
    mov   di, si
    add   di, dx 

    mov   cx, l  
    shr   cx, 3
    rep   movsb  

    sub   ax, 80 
    cmp   ax, 0
    ja    yop8086

    pop   ds

 }
}

void scroll_down (unsigned int x, unsigned int y, unsigned int l,
		  unsigned int h, unsigned char speed)
{
 if (gmode == 1)
  scroll_down1 (x,y,l,h,speed);
 else 
  scroll_down2 (x,y,l,h,speed);
}

void SetVideo (char stat)
{
 asm {
	mov ah,0x12
	mov bl,0x36
	mov al,stat
	int 0x10
     }
}

 typedef BYTE CARDEF[256][16];       /* Structure du jeu de caract�res */
 typedef CARDEF far *CARPTR;       /* Pointe sur un jeu de caract�res */
 CARPTR fptr = (CARPTR) 0;         /* Jeu de caract�res en ROM */

void PrintChar( char caractere, int x, int y, BYTE cc, BYTE cf , BYTE m)
{

 BYTE         i, k, j,                         /* Compteur d'it�rations */
       masque;           /* Masque binaire pour dessiner le caract�re */

 if ( fptr == (CARPTR) 0 )     /* A-t-on d�j� d�termin� ce pointeur ? */
  fptr = getfontptr();    /* d�termine avec la fonction en assembleur */


  /*- Dessine le caract�re pixel par pixel ---------------------------*/

 if ( cf == 255 )                          /* Caract�re transparent ? */
  for ( i = 0, j = 0; i < (16<<m); i += (m+1),++j ) /* dessine que les pixels du premier plan */
   {
    masque = (*fptr)[caractere][j];         /* Lit le motif bin/ligne */
    for ( k = 0; k < (8<<m); k += (m+1), masque <<= 1 )  /* Parcourt les colonnes */
     {
     if ( masque & 128 )                        /* Pixel � dessiner ? */
      {
       setpix( x+k, y+i, cc );                                  /* Oui */
      }
    }
   }
 else                                     /* Non dessine chaque pixel */
  for ( i = 0; i < 8; ++i )                    /* Parcourt les lignes */
  {
   masque = (*fptr)[caractere][i];          /* Lit le motif bin/ligne */
   for ( k = 0; k < 8; ++k, masque <<= 1 )   /* Parcourt les colonnes */
    setpix( x+k, y+i, (BYTE) (( masque & 128 ) ? cc : cf) );
  }
}

unsigned long getOfs (int i)
{
 asm {
	mov dx,font_mem
	mov ax,i
	shl ax,12
     }
}

void setFont (int i)
{
 fptr = (CARPTR)(getOfs (i));
}


/***********************************************************************
*  Line: Trace un segment dans la fen�tre graphique en appliquant      *
*        l'algorithme de Bresenham                                     *
**--------------------------------------------------------------------**
*  Entr�es : X1, Y1 = Coordonn�es de l'origine                         *
*            X2, Y2 = Coordonn�es de l'extr�mit� terminale             *
*            COULEUR = couleur dusegment                               *
***********************************************************************/

/*-- Fonction accessoire pour �changer deux variables enti�res -------*/

int abs (int n)
{
 if (n >= 0) return n;
 else return (-n);
}

int deltaw;

void writenum (int x, int y, unsigned long dw,char size)
{
 unsigned long i ; unsigned char b ;
 int flag=0;
 int j = 0;

 if (size==8) i = 100;
 if (size==16) i = 10000;
 if (size==32) i = 1000000000;

 for (;i!=0;i/=10)
 {
 b = dw / i ; dw = dw - (b*i) ;
 if (b) flag = 1;
 if (flag) PrintChar (b+48,x+(j<<3) ,y + deltaw,0,255,0);
 if ( (!i) && (!flag)) PrintChar (48,x+(j<<3) ,y + deltaw,0,255,0);
 j = j + 1;
 }
 deltaw = deltaw + 8;
}

unsigned int imagesize(unsigned int x,unsigned int y,
		       unsigned int x0,unsigned int y0)
{
unsigned long dummy;
unsigned int sx,sy;

  sx = (abs(x0-x) / 8)+1;
  sy = (abs(y0-y))+1;
  dummy = (unsigned long)sx*(unsigned long)sy*4+10;   
  
  //writenum (10,400,sx,16);
  //writenum (110,400-8,sy,16);
  //writenum (210,400-16,dummy,32);
   
  if (dummy<65520) 
    return dummy;
  else
    {
     halt();
     return 0;
    }
}

void getimage2(unsigned int x, unsigned int y,
		unsigned int x0, unsigned int y0,
		unsigned int adr)
{
unsigned int m;
asm {
    sti
    push es
    push ds
    pusha
    cld
    mov ax,adr
    mov es,ax
    xor di,di

    mov ax,x0
    sub ax,x
    shr ax,3
    mov x0,ax
    mov es:[di],ax
    inc x0
    mov ax,y0
    sub ax,y
    mov y0,ax
    mov es:[di+2],ax
    inc y0
    add di,4
    shr x,3
    mov bx,y
    mov cx,bx
    mov si,bx
    shl bx,5
    shl cx,6
    shl si,2
    add bx,si
    add bx,cx
    add bx,x
    mov m,bx
    mov ax,0a000h
    mov ds,ax
    mov bx,y0
    mov dx,03ceh
    mov al,4
    out dx,al
    inc dx
}
label1:
asm {
    mov ah,4
    }
label2:
asm {
    mov al,ah
    dec al
    out dx,al
    mov si,m
    mov cx,x0
    rep movsb
    dec ah
    jnz label2
    add m,100      ;
    dec bx
    jnz label1
    dec dx
    mov al,3
    out dx,al
    inc dx
    xor al,al
    out dx,al
    popa
    pop ds
    pop es
    cli
 }
}

void putimage2(unsigned int x, unsigned int y,
	      unsigned int adr)
{
unsigned int sx,sy,m;
asm {
    sti
    push es
    push ds
    pusha
    cld
    shr x,3
    mov bx,y
    mov cx,bx
    mov si,bx
    shl bx,5
    shl cx,6
    shl si,2
    add bx,cx
    add bx,si
    add bx,x
    mov m,bx

    mov ax,adr
    mov ds,ax
    xor si,si

    mov ax,word ptr ds:[si]
    inc ax
    mov sx,ax
    mov ax,word ptr ds:[si+2]
    inc ax
    mov sy,ax
    add si,4
    mov ax,0a000h
    mov es,ax
    mov bx,sy
    mov dx,03c4h
    mov al,2
    out dx,al
    inc dx
}
olabel1:
asm {
    mov al,8
}
olabel2:
asm {
    out dx,al
    mov di,m
    mov cx,sx
    rep movsb
    shr al,1
    jnz olabel2
    add m,100 ;
    dec bx
    jnz olabel1
    dec dx
    mov al,2
    out dx,al
    inc dx
    mov al,15
    out dx,al
    popa
    pop ds
    pop es
    cli
}
}

void fastbar2(int x, int y, int x2, int y2)

{
char color = COLOR;

x--; x2--;
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

 mov al,0
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

  shl bx,2
  mov di,bx
  shl bx,3
  add di,bx
  shl bx,1
  add di,bx


  mov dx,di



  mov bx,x2
  shr bx,3
  add dx,bx
  mov bx,x
  shr bx,3
  add di,bx
  inc dx
  inc di
//  dec di
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

       mov   dx,3ceh
       mov   ax,(0FFh shl 8 ) + 8
       out   dx,ax

       mov   ax,(00h shl 8) + 5
       out   dx,ax


  pop es
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
}

}


void getimage1(unsigned int x, unsigned int y,
		unsigned int x0, unsigned int y0,
		unsigned int adr)
{
unsigned int m;
asm {
    sti
    push es
    push ds
    pusha
    cld
    mov ax,adr
    mov es,ax
    xor di,di

    mov ax,x0
    sub ax,x
    shr ax,3
    mov x0,ax
    mov es:[di],ax
    inc x0
    mov ax,y0
    sub ax,y
    mov y0,ax
    mov es:[di+2],ax
    inc y0
    add di,4
    shr x,3
    mov bx,y
    mov cx,bx
    shl bx,4
    shl cx,6
    add bx,cx
    add bx,x
    mov m,bx
    mov ax,0a000h
    mov ds,ax
    mov bx,y0
    mov dx,03ceh
    mov al,4
    out dx,al
    inc dx
}
label1:
asm {
    mov ah,4
    }
label2:
asm {
    mov al,ah
    dec al
    out dx,al
    mov si,m
    mov cx,x0
    rep movsb
    dec ah
    jnz label2
    add m,80
    dec bx
    jnz label1
    dec dx
    mov al,3
    out dx,al
    inc dx
    xor al,al
    out dx,al
    popa
    pop ds
    pop es
    cli
 }
}

void putimage1(unsigned int x, unsigned int y,
	      unsigned int adr)
{
unsigned int sx,sy,m;
asm {
    sti
    push es
    push ds
    pusha
    cld
    shr x,3
    mov bx,y
    mov cx,bx
    shl bx,4
    shl cx,6
    add bx,cx
    add bx,x
    mov m,bx

    mov ax,adr
    mov ds,ax
    xor si,si

    mov ax,word ptr ds:[si]
    inc ax
    mov sx,ax
    mov ax,word ptr ds:[si+2]
    inc ax
    mov sy,ax
    add si,4
    mov ax,0a000h
    mov es,ax
    mov bx,sy
    mov dx,03c4h
    mov al,2
    out dx,al
    inc dx
}
olabel1:
asm {
    mov al,8
}
olabel2:
asm {
    out dx,al
    mov di,m
    mov cx,sx
    rep movsb
    shr al,1
    jnz olabel2
    add m,80
    dec bx
    jnz olabel1
    dec dx
    mov al,2
    out dx,al
    inc dx
    mov al,15
    out dx,al
    popa
    pop ds
    pop es
    cli
}
}

void fastbar1(int x, int y, int x2, int y2)

{
char color = COLOR;
x--; x2--;
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

 mov al,0
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
  inc di
//  dec di
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

       mov   dx,3ceh
       mov   ax,(0FFh shl 8 ) + 8
       out   dx,ax

       mov   ax,(00h shl 8) + 5
       out   dx,ax


  pop es
  pop di
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
}

}

void fastbar(int x, int y, int x2, int y2)
{
 if (gmode == 1)
  fastbar1 (x,y,x2,y2);
 else
  fastbar2 (x,y,x2,y2);

}

void SwapInt( int *i1, int *i2 )
{
 int dummy;

 dummy = *i2;
 *i2   = *i1;
 *i1   = dummy;
}

/*-- Proc�dure principale --------------------------------------------*/

void Line( int x1, int y1, int x2, int y2)
{
 int d, dx, dy,
     aincr, bincr,
     xincr, yincr,
     x, y;

 if ( abs(x2-x1) < abs(y2-y1) )            /* Parcours : axe X ou Y ? */
  {                                                          /* Par Y */
   if ( y1 > y2 )                            /* y1 plus grand que y2? */
    {
     SwapInt( &x1, &x2 );                    /* Oui �change X1 et X2, */
     SwapInt( &y1, &y2 );                                 /* Y1 et Y2 */
    }

   xincr = ( x2 > x1 ) ?  1 : -1;           /* Fixe le pas horizontal */

   dy = y2 - y1;
   dx = abs( x2-x1 );
   d  = 2 * dx - dy;
   aincr = 2 * (dx - dy);
   bincr = 2 * dx;
   x = x1;
   y = y1;

   setpix( x, y, COLOR );               /* dessine le premier pixel */
   for (y=y1+1; y<= y2; ++y )                 /* Parcourt l'axe des Y */
    {
     if ( d >= 0 )
      {
       x += xincr;
       d += aincr;
      }
     else
      d += bincr;
     setpix( x, y, COLOR );
    }
  }
 else                                                        /* par X */
  {
   if ( x1 > x2 )                            /* x1 plus grand que x2? */
    {
     SwapInt( &x1, &x2 );                     /* Oui, �change X1 et X2*/
     SwapInt( &y1, &y2 );                                 /* Y1 et Y2 */
    }

   yincr = ( y2 > y1 ) ? 1 : -1;              /* Fixe le pas vertical */

   dx = x2 - x1;
   dy = abs( y2-y1 );
   d  = 2 * dy - dx;
   aincr = 2 * (dy - dx);
   bincr = 2 * dy;
   x = x1;
   y = y1;

/*   SetPixel*/
   setpix( x, y, COLOR );               /* Dessine le premier pixel */
   for (x=x1+1; x<=x2; ++x )                  /* Parcourt l'axe des X */
    {
     if ( d >= 0 )
      {
       y += yincr;
       d += aincr;
      }
     else
      d += bincr;
     setpix( x, y, COLOR );
    }
  }
}

void Bar (int x, int y, int w, int h)
{
 if (gmode == 1)
  barasm1 (x,y,w,h,COLOR);
 else
  barasm2 (x,y,w,h,COLOR);
}




void SetColor (int color)
{
 COLOR = color;
}

void Rectangle (int x, int y, int x2, int y2)
{
 Line (x,y,x2,y);
 Line (x,y,x,y2);
 Line (x2,y,x2,y2);
 Line (x,y2,x2,y2);
}

void XORRectangle (unsigned int x, unsigned int y, unsigned int x2,
		   unsigned int y2)
{
 unsigned int i;
 for (i=x;i<=x2;i++)
  {
  setpix (i,y,getpix (i,y) ^ 1);
  setpix (i,y2,getpix (i,y2) ^ 1);
  }
 for (i=y;i<=y2;i++)
 {
  setpix (x,i,getpix (x,i) ^ 1);
  setpix (x2,i,getpix (x2,i) ^ 1);
 }
}

void OutTextXY (int X, int Y,char* s)
{
 register int i;
 for (i=0; s[i] != 0; i++) PrintChar (s[i],X+(i<<3) ,Y,COLOR,255,0);
}

void FarOutTextXY (int X, int Y,char far* s)
{
 int i;
 for (i=0; s[i] != 0; i++) PrintChar (s[i],X+(i<<3) ,Y,COLOR,255,0);
}

static unsigned char BGWindow=7;

void Window1 (int X, int Y, int w, int h,int Color, char* title)
{
unsigned int u;
/*
 SetColor (Color);
 Bar (X,Y,X+Long,Y+Larg);
 SetColor (0);
 Rectangle (X-2,Y-2,X+Long+2,Y+Larg+2);
 Line (X+Long+1,Y-1,X+Long+1,Y+Larg+1);
 Line (X-1,Y+Larg+1,X+Long+1,Y+Larg+1);
 SetColor (15);
 Line (X-1,Y-1,X+Long+1,Y-1);
 Line (X-1,Y-1,X-1,Y+Larg+1);
 SetColor (0);
 Rectangle (X+3,Y+18,X+Long-3,Y+Larg-3);
 SetColor (15);
 Line (X+Long-2,Y+18,X+Long-2,Y+Larg-2);
 Line (X+3,Y+Larg-2,X+Long-2,Y+Larg-2);
 Line (X+3,Y+3,X+Long-3,Y+3);
 Line (X+3,Y+5,X+Long-3,Y+5);
 Line (X+3,Y+7,X+Long-3,Y+7);
 Line (X+3,Y+9,X+Long-3,Y+9);
 Line (X+3,Y+11,X+Long-3,Y+11);
 Line (X+3,Y+13,X+Long-3,Y+13);
 Line (X+4,Y+19,X+4,Y+Larg-4);
 Line (X+4,Y+19,X+Long-4,Y+19);
 SetColor (8);
 Line (X+3,Y+4,X+Long-3,Y+4);
 Line (X+3,Y+6,X+Long-3,Y+6);
 Line (X+3,Y+8,X+Long-3,Y+8);
 Line (X+3,Y+10,X+Long-3,Y+10);
 Line (X+3,Y+12,X+Long-3,Y+12);
 Line (X+3,Y+14,X+Long-3,Y+14);
 SetColor (Color);
 Bar ( X+(Long>>1) - (strlen (title)<<2)-6 ,Y+3,
       X+(Long>>1) + (strlen (title)<<2)+6 ,Y+14);
 SetColor (9);
 OutTextXY (X+(Long>>1) - (strlen (title)<<2)+1,Y+3,title);
 SetColor (8);
 OutTextXY (X+(Long>>1) - (strlen (title)<<2),Y+2,title);
*/
 w--;
 w--;
 SetColor (BGWindow);
 BGWindow = 7;
 fastbar (X,Y,X+w,Y+h);
 SetColor (Color);
 Rectangle (X+1,Y+15,X+w,Y+h-1);
 Rectangle (X+2,Y+15,X+w-1,Y+h-2);
 Bar (X,Y,X+w,Y+15);
 SetColor (15);
 Line (X,Y,X+w,Y);
 Line (X,Y,X,Y+h);
 Line (X+15,Y,X+15,Y+15);
 Line (X+3,Y+h-3,X+w-3,Y+h-3);


 Line (X+w-2,Y+15,X+w-2,Y+h-3);
 SetColor (0);
 Line (X+14,Y+1,X+14,Y+15);
 Line (X+1,Y+15,X+w-2,Y+15);
 Line (X+3,Y+15,X+3,Y+h-2);
 Line (X+1,Y+h,X+w,Y+h);


/*
 SetColor (8);
 Line (X+11,Y+5,X+11,Y+11);
 Line (X+5,Y+11,X+11,Y+11);
 SetColor (7);
 Line (X+4,Y+4,X+10,Y+4);
 Line (X+4,Y+4,X+4,Y+10);
*/

// SetColor (15);
// Rectangle (X+4,Y+4,X+12,Y+12);
 SetColor (0);
// Rectangle (X+3,Y+3,X+11,Y+11);

 for (u = 0; u <= 6; u++)
 {
  setpix (X+4+u-1+1,Y+5+u,15);
  setpix (X+10-u+1,Y+5+u,0);
  setpix (X+4+u+1,Y+5+u,0);
  setpix (X+10-u-1+1,Y+5+u,15);
 }


 Line (X+w+1,Y,X+w+1,Y+h);
 if (isFont) setFont (2);
 SetColor (15);
 OutTextXY (X+20,Y+1,title);
 SetColor (0);
 setFont (0);
}

void Window2 (int X, int Y, int Long, int Larg,int Color, char* title)
{
unsigned int u;
unsigned int lshift = 12;

 X = X + 2;
 Y = Y + 2;
 Long = Long - 5;
 Larg = Larg - 4;

 SetColor (7);
 Bar (X,Y,X+Long,Y+Larg);
 SetColor (0);
 Rectangle (X-2,Y-2,X+Long+2,Y+Larg+2);
 Line (X+Long+1,Y-1,X+Long+1,Y+Larg+1);
 Line (X-1,Y+Larg+1,X+Long+1,Y+Larg+1);
 SetColor (15);
 Line (X-1,Y-1,X+Long+1,Y-1);
 Line (X-1,Y-1,X-1,Y+Larg+1);
 SetColor (0);
 Rectangle (X+3,Y+18,X+Long-3,Y+Larg-3);
 SetColor (15);
 Line (X+Long-2,Y+18,X+Long-2,Y+Larg-2);
 Line (X+3,Y+Larg-2,X+Long-2,Y+Larg-2);
 
 Line (X+3+lshift,Y+3,X+Long-3,Y+3);
 Line (X+3+lshift,Y+5,X+Long-3,Y+5);
 Line (X+3+lshift,Y+7,X+Long-3,Y+7);
 Line (X+3+lshift,Y+9,X+Long-3,Y+9);
 Line (X+3+lshift,Y+11,X+Long-3,Y+11);
 Line (X+3+lshift,Y+13,X+Long-3,Y+13);
 
 Line (X+4,Y+19,X+4,Y+Larg-4);
 Line (X+4,Y+19,X+Long-4,Y+19);
 
 if (BGWindow != 7)
 {
       SetColor (BGWindow);
       Bar (X+5,Y+19+1,X+Long-5,Y+Larg-5);
 }

 
 SetColor (8);
 Line (X+3+lshift,Y+4,X+Long-3,Y+4);
 Line (X+3+lshift,Y+6,X+Long-3,Y+6);
 Line (X+3+lshift,Y+8,X+Long-3,Y+8);
 Line (X+3+lshift,Y+10,X+Long-3,Y+10);
 Line (X+3+lshift,Y+12,X+Long-3,Y+12);
 Line (X+3+lshift,Y+14,X+Long-3,Y+14);
 SetColor (7);
 Bar ( X+(Long>>1) - (strlen (title)<<2)-6 ,Y+3,
       X+(Long>>1) + (strlen (title)<<2)+6 ,Y+14);
 SetColor (0);
 if (isFont) setFont (1);
 OutTextXY (X+(Long>>1) - (strlen (title)<<2),Y+1,title);
 //SetColor (8);
 //OutTextXY (X+(Long>>1) - (strlen (title)<<2),Y+2,title);

 SetColor (15);
 Line (X+11,Y+5,X+11,Y+11);
 Line (X+5,Y+11,X+11,Y+11);
 SetColor (8);
 Line (X+4,Y+4,X+10,Y+4);
 Line (X+4,Y+4,X+4,Y+10);

/*
 Line (X+w+1,Y,X+w+1,Y+h);
 if (isFont) setFont (2);
 SetColor (15);
 OutTextXY (X+20,Y+1,title);
*/ 
 SetColor (0);
 setFont (0);
 BGWindow = 7;
}

void Window (int X, int Y, int w, int h,int Color, char* title)
{
     Window2(X, Y, w, h, Color, title);
}

void Button (int Xbut, int Ybut, int Xbut2, int Ybut2,char* caption)
{
/*
SetColor(0);
Rectangle(Xbut,Ybut,Xbut2,Ybut2);
*/
SetColor (0);
Line (Xbut+1,Ybut,Xbut2-1,Ybut);
Line (Xbut+1,Ybut2,Xbut2-1,Ybut2);
Line (Xbut,Ybut+1,Xbut,Ybut2-1);
Line (Xbut2,Ybut+1,Xbut2,Ybut2-1);

// SetColor (7);
// Bar(Xbut+1,Ybut+1,Xbut2-1,Ybut2-1);

SetColor(15);
Line(Xbut+1,Ybut+1,Xbut2-1,Ybut+1);
Line(Xbut+1,Ybut+1,Xbut+1,Ybut2-1);
SetColor(8);
Line(Xbut+1,Ybut2-1,Xbut2-1,Ybut2-1);
Line(Xbut2-1,Ybut+1,Xbut2-1,Ybut2-1);

setFont (2);
SetColor (7);
OutTextXY(Xbut+2+((Xbut2-Xbut-(strlen(caption)<<3)) >> 1),((Ybut+Ybut2) >> 1)-6,caption);
SetColor(0);
OutTextXY(Xbut+1+((Xbut2-Xbut-(strlen(caption)<<3)) >> 1),((Ybut+Ybut2) >> 1)-7,caption);
setFont (0);
}

void pButton (int Xbut, int Ybut, int Xbut2, int Ybut2,char* caption)
{
/*
SetColor(0);
Rectangle(Xbut,Ybut,Xbut2,Ybut2);
*/

// SetColor (7);
// Bar(Xbut+1,Ybut+1,Xbut2-1,Ybut2-1);
SetColor(8);
Line(Xbut+1,Ybut+1,Xbut2-1,Ybut+1);
Line(Xbut+1,Ybut+1,Xbut+1,Ybut2-1);
SetColor(15);
Line(Xbut+1,Ybut2-1,Xbut2-1,Ybut2-1);
Line(Xbut2-1,Ybut+1,Xbut2-1,Ybut2-1);


setFont (2);
// OutTextXY(Xbut+1+((Xbut2-Xbut-(strlen(caption)<<3)) >> 1),((Ybut+Ybut2) >> 1)-7,caption);
SetColor (0);
OutTextXY(Xbut+2+((Xbut2-Xbut-(strlen(caption)<<3)) >> 1),((Ybut+Ybut2) >> 1)-6,caption);
setFont (0);
}


void Background (char color)
{
 SetVideo (OFF);
 SetColor (color);
 if (gmode ==1)
 Bar (0,0,639,479);
 else
 Bar (0,0,799,599);
 SetColor (0);
 SetVideo (ON);
 backc = color;
}

void getimage(unsigned int x, unsigned int y,
		unsigned int x0, unsigned int y0,
		unsigned int adr)
{
 if (gmode == 1)
  getimage1 (x,y,x0,y0,adr);
 else 
  getimage2 (x,y,x0,y0,adr);

}

void putimage(unsigned int x, unsigned int y,
	      unsigned int adr)
{
 if (gmode == 1)
  putimage1 (x,y,adr);
 else 
  putimage2 (x,y,adr);
}


void shut (void)
{
 int i,j;
 hidemouse ();
 if (gmode == 1)
 for (i=0;i<=480;i += 2)
  for (j=0;j<=640;j += 2)
   setpix (j,i,0);
 else
 for (i=0;i<=600;i += 2)
  for (j=0;j<=800;j += 2)
   setpix (j,i,0);

 showmouse ();
}
