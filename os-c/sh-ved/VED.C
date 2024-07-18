void ProgramStart (char*,char*);

#define aSegment 0xfff
#define BACK_COLOR      0x42
#define FORE_COLOR      0x02
#define ALL_COLOR       0x02000200

#ifndef CTRL
#define CTRL(c) ((c) & 037)
#endif

void ProgramEntry (void)
{
 ProgramStart ((char*)_ES,(char*)_BX);

 asm { retf };
}

char is_xsh (void)
{
 asm {
        mov ah,4
        int 0x46
     }
}

int isecho = 1;

#include <stdout.h>
#include <mm.h>
#include <file.h>
#include <typedef.h>
#include <memory.h>
#include <string.h>
#include <arg.h>


char KeyCode;

char ReadChar (void)
{
 asm {
        mov ah,18h
        int 0x44
	mov KeyCode,ah
     }
}


void ClearScreen (ulong back)
{
 asm {
	push eax
	push bx
	push dx
	push es
	push di
	push cx
       ;mov ax,3
       ;int 0x10
	mov ax,0xb800
	mov es,ax
	mov di,0
	mov cx,1000
	mov eax,back
	rep stosd
	mov ah,1
	mov cx,0x2000
	int 0x10
	mov ah,2
	xor bh,bh
	xor dx,dx
	int 0x10
	pop cx
	pop di
	pop es
	pop dx
	pop bx
	pop eax
     }
}

addr startdisp=0;
addr dispbuffer=0;
addr textbuffer=0;
addr segbuffer=0;
addr line=1;

void InsertChar (char c, addr BufferOfs)
{
 asm {
	push ax
	push es
	push di
	mov ax,0xb800
	mov es,ax
	mov di,BufferOfs
	mov al,c
	mov es:[di],al
	pop di
	pop es
	pop ax
     }
}

char PeekChar (addr BufferOfs)
{
 asm {
	push es
	push di
	mov ax,0xb800
	mov es,ax
	mov di,BufferOfs
	mov al,es:[di]
	pop di
	pop es
     }
}

void TextPut (char c, addr TextOfs)
{
 asm {
	push ax
	push es
	push di
	mov ax,segbuffer
	mov es,ax
	mov di,TextOfs
	mov al,c
	mov es:[di],al
	pop di
	pop es
	pop ax
     }
}

char TextGet (addr TextOfs)
{
 asm {
	push es
	push di
	mov ax,segbuffer
	mov es,ax
	mov di,TextOfs
	mov al,es:[di]
	pop di
	pop es
     }
}

void DispText (addr DispOfs, addr TextOfs)
{
 addr i;
 char cget;
 for (i=DispOfs; i <= (8000-DispOfs); i += 2)
 {
  cget = TextGet (TextOfs);
  if (cget==13) { do {InsertChar (0,i); i += 2;} while ( ((i+2)%160) );
		  TextOfs++;}
  else InsertChar (cget,i);
  TextOfs++;
 }

}

void ClearText (addr SegText)
{
 asm {
	push ax
	push es
	push di
	push cx
	mov ax,SegText
	mov es,ax
	mov di,0
	mov cx,0xfff0
	mov al,0
	rep stosb
	pop cx
	pop di
	pop es
	pop ax
     }
}


void DelText (addr TextOfs)
{
 asm {
	push ax
	push es
	push di
	push ds
	push si
	push cx
	mov ax,segbuffer
	mov es,ax
	mov ds,ax
	mov si,TextOfs
	mov di,si
	inc si
	mov cx,0xfff0
	sub cx,di
	rep movsb
	pop cx
	pop si
	pop ds
	pop di
	pop es
	pop ax
     }
}

void InsText (char c, addr TextOfs)
{
 asm {
	push ax
	push cx
	push es
	push ds
	push di
	push si
	mov ax,segbuffer
	mov es,ax
	mov ds,ax
        mov si,0xffef -1
        mov di,0xfff0 -1
        mov cx,0xffef -1
	mov ax,TextOfs
	sub cx,ax
        inc cx
        std
	rep movsb
	cld
	mov di,TextOfs
	mov al,c
	mov es:[di],al
	pop si
	pop di
	pop ds
	pop es
	pop cx
	pop ax
     }
}

