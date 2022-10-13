
struct disk_state
{
 unsigned int cyl;
 unsigned char head;
 unsigned char sector;
 unsigned long max_addr;
 unsigned long bitmap_size;
 unsigned char drive;
};

void get_disk_state (struct disk_state* diskstate)
{
 asm {
        push    ax
        push    si
        push    ds
        mov     ax,cs
        mov     ds,ax
        mov     si,diskstate
        mov     ah,0xa
        int      0x44
        pop     ds
        pop     si
        pop     ax
     }
}

unsigned char change_disk (unsigned char dr)
{
 asm {
        push ax
        mov ah,6
        mov al,dr
        int 44h
        pop ax
     }
}
