#include "startup.h"
#include "string.h"
#include "file.h"

#define ON 0
#define OFF 1

typedef unsigned char BYTE;

BYTE COLOR;
char isFont = 0;

extern init640480( void );
extern void setpix( int x, int y, unsigned char couleur);
extern BYTE getpix( int x, int y );
extern void setpage( int page );
extern void showpage( int page );
extern void far *getfontptr( void );
extern void barasm (int x, int y, int x2, int y2, unsigned char color);
extern void waitretrace( void );

void hidemouse (void);
void showmouse (void);


static int mx,my,mb;
static int oldx = 320 ,oldy = 240;
static unsigned char cursor [28][3] = {
{0,0,0} ,
{0,1,0} , {1,1,0} ,
{0,2,0} , {1,2,15} , {2,2,0} ,
{0,3,0} , {1,3,15} , {2,3,15}, {3,3,0} ,
{0,4,0} , {1,4,15} , {2,4,15} ,{3,4,15} , {4,4,0},
{0,5,0} , {1,5,15} , {2,5,15} , {3,5,15} , {4,5,15} , {5,5,0},
{0,6,0} , {1,6,0} , {2,6,0} , {3,6,0} , {4,6,0} , {5,6,0} , {6,6,0}
} ;

static unsigned char swap [28];
static flag=0;
static mouse_status = 0;

static int show_mouse;
static int i;

void mouse_handler ()
{
 asm { push ax bx cx dx ds };
 asm { mov ax,cs
       mov ds,ax }

 if (mouse_status)
 {

 mx = _CX;
 my = _DX;

  for (i=0 ; i <= 27 ; i++)
  {
    if (flag) setpix ( oldx + cursor [i][0] , oldy + cursor [i][1] , swap[i]);
  }
  for (i=0 ; i <= 27 ; i++)
  {
     swap [i] = getpix ( mx + cursor [i][0] , my + cursor [i][1] );
     setpix ( mx + cursor [i][0] , my + cursor [i][1] , cursor [i][2]);
  }

  flag = 1;
  oldx = mx;
  oldy = my;
 }
 asm { pop ds dx cx bx ax };
 asm { retf };
}

unsigned int ismouse (void)
{
 asm {
       mov ax,0
      // int 0x33
     }
}

void showmouse ()
{
 register int i;

 if ( ismouse()  != 0xffff) return;

 mx = oldx; my = oldy;

  for (i=0 ; i <= 27 ; i++)
  {
     swap [i] = getpix ( mx + cursor [i][0] , my + cursor [i][1] );
     if (flag) setpix ( mx + cursor [i][0] , my + cursor [i][1] , cursor [i][2]);
  }

 mouse_status = 1;
// show_mouse = 1;
}

void hidemouse ()
{
 register int i;

 if ( ismouse()  != 0xffff) return;

  for (i=0 ; i <= 27 ; i++)
  {
    if (flag) setpix ( oldx + cursor [i][0] , oldy + cursor [i][1] , swap[i]);
  }
 mouse_status = 0;
// show_mouse = 0;
}

void init_mouse (void)
{
 asm {
        push ax bx cx es
	mov ax,4
	mov bx,640
	mov cx,480
       // int 0x33
	mov ax,5
	mov bx,1
	mov cx,1
       // int 0x33
	mov ax,cs
	mov es,ax
	mov ax,1
	mov bx,offset MGRP:_mouse_handler
       // int 0x33
	mov ax,6
       // int 0x33
        pop es cx bx ax
     }
}


void shut_mouse (void)
{
 asm {
	mov ax,2
      //  int 0x33
	mov ax,7
      //  int 0x33
     }
}

int bmouse (void)
{
 asm {
	mov ax,3
      //  int 0x33
	mov ax,bx
     }
}

char is_key (void)
{
 asm {
        mov ah,1
        int 0x16
        setz al
        xor al,1

       mov al,0

      }
}


