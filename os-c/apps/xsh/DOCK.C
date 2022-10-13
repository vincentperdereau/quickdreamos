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

 if (WM_MESSAGE == CONTROL_BUTTON)
 { 
  if (WM_PARAM == BUTTON_01)
  {
   FullShell ();
  }
  if (WM_PARAM == BUTTON_02)
  {
   about ();
  }
  if (WM_PARAM == BUTTON_03)
  {
   exec ("/qwin/exec",0,0);
  }
  if (WM_PARAM == BUTTON_04)
  {
   mem ();
  }
  if (WM_PARAM == BUTTON_05)
  {
    halt ();
  }
 }

 FuncEnd
}

static char b0 [] = "";
static unsigned int maxx;

void StartProgram ()
{
 if (getmode () == 1)
 maxx = 640;
 else
 maxx = 800;
 
 MyWindow = CreateWindow (maxx-60,10,40,200,"",&WinMain);
 ProtectWindow (MyWindow);
 SetColor (7);
 Bar (maxx-60,10,maxx-60+40+10,200+10);
 SetColor (0);
 Rectangle (maxx-60,10,maxx-60+40+10,200+10);
 Rectangle (maxx-60+1,0+1+10,maxx-60+40+10,200+10+1);

 CreateControl (0,0  ,34,34,MyWindow,BUTTON_01,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
 CreateControl (0,35 ,34,34,MyWindow,BUTTON_02,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
 CreateControl (0,70 ,34,34,MyWindow,BUTTON_03,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
 CreateControl (0,105,34,34,MyWindow,BUTTON_04,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);
 CreateControl (0,140,34,34,MyWindow,BUTTON_05,CONTROL_TYPE_BUTTON,_CS,(unsigned int)b0,0);

 ShowIcon (2,  0+1,"/qwin/term.ico",MyWindow);
 ShowIcon (2, 35+1,"/qwin/eye.ico",MyWindow);
 ShowIcon (2, 70+1,"/qwin/exec.ico",MyWindow);
 ShowIcon (2,105+1,"/qwin/mem.ico",MyWindow);
 ShowIcon (1,140+1,"/qwin/shut.ico",MyWindow);
}

/*
  About, Execute, Terminal, Shutdown, Clean
*/

