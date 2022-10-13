/*
 * quick/src/kernel/modules/sys/fs/tinyfs/bitmap.c
 *
 * gestion de la bitmap
 */

 #include <typedef.h>
 #include <sys/fs/tinyfs/tinyfs.h>

 UCHAR bitmap [512]; // un secteur tampon
 ULONG cache=0;

 /*
  * get_cluster_free (): recherche un secteur de donn‚es libre pour
  * le lecteur 'd'
  */
 ULONG get_cluster_free (UCHAR d)
 {
  ULONG temp;
  ULONG b;
  ULONG a;
  ULONG maxaddr;
  ULONG i=0;

  // On d‚termine l'adresse maximale du bitmap
  maxaddr = (bitmap_size (d) << 3) - BITMAP_ADDR_START;
  // On regarde...
  for (temp=BITMAP_ADDR_START;temp<=BITMAP_ADDR_START+(bitmap_size (d)>>9);temp++)
  {
   if (cache==temp);
   else if (absolute_disk_access (d,DISK_READ,1,temp,KERNEL_SEG,(UINT)&bitmap)) return ERROR;
   cache = temp;
   for (b=0;b<=512-1;b++)
    for (a=0;a<=7;a++)
     {
      i++;
      if (i == maxaddr) return 0;
      // Bit eteint ?? si oui => renvoie l'adresse du secteur de donn‚es
      if ( (bitmap[b]&(1<<a)) != (1<<a) ) return (((temp-BITMAP_ADDR_START)<<12)+(b<<3)+a+1);
     }
  }
  return ERROR;
 }                                                 

/*
 * set_cluster (): d‚finit l'‚tat d'un secteur (occup‚/libre)
 *
 */

 BOOL set_cluster (UCHAR d, ULONG cluster, UCHAR state)
 {
  ULONG dummy;
  if (absolute_disk_access (d,DISK_READ,1,((cluster-1)>>12)+BITMAP_ADDR_START,KERNEL_SEG,(UINT)&bitmap)) return ERROR;
   dummy = ((cluster-1)%(512*8));
   // On fixe le bit comme d‚sir‚.
   if (state) bitmap [(dummy>>3) ] |= (1<<((dummy % 8)));
   else  bitmap [(dummy>>3)] &= (0xff ^ (1<<(dummy % 8)));
  if (absolute_disk_access (d,DISK_WRITE,1,((cluster-1)>>12)+BITMAP_ADDR_START,KERNEL_SEG,(UINT)&bitmap)) return ERROR;
  return OK;
 }
