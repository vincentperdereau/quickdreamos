/*
 * include/sys/i386/fs/tinyfs/init.h
 *
 * created:
 * modified:
 *
 */

 #define INCLUDE_SYS_I386_FS_TINYFS_INIT_H      1

 bool init_disk (uchar d)
 {
  if (reset_disk(d)) return 1;
  disk_state.cyl = get_cyl (d) +1;
  disk_state.head = get_head (d) +1;
  disk_state.sector = get_sector (d);
  disk_state.max_addr = disk_state.cyl * disk_state.head * disk_state.sector -1;
  disk_state.bitmap_size = (disk_state.max_addr >>3) +1;
  if (!disk_state.max_addr) return 1;
  DRIVE = d;
  return 0;
 }
