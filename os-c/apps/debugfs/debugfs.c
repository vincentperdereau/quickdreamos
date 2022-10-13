void ProgramEntry (void);

void ProgramStartup (void)
{
 ProgramEntry ();
 asm { retf };
}

#include "typedef.h"
#include "disk.h"
#include "ls.h"
#include "string.h"


void set_mode (int mode)
{
 asm {
      mov ax,mode
      int 0x10
     }
}

void putpixel (unsigned int adr,unsigned char color)
{
 asm {
	push es
        mov ax,0xa000
        mov es,ax
        mov bx,adr
        mov al,color
        mov es:[bx],al
	pop es
 }
}

unsigned char acdisk (void)
{
 asm {
	push es
	mov ax,0x7c0
	mov es,ax
	mov al,es:[509]
	pop es
     }
}

void ConsoleWriteChar (char c)
{
 asm { push ax ; mov al,c ; int 0x29 ; pop ax }
}

void ConsoleWriteString (char* s)
{
 int i;
 for ( i=0; s[i] != 0; i++) ConsoleWriteChar (s[i]);
}

void ConsoleWriteDword (unsigned long dw)
{
 unsigned long i ; unsigned char b ;
 int flag=0;
 for (i=1000000000;i!=0;i/=10)
 {
 b = dw / i ; dw = dw - (b*i) ;
 if (b) flag = 1;
 if (flag) ConsoleWriteChar (b+48) ;
 }
}

void ConsoleReadString (char* s, int length)
{
 asm {
	push ax
	push bx
	push cx
	push es
	mov ax,cs
	mov es,ax
	mov bx,s
	mov cx,length
	mov ah,0x0011
	int 0x44
	pop es
	pop cx
	pop bx
	pop ax
     }
}

char* ScanString (char* line,int count)
{
 unsigned char i ;
 unsigned char j ;
 int intern_count=0 ;
 for (i=0;i<=50;i++)
 {
  if (line[i]!=32) { for (j=i;(line[j]!=32)&&(line[j]!=0);j++);line[j]=0;

		     intern_count++;
		     if (intern_count==count) break ;
		     i=j;}
 }
return (line+i);
}

static char prompt [] = "\r\ndebugfs> ";
static char nl [] = "\n\r";
char cmd [20];
ulong a,b,c,d,e;
int quit=0;
ulong total_size=0;
unsigned char bitmap[512];

unsigned int adr=0;