void SetVideo (char stat)
{
return;
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
        mov dx,0x8000
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
 asm {
        mov ax,n
        and ax,0111111111111111b
     }
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

char pic_peek (unsigned int ofs)
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

void pic (char* picname, int h)
{
handle stream;

unsigned int pici=0;
unsigned int picx=160,picy;
signed char picj=0;
unsigned char pixel;

 picy = h+200;

 stream = fopen (picname);
 if (stream < 2) return;
 fread (stream,8062,0,0x9000);

 for (pici=0;pici<=(8000-1);pici++)
 {
  for (picj=0;picj<=7;picj++)
   {
    pixel = (pic_peek(pici+62) & (128>>picj));
    if (!pixel) setpix (picx,picy,pixel );
    picx++;
    if (picx==480) { picy--;picx=160;}
   }
 }
}

void OutTextXY (int X, int Y,char* s, char ul, BYTE m)
{
 register int i;
 for (i=0; s[i] != 0; i++)
 {
  PrintChar (s[i],X+( (i<<3) << m) ,Y,COLOR,255,m);
  if (ul) Line ( X+(i<<3),Y+14,X+(i<<3)+(8<<m),Y+14);
 }
}

 typedef        unsigned int    addr;

 addr bufferbatch;

 char peekchar (unsigned int ofs)
 {
  asm {
	push ds
	push si
	mov ax,bufferbatch
	mov ds,ax
	mov si,ofs
	lodsb
	pop si
	pop ds
      }
 }

 int file_offset;

 int fgets (char* s,int in,handle h)
 {
  int i;
  for (i=0; (peekchar (file_offset+i) != 13) && (peekchar (file_offset+i) != 0);i++) s[i] = peekchar (file_offset+i);
  if (peekchar (file_offset+i) == 0) return 0;
  s[i] = 0;
  file_offset += i+2;
  return 1;
 }

 addr malloc (unsigned int paragraph)
 {
  asm {
        push bx
        mov ah,0x0012
        mov bx,paragraph
        int 0x44
        pop bx
      }
 }


 void free (addr adr)
 {
  asm {
       push bx
       mov ah,0x0013
       mov bx,adr
       int 0x44
       pop bx
      }
 }

 void clearBufferSegment (void)
 {
  asm {
	push ax
	push cx
	push es
	push di
	mov ax,bufferbatch
	mov es,ax
	mov di,0
        mov cx,0xfff0
	mov ax,0
        rep stosb
	pop di
	pop es
	pop cx
	pop ax
      }
 }


void Bar (int x, int y, int w, int h)
{
/*
 register i,j;

 for (i = y; i <= (h); i++)
  for (j = x; j <= (w); j++)
   setpix (j,i,COLOR);
*/
 barasm (x,y,w,h,COLOR);
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

void fillscreen (void)
{
 asm {
   push ax bx cx dx di es
   mov ax,(02h shl 8) + 5
   mov dx,3ceh
   out dx,ax
   mov ax,0a000h
   mov es,ax
   mov di,0
   mov cx,0ffffh
   mov al,07h
   rep stosb
   pop es di dx cx bx ax
  }
}

void Window (int X, int Y, int w, int h,int Color, char* title)
{

// SetColor (7);
// Bar (X,Y,X+w,Y+h);
 waitretrace ();
 fillscreen ();
 SetColor (Color);

 Rectangle (X+1,Y+15,X+w,Y+h-1);
 Rectangle (X+2,Y+15,X+w-1,Y+h-2);
 Bar (X,Y,X+w,Y+15);
 SetColor (15);
 Line (X,Y,X+w,Y);
 Line (X,Y,X,Y+h);
 Line (X+15,Y,X+15,Y+15);
 Line (X+3,Y+h-3,X+w-3,Y+h-3);
 Line (X+11,Y+5,X+11,Y+11);
 Line (X+5,Y+11,X+11,Y+11);
 Line (X+w-2,Y+15,X+w-2,Y+h-3);
 SetColor (0);
 Line (X+14,Y+1,X+14,Y+15);
 Line (X+1,Y+15,X+w-2,Y+15);
 Line (X+3,Y+15,X+3,Y+h-2);
 Line (X+1,Y+h,X+w,Y+h);
 Line (X+4,Y+4,X+10,Y+4);
 Line (X+4,Y+4,X+4,Y+10);
 Line (X+w+1,Y,X+w+1,Y+h);
 if (isFont) setFont (2);
 OutTextXY (X+20,Y+1,title,0,0);
 setFont (0);
}


handle input;
char s[100];

#define NULL 0

int x,l,oldl,oldx;
char ul,m;
int flag;
char bb;
int ww;
int link;
int quit;
char fdisp [30];

struct linkrect
{
 int x;
 int y;
 int x2;
 int y2;
 char filename [30];
};

struct linkrect link_rect [20];

void readpg (void)
{

 SetVideo (OFF);
 strcpy (fdisp,"index.qdl");

 display:

 hidemouse ();
 SetVideo (OFF);
 Window (1,1,638,478,8,fdisp);

 for (bb=0;bb<=19;bb++)
 {
      link_rect [bb].x  = 0;
      link_rect [bb].y  = 0;
      link_rect [bb].x2 = 0;
      link_rect [bb].y2 = 0;
 }

 file_offset = 0;
 x = 20; l = 32; flag = 0; oldl = 32;oldx = 20;
 ul = 0; m = 0;
 link = 0;
 quit = 0;

 input = fopen (fdisp);
 if (input < 2) return ;
 bufferbatch = malloc (0xfff);
 clearBufferSegment ();
 fread (input,fsize(input),0,bufferbatch);

  while ( fgets (s,100,input) != NULL )
  {

   if ( s[0] == '.')
   {
    if (!strcmp (s,".center")) flag = 1 ;
    else if (!strcmp (s,".left")) { x = 20 ; oldx = 20 ; }
    else if (!strcmp (s,".tab")) x += 20;
    else if (!strcmp (s,".right")) flag = 2;
    else if (!strcmp (s,".underline")) ul = 1;
    else if (!strcmp (s,".master"))  m = 1; 
    else if (!strcmp (s,".link")) flag = 3;
    else if (!strcmp (s,".keepl")) { l = oldl ; x = oldx ; }
    else if (!strcmp (s,".figure")) {
                                     fgets (fdisp,100,input);
                                     pic (fdisp,l);
                                     l += 210;
                                    }
    else if (!strcmp (s,".normal")) setFont (0);
    else if (!strcmp (s,".computer")) setFont (1);
    else if (!strcmp (s,".bold")) setFont (3);
    else if (!strcmp (s,".italics")) setFont (4);
    else if (!strcmp (s,".modern")) setFont (5);
    else if (!strcmp (s,".roman")) setFont (6);
    else if (!strcmp (s,".black"))   COLOR = 0;
    else if (!strcmp (s,".blue"))    COLOR = 1;
    else if (!strcmp (s,".green"))   COLOR = 2;
    else if (!strcmp (s,".lgreen"))  COLOR = 3;
    else if (!strcmp (s,".red"))     COLOR = 4;
    else if (!strcmp (s,".magenta")) COLOR = 5;
    else if (!strcmp (s,".brown"))   COLOR = 6;
    else if (!strcmp (s,".lgray"))   COLOR = 7;
    else if (!strcmp (s,".dgray"))   COLOR = 8;
    else if (!strcmp (s,".line")) {
				    for (ww=20;ww<=620;ww++)
				    {
                                     setpix (ww,l+7,8);
                                     setpix (ww,l+8,15);
				    }
				   l += 16;
				  }
   }
    else
    {
     if (flag == 1) x = 320 - ( strlen (s) * (4<<m) );
     if (flag == 2) x = 620 - (strlen (s) * (8<<m));
     if (flag == 3)
     {
      if (link == 29) continue;
      link_rect [link].x  = x;
      link_rect [link].y  = l;
      link_rect [link].x2 = x + ( strlen (s) * 8 );
      link_rect [link].y2 = l+8+4;
      ul = 1; SetColor (1);
      for (bb = 0; bb <= 29; bb++) link_rect [link].filename[bb] = 0;
      fgets (link_rect [link].filename,29,input);
      link ++;
     }
     oldl = l; 
     OutTextXY (x,l,s,ul,m);
     flag = 0;
     if (flag != 4) { l += 16; oldx = x; }
     oldx +=  ( (strlen (s))*8 );
     ul = 0;
     m = 0;
    }
    for (bb = 0; bb <= 99; bb++)
    {
     s[bb] = 0;
    }
    
  }
  free ((addr)bufferbatch);
 SetVideo (ON);
 showmouse ();

 asm {
  xor ax,ax
  int 0x16
  mov ax,3
  int 10h
 }

  while (!quit)
  {
//   if (is_key ()) quit = 2;
 /*
   if ( bmouse () )
   {
    for ( bb = 0; bb <= link; bb++)
    {
     if (   (mx>link_rect[bb].x)  && (my>link_rect[bb].y)
         && (mx<link_rect[bb].x2) && (my<link_rect[bb].y2) )
         {
          for (ww = 0; ww <= 29; ww++) fdisp[ww] = 0;
          strcpy (fdisp,link_rect[bb].filename);
          quit = 1;
          if (!strcmp (link_rect[bb].filename,"<system>")) quit = 2;
         }
    }
   }
  */
  }
  if (quit==1) goto display;
}

handle fntfile;

void StartProgram ()
{
 init640480 ();

 fntfile = fopen ("/lib/fnt/breeze.fnt");
 fread (fntfile, 4096, 0, 0x8000);
 fntfile = fopen ("/lib/fnt/comp.fnt");
 fread (fntfile, 4096, (void*)4096, 0x8000);
 fntfile = fopen ("/lib/fnt/hylas.fnt");
 fread (fntfile, 4096, (void*)8192, 0x8000);
 fntfile = fopen ("/lib/fnt/bold.fnt");
 fread (fntfile, 4096, (void*)12288, 0x8000);
 fntfile = fopen ("/lib/fnt/italics.fnt");
 fread (fntfile, 4096, (void*)16384, 0x8000);
 fntfile = fopen ("/lib/fnt/modern.fnt");
 fread (fntfile, 4096, (void*)20480, 0x8000);
 fntfile = fopen ("/lib/fnt/roman.fnt");
 fread (fntfile, 4096, (void*)24576, 0x8000);


 isFont = 1;
 setFont (0);
 COLOR = 0;

 if (ismouse () == 0xffff)
 {
  mouse_status = 1;
  init_mouse ();
 }

 showmouse ();
 readpg ();

 if (ismouse () == 0xffff) shut_mouse ();

 asm {
        mov ax,3
        int 10h
      }

}
