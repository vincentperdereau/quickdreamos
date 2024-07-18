#include "quickwin.h"
#include "file.h"

HWND MyWindow;
unsigned int MySegment;

#define BUTTON_LOAD 0x01
#define BUTTON_SAVE 0x02

handle fichier;
char filename [30] = {0,};
CONTROL MyControl;

void ClearText (unsigned int SegText)
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

 handle fcreate (char* fname)
 {
  asm {
	push    si
	push    ds
	mov     ax,cs
	mov     ds,ax
	mov     ah,0x0003
	mov     si,fname
	int     0x44
	mov     edx,eax
	shr     edx,16
	pop     ds
	pop     si
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

 char fremove (handle h)
 {
  asm {
	push    edx
	mov     ah,0x000d
	mov     edx,h
	int     0x44
	pop     edx
      }
 }

char loaded = 0;

void far WinMain (void)
{
 FuncEntry

  if (WM_MESSAGE == WINDOW_DESTROY)
  {
   free (MySegment);
 //  CloseFullApp ();
   close
  }
  if (WM_MESSAGE == CONTROL_BUTTON)
   if (WM_PARAM == BUTTON_LOAD)
   {
    fichier = fopen (filename);
    if (fichier >= 2)
    {
     ClearText (MySegment);
     fread (fichier,fsize (fichier), 0, MySegment);
     UpdateTextArea (MyControl,(unsigned int)fsize (fichier));
     loaded = 1;
    }
   }
   if (WM_PARAM == BUTTON_SAVE)
   {
    if (loaded) fremove (fichier);
    fichier = fcreate (filename);
    if (fichier >= 2)
     fwrite (fichier,(unsigned long)SizeTextArea (MyControl),0,MySegment);
   }

 FuncEnd
}

char ButtonCaption [] = "exit";

char bSave [] = "save";
char bLoad [] = "load";

unsigned int d = 150;

void StartProgram ()
{
 //InitFullApp ();
 MyWindow = CreateWindow (0,0,605-d,410-d,"Notepad",&WinMain);
 MySegment = malloc (0xff0);
 ClearText (MySegment);
 MyControl = CreateControl (3,3,592-d,349-d,MyWindow,0,CONTROL_TYPE_TXTAREA,MySegment,0,0);
 CreateControl (8,360-d,200+100,20,MyWindow,0,CONTROL_TYPE_EDITBOX,_CS,(unsigned int)filename,0);
 CreateControl (210+100,360-d,40,20,MyWindow,BUTTON_SAVE,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bSave,0);
 CreateControl (252+100,360-d,40,20,MyWindow,BUTTON_LOAD,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bLoad,0);
 loaded = 0;
}
