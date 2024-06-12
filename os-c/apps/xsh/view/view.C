#include "quickwin.h"
#include "file.h"

#define BUTTON_ID1 1

HWND FormWnd; 

void far WinMain (void)
{
 FuncEntry
          
  if (WM_MESSAGE == WINDOW_DESTROY)
  {
   close
  }

 FuncEnd
}

void StartProgram ()
{
 FormWnd = CreateWindow (155,300,350,250,"Sample",&WinMain);
 
}

