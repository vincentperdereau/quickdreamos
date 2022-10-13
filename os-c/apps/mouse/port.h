void init (void);

void main ()
{
 init ();
 asm { retf };
}

void outb (int port, unsigned char b)
{
 asm { push dx ; push ax ; mov dx,port ;
       mov al,b ;
       out dx,al ; pop ax ; pop dx } ;
}

unsigned char inb (int port)
{
 asm { push dx ; mov dx,port ; in al,dx ; pop dx }
}

