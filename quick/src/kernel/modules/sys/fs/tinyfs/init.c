/*
 * modules/sys/fs/tinyfs/init.c
 *
 * Initialisation du disque.
 */

 #include <typedef.h>
 #include <sys/fs/tinyfs/tinyfs.h>

 #include <sys/disk/disks.h>
 extern struct s_disk_state disk_state;
 extern UCHAR DRIVE;

 BOOL init_disk (UCHAR d)
 {
  if (reset_disk(d)) return 1;
  disk_state.cyl = get_cyl (d) +1;
  disk_state.head = get_head (d) +1;
  disk_state.sector = get_sector (d);
  disk_state.max_addr = disk_state.cyl * disk_state.head * disk_state.sector -1;
  disk_state.bbitmap_size = ( (disk_state.max_addr-219) >>3) +1;
  if (!disk_state.max_addr) return 1;
  DRIVE = d; // lecteur en usage devient 'd'
  disk_state.drive = d;
  return 0;
 }

 ULONG  bitmap_size (UCHAR d)
 {
   return ( (((get_cyl(d)+1)* (get_head(d)+1) * get_sector(d) -219)>>3) +1);
 }
