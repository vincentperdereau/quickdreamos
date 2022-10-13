#include "quickwin.h"

#define RED_PLUS         0x01
#define GREEN_PLUS       0x02
#define BLUE_PLUS        0x03
#define RED_LESS         0x04
#define GREEN_LESS       0x05
#define BLUE_LESS        0x06
#define SAVE             0x07
#define WIN              0x08
#define BACKGROUND       0x09

 typedef         unsigned long   handle;

 handle fopen (char* fname)
 {
  asm {
        push    si
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     ah,0x0002
        mov     si,fname
        int     0x44
        mov     edx,eax
        shr     edx,16
        pop     ds
        pop     si
      }
 }

 int fread (handle h,long count,void* buffer,unsigned int segm)
 {
  asm {
        push    es
        push    di
        push    ecx
        push    edx
        mov     ax,segm
        mov     es,ax
        mov     di,buffer
        mov     ecx,count
        mov     edx,h
        mov     ah,0x0004
        int     0x44
        pop     edx
        pop     ecx
        pop     di
        pop     es
      }
 }

 int fwrite (handle h,long count,void* buffer,unsigned int segm)
 {
  asm {
	push    ds
	push    si
	push    ecx
	push    edx
	mov     ax,segm
	mov     ds,ax
	mov     si,buffer
	mov     ecx,count
	mov     edx,h
	mov     ah,0x0005
	int     0x44
        pop     edx
        pop     ecx
        pop     si
        pop     ds
      }
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

handle palfile;

unsigned char Pal [8];
unsigned char Obj;

HWND MyWindow;

void far WinMain (void)
{
 FuncEntry

  if (WM_MESSAGE == WINDOW_DESTROY)
   close
  if (WM_MESSAGE == CONTROL_BUTTON)
  {
   switch (WM_PARAM)
   {
    case RED_PLUS: ( Obj == 1 ) ? Pal[0] ++ : Pal[3]++ ; break;
    case RED_LESS: ( Obj == 1 ) ? Pal[0] -- : Pal[3]-- ; break;
    case GREEN_PLUS: ( Obj == 1 ) ? Pal[1] ++ : Pal[4]++ ; break;
    case GREEN_LESS: ( Obj == 1 ) ? Pal[1] -- : Pal[4]-- ; break;
    case BLUE_PLUS: ( Obj == 1 ) ? Pal[2] ++ : Pal[5]++ ; break;
    case BLUE_LESS: ( Obj == 1 ) ? Pal[2] -- : Pal[5]-- ; break;
    case WIN:  Obj = 3; break;
    case BACKGROUND: Obj = 1; break;
    case SAVE:
     fwrite (palfile,8,&Pal,_CS);
     DestroyWindow (MyWindow);
     close
   }
  SetRGB (1,Pal[0],Pal[1],Pal[2]);
  SetRGB (3,Pal[3],Pal[4],Pal[5]);
  }

 FuncEnd
}

char Plus [] = "+";
char Less [] = "-";
char Window [] = "Window";
char Desktop [] = "Desktop";
char Save [] = "Save";

void StartProgram ()
{
 MyWindow = CreateWindow (150,150,240,95,"Colors",&WinMain);
 Obj = 1;

 OutTextXY (10,35,"Red",MyWindow);
 OutTextXY (50+20,35,"Green",MyWindow);
 OutTextXY (90+40,35,"Blue",MyWindow);

 CreateControl (10,50,15,15,MyWindow,RED_PLUS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Plus,0);
 CreateControl (25,50,15,15,MyWindow,RED_LESS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Less,0);                                    

 CreateControl (50+20,50,15,15,MyWindow,GREEN_PLUS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Plus,0);
 CreateControl (65+20,50,15,15,MyWindow,GREEN_LESS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Less,0);

 CreateControl (90+40,50,15,15,MyWindow,BLUE_PLUS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Plus,0);
 CreateControl (105+40,50,15,15,MyWindow,BLUE_LESS,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Less,0);                                    

 CreateControl (10,10,80,20,MyWindow,WIN,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Window,0);
 CreateControl (90,10,80,20,MyWindow,BACKGROUND,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Desktop,0);
 CreateControl (190,10,40,20,MyWindow,SAVE,CONTROL_TYPE_BUTTON,_CS,(unsigned int)Save,0);

 ShowIcon (195,38,"/qwin/color.ico",MyWindow);

 palfile = fopen ("/qwin/win.pal");
 fread (palfile,8,&Pal,_CS);

}
