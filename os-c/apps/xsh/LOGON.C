#include "quickwin.h"

HWND MyWindow;

#define BUTTON_OK 0x01
#define BUTTON_HALT 0x02

CONTROL MyControl;

void far WinMain (void)
{
 FuncEntry

  if (WM_MESSAGE == WINDOW_DESTROY)
  {
   close
  }
  if (WM_MESSAGE == CONTROL_BUTTON)
   if (WM_PARAM == BUTTON_OK)
   {
    DestroyWindow (MyWindow);
   }
 FuncEnd
}


char bOk [] = "Ok";
char pwd [50] = {0,};
char user [50]= {0,};
unsigned int maxx;

void StartProgram ()
{
 maxx = ( getmode () == 1 ) ? 320 : 400;
 MyWindow = CreateWindow (maxx-150,240-55,300,110,"New session",&WinMain);
 ShowIcon (5,10,"/qwin/logon.ico",MyWindow);
 OutTextXY (50,15,"user:",MyWindow);
 OutTextXY (50,45-3,"password:",MyWindow);
 CreateControl (220,65,60,18,MyWindow,BUTTON_OK,CONTROL_TYPE_BUTTON,_CS,(unsigned int)bOk,0);
 CreateControl (130,50-10-3,150,20,MyWindow,0,CONTROL_TYPE_EDITBOX,_CS,(unsigned int)pwd,1);
 CreateControl (130,20-10,150,20,MyWindow,0,CONTROL_TYPE_EDITBOX,_CS,(unsigned int)user,0);
}
