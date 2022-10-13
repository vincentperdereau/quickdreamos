#include "quickwin.h"

HWND MyWindow;

static int in_isr;

#define BUTTON_REBOOT 1
#define BUTTON_HALT   2
#define BUTTON_BACK   3

void far WinMain (void)
{
 FuncEntry
  if (WM_MESSAGE == WINDOW_DESTROY)
  {
   in_isr = 0;
  }
  if (WM_MESSAGE == CONTROL_BUTTON)
  {
   if (WM_PARAM == BUTTON_REBOOT)
   {
    asm {
          db 0xea
          dw 0x0000
          dw 0xffff
        }
   }
   if (WM_PARAM == BUTTON_HALT)
   {
    CommandTerm ("halt",0);
    ExitWindows ();
   }

   if (WM_PARAM == BUTTON_BACK)
   {
    DestroyWindow (MyWindow);
   }

  }
 FuncEnd
}


char bReboot [] = "reboot";
char bHalt   [] = "halt";
char bBack   [] = "back";

void ctrlaltdel (void)
{
 asm { push ax bx cx dx ds };
 asm { mov ax,cs
       mov ds,ax }
 if (!in_isr)
 {
  in_isr = 1;
  MyWindow = CreateWindow (120,120,340,70,"Shutdown system",&WinMain);
  CreateControl (10,10,100,25,MyWindow,BUTTON_REBOOT,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bReboot,0);
  CreateControl (115,10,100,25,MyWindow,BUTTON_HALT,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bHalt,0);
  CreateControl (220,10,100,25,MyWindow,BUTTON_BACK,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bBack,0);
 }
 asm { pop ds dx cx bx ax };
 asm { iret };
}

void intr (void* funcptr, char intc)
{
 asm {
	push ax
	push bx
	push es
        xor ax,ax    
	mov es,ax
	xor bh,bh
	mov bl,intc
        shl bx,2             
	mov ax,funcptr
        mov es:[bx],ax   
        mov ax,cs
        mov word ptr es:[bx+2],ax
        pop es
        pop bx
        pop ax
       }
}


void StartProgram ()
{
 in_isr = 0;
 intr ((void*)&ctrlaltdel,0x28);
}
