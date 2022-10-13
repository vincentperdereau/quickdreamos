#include "quickwin.h"
#include "typedef.h"
#include "ls.h"
#include "disk.h"

HWND MyWindow;

void far WinMain (void)
{
 FuncEntry

  if (WM_MESSAGE == WINDOW_DESTROY)
  {
   close
  }
 FuncEnd
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

unsigned long i,j;
unsigned long diff;

unsigned char _drive;
unsigned long total_size;
unsigned long b,c,d,e;
int quit=0;
ulong total_size=0;
unsigned char bitmap[512];
unsigned int adr=0;
char S[2];

void StartProgram ()
{

 MyWindow = CreateWindow (120,120,180+50,40,"Disk size",&WinMain);
 SetColor (8);
 Bar (135,140,335,150);
 SetColor (9);

// *******************************************

 _drive = acdisk ();
 i = ((get_head (_drive)+1) * (get_cyl (_drive)+1) * (get_sector (_drive)) >> 11);
 i = i * 1024 * 1024 ;

 total_size = 0;
 e = (((get_head (_drive)+1) * (get_cyl (_drive)+1)*(get_sector (_drive))-219) >> 3);
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
    }
   adr++;
   }
  }
 }
 j = total_size * 512;

// *******************************************
 diff = (j * 50) / i;

 Bar (135,140, 135 + (unsigned int)diff,150);
 SetColor (0);
 S[0] = (_drive == 0x80) ? 'C' : 'A';
 S[1] = 0;
 OutTextXY (210,0,S,MyWindow);
 SetColor (7);

}
