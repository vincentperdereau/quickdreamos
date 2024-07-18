unsigned long save_area (int x, int y, int w, int h);
void restore_area (int x, int y, int w,int h,unsigned long ret, char rel);
void displayChar(char sch);
HWND CreateWindow (int x, int y, int w, int h, char color, char* title);
void DestroyWindow (HWND dmWnd);
void SwitchWindow (HWND vhWnd);

HWND hWndSh;

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

int shX = 25, shY = 30;
int ix = 25,  iy = 30;
int wx = 8,  wy = 10;
int delta;
char shc;
int exiting = 0;

void interrupt int29 (void)
{    
 _BL = _AL;
 _DS = _CS;
 shc = _BL;

 if (shc == ((char)1)) 
 {
    DestroyWindow(hWndSh);
    exiting = 1;
    return;
 }

 if (shX < ((64*8)+ix-8)) PrintChar ('_',shX,shY,0,255,0);
 switch (shc)
 {
  case 13: shX = ix;
	   break;
  case 10: if (shY == (iy+ 12 *16)) break;
	   shY += 16;
	   break;
  case 8:  if (shX == ix) {SetColor (3);Bar (shX,shY,shX+8,shY+16); break; };
	   shX = shX - 8;
	   SetColor (0);
	   Bar (shX,shY,shX+8,shY+16);
	   PrintChar ('_',shX,shY,7,255,0);
	   break;
  default:
       displayChar(shc);
 }
 
}

void displayChar(char sch) 
{
    if (shY >= (iy+ 11 *16))
    {
     scroll_up (ix-2,iy+16,65*8+8, 12*16-2 , 16);
     shY -= 16;
    }
    if (shX == ((64*8)+ix)) { shX = ix; shY += 16; };
    PrintChar (shc,shX,shY,7,255,0);
    shX = shX + 8;
    if (shX < ((64*8)+ix-8)) PrintChar ('_',shX,shY,7,255,0);
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

#define WM_MESSAGE      SysBuf.byte1
#define WM_PARAM        SysBuf.byte2

#define KEYB_CLICK 0xA1

static unsigned int DataSegmentSh;

#define FuncEntry asm { cli }; asm { pusha }; _AX = _DS; _BX = _CS; _DS = _BX; DataSegmentSh = _AX;
#define FuncEnd _AX = DataSegmentSh; _DS = _AX; asm { popa }; asm { sti }; asm { retf };

int far (*shell) (char first) ;

unsigned int keysh;

void far WinMainSh (void)
{
 FuncEntry

  if (WM_MESSAGE == WINDOW_DESTROY)
  {
     shX = 25; shY = 30;
     ix = 25;  iy = 30;
     wx = 8;  wy = 10;
     
     asm {
       mov ah,5
       int 0x46
     }
  }
  
  if (WM_MESSAGE == KEYB_CLICK)
  {
   _DS = _CS;              
   keysh = SysBuf.word1;
   
   if ((char)keysh != 8)
   {
       ix = ix + (hWndSh->x - wx) - delta;
       iy = iy + (hWndSh->y - wy);
       shX = shX + (hWndSh->x - wx) - delta;
       shY = shY + (hWndSh->y - wy);
       
       wx = hWndSh->x;
       wy = hWndSh->y;
       delta = (hWndSh->x - wx);
       
       exiting = 0;
       shell ((char)keysh);
        _DS = _CS;

       if ( (hWndSh != topWnd) && (!exiting) )
       {
          SwitchWindow(hWndSh);
       }   
       if (!exiting)
       {
          shell ((char)2);
          _DS = _CS;
       }
    }
  }


 FuncEnd
}

void console (void)
{
 unsigned long mbuf;

 hidemouse ();
 //mbuf = save_area (8,8,66*8,15*16+3);
 shX = 15;
 shY = 30;
 BGWindow = 0;
 //Window (8,10,65*8,15*16-1,3,"shell");
 hWndSh = CreateWindow (wx,wy,65*8,15*16-1,3,"Shell");
 delta = (hWndSh->x - wx);

 ix = ix + (hWndSh->x - wx) - delta;
 iy = iy + (hWndSh->y - wy);
 shX = shX + (hWndSh->x - wx);
 shY = shY + (hWndSh->y - wy);

 hWndSh->WinMain = (void far*) (_CS * 65536 + (unsigned int)&WinMainSh);
 SetColor (0);
 //fastbar (16,27,65*8,15*16+5);
 set_int_29 ();
 shell = get_shell();
 setFont (0);
 exiting = 0;
 shell ((char)2);
  _DS = _CS;
 setFont (0);
/*
 restore_area (8,8,66*8,15*16+3,mbuf,1);
*/
 showmouse ();
}
    
