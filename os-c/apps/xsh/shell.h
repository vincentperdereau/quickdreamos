unsigned long save_area (int x, int y, int w, int h);
void restore_area (int x, int y, int w,int h,unsigned long ret, char rel);

void far *get_shell (void)
{
 asm {
	push si
	push di
	mov ah,2
	int 0x46
	mov dx,si
	mov ax,di
	pop di
	pop si
     }
}

int shX = 15;
int shY = 30;
char shc;

void interrupt int29 (void)
{
 _BL = _AL;
 _DS = _CS;
 shc = _BL;

 if (shX < ((64*8)+15-8)) PrintChar ('_',shX,shY,0,255,0);
 switch (shc)
 {
  case 13: shX = 15;
	   break;
  case 10: if (shY == (30+ 12 *16)) break;
	   shY += 16;
	   break;
  case 8:  if (shX == 15) break;
	   shX = shX - 8;
	   SetColor (0);
	   Bar (shX,shY,shX+8,shY+16);
	   PrintChar ('_',shX,shY,7,255,0);
	   break;
  default:
	    if (shY >= (30+ 11 *16))
	    {
	     scroll_up (13,46,65*8+8, 12*16 , 16);
	     shY -= 16;
	    }
	    if (shX == ((64*8)+15)) { shX = 15; shY += 16; };
	    PrintChar (shc,shX,shY,7,255,0);
	    shX = shX + 8;
	    if (shX < ((64*8)+15-8)) PrintChar ('_',shX,shY,7,255,0);
 }


}

void set_int_29 (void)
{
 asm {
	push ax
	push bx
	push es
	mov ax,0
	mov es,ax
	mov ax,cs
	mov bx,offset int29
	mov es:[0x29 * 4],bx
	mov es:[0x29 * 4 +2],ax
	pop es
	pop bx
	pop ax
     }
}


void far (*shell) (void) ;

void console (void)
{
 unsigned long mbuf;

 hidemouse ();
 mbuf = save_area (8,8,66*8,15*16+3);
 shX = 15;
 shY = 30;
 BGWindow = 0;
 Window (8,10,65*8,15*16-1,3,"terminal");
 SetColor (0);
// fastbar (16,27,65*8,15*16+5);
 set_int_29 ();
 shell = get_shell();
 setFont (0);
 shell ();
  _DS = _CS;
 setFont (0);
  restore_area (8,8,66*8,15*16+3,mbuf,1);
 asm {
       mov ah,5
       int 0x46
    }
 showmouse ();
}
    