void BackgroundChar (addr BufferOfs, char color)
{
 InsertChar (color,BufferOfs+1);
}

unsigned int LengthLine (addr l)
{
 unsigned int temp,counter,length=0;

 for (temp=0;counter != l; temp++)
 {
  if (TextGet (temp) == 13) { length = 0; counter++; }
  else length++;
 }

 return length;
}

void send_char (char sc,char scode)
{
 asm {
         push ax
         push cx
         mov ah,5
         mov ch,scode
         mov cl,sc
         int 0x16
         pop cx
         pop ax
     }
}

void Characters (char c,char keycode)
{
 addr x,i;

 switch (keycode)
 {

  case 72:      if ( (!startdisp) && (dispbuffer < 160)) break;
		if ( (dispbuffer < 160) && (startdisp) )
		{
		 i=0;
		 for (x=0;TextGet (textbuffer-x) !=10; x++) i++;
		 x++;


		 for ( ; (TextGet (textbuffer-x) != 10) && (textbuffer-x+1); x++) ;

		 DispText (0,startdisp-x+i);
		 if ( (PeekChar (dispbuffer) == 0) && (dispbuffer%160))
		  {
		   DispText (0,startdisp);
		   break;
		  }
		 dispbuffer+=160;
		 startdisp = startdisp - x+i;
		}
		x=0;
		if ( !(dispbuffer%160) );
		else if (PeekChar (dispbuffer - 160) == 0) break;
		for ( i=0; i <= 160 ; i+=2)
		 if (PeekChar (dispbuffer-i) != 0) x++;
                BackgroundChar (dispbuffer,FORE_COLOR);
		if ( (!(dispbuffer%160)) && (PeekChar(dispbuffer-160)==0) ) ;//textbuffer -= 2;
		if ( (!(dispbuffer%160)) && (PeekChar(dispbuffer)==0) ) textbuffer--;
		if ( TextGet (textbuffer)== 13)  x++;
		textbuffer -= x+1;
		dispbuffer -= 160;
                BackgroundChar (dispbuffer,BACK_COLOR);
		break;

  case 80:      i=0;
		for (x=0; x <= 158; x += 2) if (PeekChar (dispbuffer+x) == 26) { i=1;break;}
		if (i) break;
		if (!(dispbuffer%160) );
		else if (PeekChar (dispbuffer + 160) == 0) break;
		if (dispbuffer >= (160*24))
		{

		 for (x=0;PeekChar (x) !=0; x+=2);
		 //x++;
		 x = x>>1;
		 x = x +2;

		 DispText (0,startdisp+x);
		 dispbuffer-=160;
		 startdisp = startdisp + x;
		}
		x=0;
		for ( i=0; i <= 160 ; i+=2)
		 {
		 if (PeekChar (dispbuffer+i) != 0) x++;

		 }
                BackgroundChar (dispbuffer,FORE_COLOR);
		if ( (!(dispbuffer%160)) && (PeekChar(dispbuffer+160)==0)
		      && (PeekChar(dispbuffer)!=0)) textbuffer++;
		if ( (!(dispbuffer%160)) && (PeekChar(dispbuffer)==0) ) textbuffer+=2;
		else textbuffer += x+1; // modifs
		dispbuffer += 160;
                BackgroundChar (dispbuffer,BACK_COLOR);
		break;


  case 75:      if (!dispbuffer) break;
		if (!(dispbuffer%160)) break;
                BackgroundChar (dispbuffer,FORE_COLOR);
		textbuffer--;
		dispbuffer -= 2;
                BackgroundChar (dispbuffer,BACK_COLOR);
		break;

  case 77:      if (TextGet (textbuffer) == 26) break;
		if (TextGet (textbuffer) == 13) break;
		if ( (dispbuffer%160)==79) break;
                BackgroundChar (dispbuffer,FORE_COLOR);
		textbuffer++;
		dispbuffer += 2;
                BackgroundChar (dispbuffer,BACK_COLOR);
		break;

  case 15:      for (x=0;x<=7;x++) send_char (32,57);
		break;
        
  case 14:      send_char (0,75); send_char (8,83);
                break;

  case 83:      if (TextGet (textbuffer) == 26) break;
		if (TextGet (textbuffer) == 13) DelText (textbuffer);
		DelText (textbuffer);
		DispText (dispbuffer,textbuffer);

		break;

  default:      InsText (c,textbuffer);
		if (keycode==28) InsText (10,textbuffer+1);
		if ( (keycode==28) && (dispbuffer >= (160*24)) )
		{

		 for (x=0;PeekChar (x) !=0; x+=2);
		 //x++;
		 x = x>>1;
		 x = x +2;

		 DispText (0,startdisp+x);
		 //dispbuffer = 160*24;
		 startdisp = startdisp + x;

		}
		else
		DispText (dispbuffer,textbuffer);
                BackgroundChar (dispbuffer,FORE_COLOR);
		textbuffer++;
		if (keycode==28) textbuffer++;

		if ( (keycode==28) && !(dispbuffer >= (160*24)) )dispbuffer = dispbuffer + (160-(dispbuffer%160));
		else dispbuffer += 2;
                BackgroundChar (dispbuffer,BACK_COLOR);
		break;
 }
}




