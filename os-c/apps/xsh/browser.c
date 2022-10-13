#include "quickwin.h"

HWND BrowserWindow;

#define GO      01

void far WinMain (void)
{
 FuncEntry

  if (WM_MESSAGE == WINDOW_DESTROY)
   close
  if (WM_MESSAGE == CONTROL_BUTTON)
  {
   if (WM_PARAM == GO)
   {

   }
  }

 FuncEnd
}

void StartProgram ()
{
 BrowserWindow = CreateWindow ( 640-(300/2),120,300,200,"Browser",&WinMain);

}
