void StartProgram (int argc, char **argv);
void Init (void);

void main (int argc, char **argv)
{
 Init ();
 StartProgram (argc, argv);
  asm {
       mov      ax,0x0601
       int      0x46
 }
}

#define CONTROL_TYPE_BUTTON  0x01
#define CONTROL_TYPE_EDITBOX 0x02
#define CONTROL_TYPE_TXTAREA 0x03
#define CONTROL_TYPE_CYCLER  0x04
#define CONTROL_EXEC         0xC0
#define CONTROL_BUTTON       0xC1
#define WINDOW_DESTROY       0xB0

#define MOUSE_CLICK 0xA0

#define WM_MESSAGE      SysBuf->byte1
#define WM_PARAM        SysBuf->byte2

static unsigned int DataSegment;

#define FuncEntry asm { cli }; asm { pusha }; _AX = _DS; _BX = _CS; _DS = _BX; DataSegment = _AX;
#define FuncEnd _AX = DataSegment; _DS = _AX; asm { popa }; asm { sti }; asm { retf };

struct SystemBuffer {
unsigned char function;
unsigned char byte1;
unsigned char byte2;
unsigned int word1;
unsigned int word2;
unsigned int word3;
unsigned int word4;
unsigned int word5;
unsigned int word6;
unsigned long dword1;
unsigned int word7;
} ;

typedef struct SystemBuffer SB;

SB far* SysBuf;




#define WManager      asm { int 0x48 }
#define close         free (_CS);  

struct hControl
{
 unsigned int x,y,w,h;
 unsigned char ControlType;
 unsigned char ControlID;
 unsigned int StrSegment;
 unsigned int StrOffset;
 void far* prev;
 unsigned int size;
 unsigned int word1;
 unsigned int word2;
 unsigned int word3;
};

typedef struct hControl far* CONTROL;

struct hWindow
{
 unsigned int x,y,w,h;
 unsigned long form;
 void far* prev;
 void far (*WinMain)(void);
 void far* FirstControl;
 void far* LastControl;
 void far* ActiveControl;
};

typedef struct hWindow far* HWND;

static dumWnd ;

HWND CreateWindow (int x, int y, int w, int h, char* title, void far (*WinMain) )
{
 SysBuf->function = 0x01;
 SysBuf->byte1 = 3;
 SysBuf->word1 = x;
 SysBuf->word2 = y;
 SysBuf->word3 = w;
 SysBuf->word4 = h,
 SysBuf->word5 = _CS;
 SysBuf->word6 = (unsigned int)title;
 WManager ;
 SysBuf->function = 0x02;
 SysBuf->word3 = _CS;
 SysBuf->word4 = (unsigned int)WinMain;
 WManager ;

 return (HWND)SysBuf->dword1;
}

CONTROL CreateControl (unsigned int x, unsigned int y, unsigned int w,
		       unsigned int h, HWND hWnd, unsigned char ID, unsigned char ControlType,
		       unsigned int CapSegment, unsigned int CapOffset, unsigned int size)
{
 SysBuf->function = 0x09;
 SysBuf->word1 = x;
 SysBuf->word2 = y;
 SysBuf->word3 = w;
 SysBuf->word4 = h;
 SysBuf->dword1 = (unsigned long) hWnd;
 SysBuf->byte1 = ID;
 SysBuf->byte2 = ControlType;
 SysBuf->word5 = CapSegment;
 SysBuf->word6 = CapOffset;
 SysBuf->word7 = size;
 WManager;
 return (CONTROL)SysBuf->dword1;
}

void DestroyWindow (HWND hWnd)
{
 SysBuf->function = 0x20;
 SysBuf->dword1 = (unsigned long)hWnd;
 WManager;
}

void ProtectWindow (HWND hWnd)
{
 SysBuf->function = 0x23;
 SysBuf->dword1 = (unsigned long)hWnd;
 WManager;
}


void OutTextXY (unsigned int x, unsigned int y, char* caption, HWND hWnd)
{
 SysBuf->function = 0x03;
 SysBuf->dword1 = (unsigned long)hWnd;
 SysBuf->word1 = x;
 SysBuf->word2 = y;
 SysBuf->word5 = _CS;
 SysBuf->word6 = (unsigned int)caption;
 WManager;
}

void CommandTerm (char* cmd, char scr)
{
 SysBuf->function = 0x18;
 SysBuf->word5 = _CS;
 SysBuf->word6 = (unsigned int)cmd;
 SysBuf->byte1 = scr;
 WManager;
}

void ExitWindows (void)
{
 SysBuf->function = 0x11;
 WManager;
}

void InitFullApp (void)
{
 SysBuf->function = 0x24;
 WManager;
}

void CloseFullApp (void)
{
 SysBuf->function = 0x25;
 WManager;
}

void mem (void)
{
 SysBuf->function = 0x29;
 WManager;
}

void halt (void)
{
 SysBuf->function = 0x28;
 WManager;
}

void about (void)
{
 SysBuf->function = 0x27;
 WManager;
}

void FullShell (void)
{
 SysBuf->function = 0x26;
 WManager;
}

void ShowIcon (unsigned int x, unsigned int y, char* fIcon, HWND hWnd)
{
 SysBuf->function = 0x19;
 SysBuf->word1 = x;
 SysBuf->word2 = y;
 SysBuf->word5 = _CS;
 SysBuf->word6 = (unsigned int)fIcon;
 SysBuf->dword1 = (unsigned long)hWnd;
 WManager;
}

void Bar (unsigned int x, unsigned int y, unsigned int w, unsigned int h)
{
 SysBuf->function = 0x14;
 SysBuf->word1 = x;
 SysBuf->word2 = y;
 SysBuf->word3 = w;
 SysBuf->word4 = h;
 WManager;
}

void Rectangle (unsigned int x, unsigned int y, unsigned int x2, unsigned int y2)
{
 SysBuf->function = 0x15;
 SysBuf->word1 = x;
 SysBuf->word2 = y;
 SysBuf->word3 = x2;
 SysBuf->word4 = y2;
 WManager;
}

void SetColor (unsigned char color)
{
 SysBuf->function = 0x05;
 SysBuf->byte1 = color;
 WManager;
}

void UpdateTextArea (CONTROL dumControl, unsigned int size)
{
 SysBuf->function = 0x21;
 SysBuf->word1 = size;
 SysBuf->dword1 = (unsigned long)dumControl;
 WManager;
}

unsigned char getmode (void)
{
 SysBuf->function = 0x30;
 WManager;
 return (SysBuf->byte1);
}

unsigned int SizeTextArea (CONTROL dumControl)
{
 SysBuf->function = 0x22;
 SysBuf->dword1 = (unsigned long)dumControl;
 WManager;
 return (SysBuf->word1);
}

unsigned int SysBufSegment;
unsigned int SysBufOffset;

void Init (void)
{
 asm {
     mov ah,4
     int 0x46
     mov cs:SysBufSegment,bx
     mov cs:SysBufOffset,cx
     }
 SysBuf = (SB far*) (SysBufSegment * 65536 + SysBufOffset);
}
