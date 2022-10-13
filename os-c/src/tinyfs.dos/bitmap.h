/*
 * include/sys/i386/fs/tinyfs/bitmap.h
 *
 * created: 08/19/99
 * modified: 08/19/99
 *
 */

 #define INCLUDE_SYS_I386_FS_TINYFS_BITMAP.H    1
 #define        BITMAP_ADDR_START       219
 #define        CLUSTER_SIZE            512


 uchar bitmap [512];
 ulong cache=0;

 ulong get_cluster_free (uchar d)
 {
  ulong temp;
  ulong b;
  ulong a;
  for (temp=BITMAP_ADDR_START;temp<=BITMAP_ADDR_START+(disk_state.bitmap_size>>9);temp++)
  {
   if (cache==temp);
   else if (absolute_disk_access (d,DISK_READ,1,temp,FP_SEG(bitmap),(uint)&bitmap)) return 0;
   cache = temp;
   for (b=0;b<=512-1;b++)
    for (a=0;a<=7;a++)
     {
      if ( (bitmap[b]&(1<<a)) != (1<<a) ) return (((temp-BITMAP_ADDR_START)<<12)+(b<<3)+a+1);
     }
  }
  return 0;
 }                                                 

 bool set_cluster (uchar d, ulong cluster, uchar state)
 {
  ulong dummy;
  if (absolute_disk_access (d,DISK_READ,1,((cluster-1)>>12)+BITMAP_ADDR_START,FP_SEG(bitmap),(uint)&bitmap)) return 0;
   dummy = ((cluster-1)%(512*8));

   /*
   printf ("\nCLUSTER [%d]",cluster);
   printf ("\n * dummy:  %u",dummy);
   printf ("\n * sector: %u",((cluster-1)>>12)+BITMAP_ADDR_START);
   printf ("\n * byte:   %u",((dummy)>>3));
   printf ("\n * bit:    %u\n",(1<<(dummy % 8)));
   */

   if (state) bitmap [(dummy>>3) ] |= (1<<((dummy % 8)));
   else  bitmap [(dummy>>3)] &= (0xff ^ (1<<(dummy % 8)));
  if (absolute_disk_access (d,DISK_WRITE,1,((cluster-1)>>12)+BITMAP_ADDR_START,FP_SEG(bitmap),(uint)&bitmap)) return 0;
 }