void ProgramEntry ()
{
 char drive;

 adr=0;
 while (1)
 {
  ConsoleWriteString (prompt);
  ConsoleReadString (cmd,19);
  if (!strcmp ((string)ScanString(cmd,1),"help"))
  {
   ConsoleWriteString ("\n\rhelp - commands");
   ConsoleWriteString ("\n\rdisk [a/c] - disk informations (C/H/S)");
   ConsoleWriteString ("\n\rbitmap [a:/c:] [picture] - bitmap");
   ConsoleWriteString ("\n\rchain - FCB\n");
  }

  if (!strcmp ((string)ScanString(cmd,1),"disk"))
   {
    if (!strcmp ((string)ScanString(cmd,2),"a")) drive = 0x00;
    if (!strcmp ((string)ScanString(cmd,2),"c")) drive = 0x80;
    ConsoleWriteString ("\n\r * H/C/S        : ");
     ConsoleWriteDword (get_head (drive)+1); ConsoleWriteChar ('/');
     ConsoleWriteDword (get_cyl (drive)+1); ConsoleWriteChar ('/');
     ConsoleWriteDword (get_sector (drive));
    ConsoleWriteString ("\n\r * Addr. Max.   : ");
     ConsoleWriteDword (  (get_head (drive)+1)
			* (get_cyl (drive)+1)
			* (get_sector (drive)) );
    ConsoleWriteString ("\n\r * Size (Mb)    : ");
     ConsoleWriteDword (  (get_head (drive)+1)
			* (get_cyl (drive)+1)
			* (get_sector (drive)) >> 11);
    ConsoleWriteString ("\n\r * bitmap (b)   : ");
     ConsoleWriteDword ((((get_head (drive)+1)
			* (get_cyl (drive)+1)
			* (get_sector (drive))-1) >> 3) + 1);


   }

 if (!strcmp ((string)ScanString(cmd,1),"bitmap"))
 {
  if (!strcmp ((string)ScanString(cmd,3),"picture"))
   {
    adr = 0;
    set_mode (0x13);
   }

  if (!strcmp ((string)ScanString(cmd,2),"a:")) drive = 0;
  else if (!strcmp ((string)ScanString(cmd,2),"c:")) drive = 0x80;
  else { ConsoleWriteString ("\n\r bitmap [drive:] "); continue ; }
  quit = 0; total_size = 0;
  e = (((get_head (drive)+1) * (get_cyl (drive)+1)*(get_sector (drive))-219) >> 3);
  e = (e>>9);
  if (!e) e++;
  for (b=219;(b<(e+219));b++)
  {
   fcb_dir (b,&bitmap);
   for (d=0;d<=511;d++)
   {
    for (c=0;c<=7;c++)
    {
     if ( bitmap[d] & (1<<c) )
     {
      total_size++;
      if (!strcmp ((string)ScanString(cmd,3),"picture"))
       putpixel (adr,9);
     }
    adr++;
    }
   }
  }
  if (!strcmp ((string)ScanString(cmd,3),"picture"))
   {
    asm { push ax ; xor ax,ax ; int 0x16 ; pop ax };
    set_mode (3);
   }
  ConsoleWriteString ("\n\rcluster(s) used: ");
  ConsoleWriteDword (total_size);
  ConsoleWriteString (" (= ");
  ConsoleWriteDword (total_size*512);
  ConsoleWriteString (" bytes)");
 }

 if (!strcmp ((string)ScanString(cmd,1),"chain"))
  {
   quit = 0;
   d = 1;
   drive = 1;
   e = 0;
   total_size = 0;
   fcb_dir (18,&cluster_buffer);
   b = (ulong)(cluster_buffer[0].f_size+1);
   ConsoleWriteDword (b);
   c = 1;
   for (a=18; (!quit) ; a++)
   {
    fcb_dir (a,&cluster_buffer);
    for (; c <= 15; c++)
    {
     if (cluster_buffer[c].f_name [0] != 0)
     {
      if (d==b) { quit = 1; break; }
      d++;
      e++;
      ConsoleWriteString ("\n\rfcb      : ");
       ConsoleWriteDword ( ((a-18) << 4) + c );
      ConsoleWriteString ("\n\rname     : ");
       ConsoleWriteString (cluster_buffer [c].f_name);
      ConsoleWriteString ("\n\rsize     : ");
      if (cluster_buffer [c].f_attr != 0xa) total_size += cluster_buffer [c].f_size;
       ConsoleWriteDword (cluster_buffer [c].f_size);
      ConsoleWriteString ("\n\rdate     : ");
       ConsoleWriteDword ((ulong)cluster_buffer [c].f_month);
	ConsoleWriteChar ('/');
       ConsoleWriteDword ((ulong)cluster_buffer [c].f_day);
	ConsoleWriteChar ('/');
       ConsoleWriteDword ((ulong)cluster_buffer [c].f_year);
      ConsoleWriteString ("\n\rtime     : ");
       ConsoleWriteDword ((ulong)cluster_buffer [c].f_hour);
	ConsoleWriteChar (':');
       ConsoleWriteDword ((ulong)cluster_buffer [c].f_min);
      ConsoleWriteString ("\n\rattribut : ");
       if (cluster_buffer [c].f_attr == 0xa)
	ConsoleWriteString ("dir");
       if (cluster_buffer [c].f_attr == 0xb)
	ConsoleWriteString ("archive");
       if (cluster_buffer [c].f_attr == 0xc)
	ConsoleWriteString ("executable");
       if (cluster_buffer [c].f_attr == 0xd)
	ConsoleWriteString ("script");
      ConsoleWriteString ("\n\rcluster  : ");
       ConsoleWriteDword (cluster_buffer [c].f_cluster);
      ConsoleWriteString ("\n\r컴컴컴컴컴컴컴컴�");
      if (e == 3) { ConsoleWriteString ("\n\rpess a key");
		    e = 0;
		    asm { push ax ; xor ax,ax ; int 0x16 ; pop ax };
		  }
     }
    }
    c = 0;
   }
   ConsoleWriteString ("\n\r *** total bytes: ");
   ConsoleWriteDword (total_size);
  }

 if (!strcmp ((string)ScanString(cmd,1),"exit")) break;

 }
}
