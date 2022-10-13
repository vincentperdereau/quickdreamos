#include "quickwin.h"

HWND MyWindow;

#define BUTTON_01  1
#define BUTTON_02  2
#define BUTTON_03  3
#define BUTTON_04  4
#define BUTTON_05  5

char exec (char* prog,unsigned int segArg,unsigned int ofsArg)
 {
  asm {
       push     ds
       push     si
       mov      ax,0x0601
       int      0x46
       mov      ax,cs
       mov      ds,ax
       mov      ax,segArg
       mov      es,ax
       mov      bx,ofsArg
       mov      ah,0x0014
       mov      si,prog
       int      0x44
       pop      si
       pop      ds
      }
  }


void far WinMain (void)
{
 FuncEntry

 FuncEnd
}

static char b0 [] = "";

void StartProgram ()
{
 MyWindow = CreateWindow (640-60,10,40,200,"",&WinMain);
 ProtectWindow (MyWindow);
 SetColor (7);
 Bar (640-60,10,640-60+40+10,200+10);
 SetColor (0);
 Rectangle (640-60,10,640-60+40+10,200+10);
 Rectangle (640-60+1,0+1+10,640-60+40+10,200+10+1);

 CreateControl (0,0  ,34,34,MyWindow,BUTTON_01,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
 CreateControl (0,35 ,34,34,MyWindow,BUTTON_02,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
 CreateControl (0,70 ,34,34,MyWindow,BUTTON_03,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
 CreateControl (0,105,34,34,MyWindow,BUTTON_04,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
 CreateControl (0,140,34,34,MyWindow,BUTTON_05,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);

 ShowIcon (2,  0+2,"/qwin/eye.ico",MyWindow);
 ShowIcon (2, 35+2,"/qwin/eye.ico",MyWindow);
 ShowIcon (2, 70+2,"/qwin/eye.ico",MyWindow);
 ShowIcon (2,105+2,"/qwin/eye.ico",MyWindow);
 ShowIcon (2,140+2,"/qwin/eye.ico",MyWindow);
}

/*
  About, Execute, Terminal, Shutdown, Clean
*/

