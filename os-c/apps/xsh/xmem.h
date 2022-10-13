
unsigned int HiMemoryAvailable (void)
{
 asm {
  mov     al,17h
  out     70h,al      
  in      al,71h      
  mov     bl,al        
  mov     al,18h       
  out     70h,al       
  in      al,71h       
  mov     bh,al        
  mov     ax,bx        
 }
}

#define HiMemoryStart           0x400000   // changer GetHi... +2 ou +4
#define HiMemoryBlockFree       'Z'
#define HiMemoryBlockUsed       'V'
#define HiMemoryBlockLast       'P'

static unsigned long HiMemoryUsed;

static unsigned long TempSize;
static unsigned char Xflag;
static unsigned long BlockSize;

unsigned int GetHiMemoryAvail (void)
{
 return (HiMemoryAvailable()-HiMemoryUsed+4);
}

unsigned long HiMemoryAlloc (unsigned long size)
{
 unsigned long dummy;
 unsigned long HiMemoryEnd;

 dummy = HiMemoryStart;
 HiMemoryEnd = ((unsigned long)(HiMemoryAvailable ())) << 10 ;

 while ( dummy < HiMemoryEnd )
 {
  himem_read (dummy,_CS,(unsigned int)&Xflag,1); himem_read (dummy+1,_CS,(unsigned int)&BlockSize,4);

  if (Xflag == HiMemoryBlockFree)
  {
   if (BlockSize >= size)
   {
    Xflag = HiMemoryBlockUsed;
    himem_write (_CS,(unsigned int)&Xflag,dummy,1);
    TempSize = size;
    himem_write (_CS,(unsigned int)&TempSize,dummy+1,4);
    if (size != BlockSize)
    {
     TempSize = BlockSize - size; Xflag = HiMemoryBlockFree;
     himem_write (_CS,(unsigned int)&Xflag,dummy+size+5,1);
     himem_write (_CS,(unsigned int)&TempSize,dummy+size+5+1,4);
    }
   }
   return (dummy+5);
  }
  if (Xflag == HiMemoryBlockLast)
  {
   Xflag = HiMemoryBlockUsed;
   himem_write (_CS,(unsigned int)&Xflag,dummy,1);
   Xflag = HiMemoryBlockLast;
   himem_write (_CS,(unsigned int)&Xflag,dummy+BlockSize+5,1);
   TempSize = size;
   himem_write (_CS,(unsigned int)&TempSize,dummy+BlockSize+1+5,4);
   return (dummy+BlockSize+5+5);
  }
  dummy = dummy + BlockSize + 5;
 }
 OutTextXY (10,450,"ERROR HIMEM");
 return 0;
}

void HiMemoryFree (unsigned long para)
{
 unsigned long dummy;
 unsigned long HiMemoryEnd;
 unsigned long lastused;

 para = para - 5;

 dummy = HiMemoryStart;
 HiMemoryEnd = ( (unsigned long)(HiMemoryAvailable ()) << 10) ;

 himem_read (para,_CS,(unsigned int)&Xflag,1);
 if (Xflag == HiMemoryBlockUsed)
 {
  Xflag = HiMemoryBlockFree;
  himem_write (_CS,(unsigned int)&Xflag,para,1);
  return;
 }

 if (Xflag == HiMemoryBlockLast)
 {
  while ( dummy < HiMemoryEnd )
  {
   himem_read (dummy,_CS,(unsigned int)&Xflag,1); himem_read (dummy+1,_CS,(unsigned int)&BlockSize,4);
   if (Xflag == HiMemoryBlockUsed)
   {
    lastused = dummy;
   }
   if (Xflag == HiMemoryBlockLast)
   {
    break;
   }
   dummy = dummy + BlockSize + 5;
  }
 Xflag = HiMemoryBlockLast;
 himem_write (_CS,(unsigned int)&Xflag,lastused,1);
 Xflag = HiMemoryBlockFree;
 himem_write (_CS,(unsigned int)&Xflag,para,1);
 return;
 }
}

void HiMemoryInit (void)
{
 Xflag = HiMemoryBlockLast;
 TempSize = 1;
 himem_write (_CS,(unsigned int)&Xflag,HiMemoryStart,1);
 himem_write (_CS,(unsigned int)&TempSize,HiMemoryStart+1,4);
}
