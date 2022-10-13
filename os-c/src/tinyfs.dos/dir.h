/*
 * include/sys/i386/fs/tinyfs/dir.h
 *
 * created:
 * modified:
 *
 */

 #define INCLUDE_SYS_I386_FS_TINYFS_DIR_H       1

 bool mkdir (string dir)
 {
  bool ret;
  ulong dir_father;
  ulong tempDRIVE;

  if (!valid_name (extract_filename (dir))) return 0;
  tempDRIVE = DRIVE;
  dir_father = path (dir);
  DRIVE = tempDRIVE;
  if (dir_father == 0xffffffff) return 0;
  ret = create (extract_filename (dir),F_DIR,tempDRIVE,dir_father);
  return ret;
 }


 bool rmdir (string dir)
 {
  ulong dir_father;
  ulong tempDRIVE;
  ulong addr;
  struct file_control_block tempFCB;

  tempDRIVE = DRIVE;
  dir_father = path (dir);
  DRIVE = tempDRIVE;
  if (dir_father == 0xffffffff) return 0;
  addr = get_fcb (tempDRIVE,extract_filename (dir),F_DIR,dir_father,&tempFCB);
  if (!addr) return 0;
  tempFCB.f_name [0] = 0;
  if (!set_fcb (tempDRIVE,addr,&tempFCB)) return 0;
  return 1;

 }
