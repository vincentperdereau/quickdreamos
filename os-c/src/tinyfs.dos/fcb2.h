/*
 * include/sys/i386/fs/tinyfs/fcb2.h
 *
 * created:
 * modified:
 *
 */

 #define INCLUDE_SYS_I386_FS_TINYFS_FCB2_H      1

 struct file_control_block fcb [FCB_PER_SECTOR];

 ulong get_fcb_free (uchar d)
 {
  ulong i;
  ulong j=1;

  for (i=FCB_ADDR_BEGIN;i <= FCB_ADDR_END; i++)
  {
   if (absolute_disk_access (d,DISK_READ,1,i,FP_SEG(fcb),(uint)&fcb)) return 0;
   {
    for (; j <= (FCB_PER_SECTOR-1); j++)
    {
     if (fcb[j].f_name[0]==0) return (((i-FCB_ADDR_BEGIN)<<4)+j+1);
    }
   j = 0;
   }
  }
  return 0;
 }

 bool set_fcb (uchar d,ulong fcb_addr,struct file_control_block *FCB)
 {
  ulong dummy;
  dummy = ((fcb_addr-1)>>4);
  if (absolute_disk_access (d,DISK_READ,1,dummy+FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;

  /* MEMCPY !!!! */
  memcpy ( & (fcb [fcb_addr - (dummy<<4) -1]), FCB, FCB_SIZE);

  if (absolute_disk_access (d,DISK_WRITE,1,dummy+FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
  return 1;
 }

 bool read_fcb (uchar d,ulong fcb_addr,struct file_control_block *FCB)
 {
  ulong dummy;
  dummy = ((fcb_addr-1)>>4);
  if (absolute_disk_access (d,DISK_READ,1,dummy+FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;

  /* MEMCPY !!!! */
  memcpy (FCB,& (fcb [fcb_addr - (dummy<<4) -1]), FCB_SIZE);
  return 1;
 }

 ulong get_fcb_count (uchar d)
 {
  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
  return (fcb[0].f_size+1);
 }

 bool inc_fcb_count (uchar d)
 {
  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
  fcb[0].f_size++;
  if (absolute_disk_access (d,DISK_WRITE,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
  return 1;
 }

 bool dec_fcb_count (uchar d)
 {
  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
  fcb[0].f_size--;
  if (absolute_disk_access (d,DISK_WRITE,1,FCB_ADDR_BEGIN,FP_SEG(fcb),(uint)&fcb)) return 0;
  return 1;
 }


 ulong get_fcb (uchar d,
	       string fname,
	       uchar attr,
	       ulong dir_father,
	       struct file_control_block *FCB)
 {
  ulong i,j;
  ulong fcb_count;
  ulong counter=0;

  fcb_count = get_fcb_count (d);
  j = 1;
  for (i=FCB_ADDR_BEGIN; i <= FCB_ADDR_END; i++)
  {
   if (absolute_disk_access (d,DISK_READ,1,i,FP_SEG(fcb),(uint)&fcb)) return 0;
   for (;j <= (FCB_PER_SECTOR-1); j++)
   {
    if ( (counter+1) == fcb_count ) return 0;
    if ( fcb[j].f_name [0] != 0) counter++;
    if (   (!strcmp (fname,fcb[j].f_name))
	&& (attr == fcb[j].f_attr)
	&& (dir_father == fcb[j].f_dir_father) )
	{
		memcpy (FCB, & (fcb [j]), FCB_SIZE);
		return (((i-FCB_ADDR_BEGIN)<<4)+j+1);
	}
   }
   j = 0;
  }
  return 0;
 }
