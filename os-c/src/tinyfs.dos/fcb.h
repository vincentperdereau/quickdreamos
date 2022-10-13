/*
 * include/sys/i386/fs/tinyfs/fcb.h
 *
 * created: 08/18/99
 * modified: 08/18/99
 *
 */

 #define INCLUDE_SYS_I386_FS_TINYFS_FCB_H       1

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
