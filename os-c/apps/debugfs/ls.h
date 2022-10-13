
 #define FCB_SIZE               32
 #define FCB_PER_SECTOR         16
 #define FCB_SECTORS            200
 #define FCB_ADDR_BEGIN         18
 #define FCB_ADDR_END           218

 struct file_control_block
 {
  char          f_name [12];
  ulong         f_size;
  ulong         f_dir_father;
  uchar         f_day;
  uchar         f_month;
  uint          f_year;
  uchar         f_hour;
  uchar         f_min;
  uchar         f_attr;
  uchar         f_unused;
  ulong         f_cluster;
 }; /* 32 bytes */

 unsigned long lastf=0;
 struct file_control_block cluster_buffer [16] = {0,};

 ulong get_fcb_count (void)
 {
  asm {
        mov ah,0x000b
        int 0x44
        mov edx,eax
        shr edx,16
      }
 }


 int fcb_dir (unsigned long cluster,void* buffer)
 {
  asm {
        push es
        push di
        push edx
        mov ax,cs
        mov es,ax
        mov di,buffer
        mov edx,cluster
        mov ah,0x9
        int 0x44
        mov ah,0
        pop edx
        pop di
        pop es
      }
 }


