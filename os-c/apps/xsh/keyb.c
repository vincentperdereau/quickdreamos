#include "quickwin.h"

#define FRENCH          0x00
#define US              0x01        
#define BRITISH         0x02
#define GERMAN          0x03

#define CANCEL          0x02
#define OK              0x01

HWND MyWindow;
CONTROL MyControl;

void far WinMain (void)
{
 FuncEntry

  if (WM_MESSAGE == WINDOW_DESTROY)
   close
  if (WM_MESSAGE == CONTROL_BUTTON)
  {
   if (WM_PARAM == OK)
   {
    CommandTerm ("cd /lib/kbd",0);
    CommandTerm ("rm keymap",0);
   if (MyControl->word1 == FRENCH)
    CommandTerm ("cp fr.map k",0);
   if (MyControl->word1 == US)
    CommandTerm ("cp us.map k",0);
   if (MyControl->word1 == BRITISH)
    CommandTerm ("cp br.map k",0);
   if (MyControl->word1 == GERMAN)
    CommandTerm ("cp gr.map kp",0);
   CommandTerm ("cp k keymap",0);
   CommandTerm ("rm k",0);
   }
   if (WM_PARAM == CANCEL)
   {
   // DestroyWindow (MyWindow);
   }

  }

 FuncEnd
}

char Cycler [] = "French\0US\0British\0German";
char ButtonOK [] = "OK";
char ButtonCancel [] = "Cancel";

void StartProgram ()
{
 MyWindow = CreateWindow (100,100,200,100,"Keyboard",&WinMain);
 MyControl = CreateControl (10,20,135,18,MyWindow,FRENCH,CONTROL_TYPE_CYCLER,_CS,(unsigned int)Cycler,4);

 CreateControl (10,45,65,20,MyWindow,OK,CONTROL_TYPE_BUTTON,_CS,(unsigned int)ButtonOK,0);
 CreateControl (80,45,65,20,MyWindow,CANCEL,CONTROL_TYPE_BUTTON,_CS,(unsigned int)ButtonCancel,0);
 OutTextXY (10,2,"Choose a keyboard:",MyWindow);
 ShowIcon (160,25,"/qwin/keyb.ico",MyWindow);
}