static char ved [] = "Visual Editor 0.1";
static char MemoryError [] = "Enough memory.";

char C;
int opened=0;

handle file1, file2;

ulong textsize (void)
{
 ulong i;
 for (i=0;(TextGet (i) != 26);i++);
 return i;
}

void initprint (void)
{
 asm {
	push ax
	push dx
	mov ah,1
	mov dx,0
	int 0x17
	pop dx
	pop ax
     }
}

void printchar (char c)
{
 asm {
	push ax
	push dx
	mov ah,0
	mov al,c
	mov dx,0
	int 0x17
	pop dx
	pop ax
     }
}


void printit (void)
{
 addr i;
 for (i=0; (TextGet (i) != 26); i++) printchar (TextGet(i));
}



char argv[50];

void ProgramStart (char* s, char* o)
{
 if (is_xsh()) { puts ("\r\nwarning: can't run under xsh"); 
                 return ;
               }
 memcpy ((uint)_CS,(uint)argv,(uint)s,(uint)o,50);

  ClearScreen (ALL_COLOR);

 segbuffer=malloc (aSegment);
 if (!segbuffer) puts (MemoryError);
 ClearText (segbuffer);
 BackgroundChar (0,BACK_COLOR);


 if ( strcmp ((string)get_argz(argv,2),""))
 {
  file1 = fopen ((string)get_argz(argv,2));
  if (file1 < 2) {TextPut (26,0);InsertChar (26,0);}
  else
  {
   fread (file1,fsize (file1), 0,segbuffer);
   TextPut (26,fsize (file1));
   DispText (0,0);
   opened =1;
  }

 }
 else { InsertChar (26,0);TextPut (26,0);}

 while (1)
 {
  C = ReadChar ();
  if (KeyCode==1) break;
  if (C==0x13) {
		    if (opened) { fremove (file1) ;
				  file1 = fcreate ((string)get_argz(argv,2));
				  fwrite (file1,textsize(),0,segbuffer);
				}
		    else {
			  file1 = fcreate ((string)get_argz(argv,2));
			  fwrite (file1,textsize(),0,segbuffer);
			  opened = 1;
			 }
		    continue;
		   }

  if (KeyCode==62) { initprint (); printit (); }
  else Characters (C,KeyCode);
 }
 ClearScreen (0x07000700);
 asm {
      push ax
      push cx
      mov ah,1
      mov cx,0x0C0D
      int 0x10
      pop cx
      pop ax
     }
 free (segbuffer);
}
