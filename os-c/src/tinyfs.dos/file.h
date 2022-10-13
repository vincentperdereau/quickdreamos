/*
 *
 *
 *
 *
 *
 */

 #define INCLUDE_SYS_I386_FS_TINYFS_FILE_H      1

 ulong f_create (string s)
 {
  ulong handle;
  ulong tempDRIVE;

  //struct file_control_block tempFCB;

  if ( !valid_name ( extract_filename (s) ) ) return 0;
  tempDRIVE = DRIVE;
  path (s);
  handle = create ( extract_filename (s), F_ARCH, DRIVE, path (s) );
  handle = (handle<<1);

  if (DRIVE==diskA);
  if (DRIVE==diskC) handle |= 1; 

  DRIVE = tempDRIVE;

  return handle; /*fcluster;*/
 }


 ulong f_open (string s)
 {
  ulong handle;
  ulong tempDRIVE;
  struct file_control_block tempFCB;

  tempDRIVE = DRIVE;
  path (s);
  handle = get_fcb (DRIVE,extract_filename (s),F_ARCH,path (s),&tempFCB);
  printf ("\n%s\n",extract_filename (s));

  handle = (handle<<1);
  if (DRIVE==diskA);
  if (DRIVE==diskC) handle |= 1;

  DRIVE = tempDRIVE;

  return handle;
 }

 ulong f_size (ulong handle)
 {
  ulong tempDRIVE;
  struct file_control_block tempFCB;

  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);

  if (!read_fcb (tempDRIVE,handle,&tempFCB)) return 0;
  return (tempFCB.f_size);
 }


 bool f_read (ulong handle, ulong size, uint seg, uint ofs)
 {
  ulong w_cluster;
  ulong tempDRIVE;
  struct file_control_block tempFCB;
  ulong i=0;

  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);

  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return 0;
  w_cluster = tempFCB.f_cluster;

  do {

      if (absolute_disk_access (tempDRIVE,DISK_READ,1,w_cluster+BITMAP_ADDR_START+(disk_state.bitmap_size>>9),FP_SEG(fcb),(uint)&fcb)) return 0;
      if (size > (CLUSTER_SIZE-4) )
	   memcpy ((void*)(ofs+i),&fcb,CLUSTER_SIZE-4);
      else  {
	     memcpy ((void*)(ofs+i),&fcb,size);
	     break;
	    }
      w_cluster = fcb [FCB_PER_SECTOR-1].f_cluster;

      printf ("\nw_cluster: %d",w_cluster);

      if (fcb [FCB_PER_SECTOR-1].f_cluster == 0xffffffff) break;
      size -= CLUSTER_SIZE -4;
      i += CLUSTER_SIZE -4;

     } while (1);
  return 1;
 }

 bool f_remove (ulong handle)
 {
  ulong w_cluster;
  ulong tempDRIVE;
  struct file_control_block tempFCB;

  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);

  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return 0;
  w_cluster = tempFCB.f_cluster;

  set_cluster (tempDRIVE,w_cluster,0);

  tempFCB.f_name [0] = 0;
  set_fcb (tempDRIVE,handle,&tempFCB);

  do {
      if (absolute_disk_access (tempDRIVE,DISK_READ,1,w_cluster+BITMAP_ADDR_START+(disk_state.bitmap_size>>9),FP_SEG(fcb),(uint)&fcb)) return 0;
      if (fcb[FCB_PER_SECTOR-1].f_cluster == 0xffffffff) break;
      w_cluster = fcb[FCB_PER_SECTOR-1].f_cluster;
      set_cluster (tempDRIVE,w_cluster,0);

     } while (1);
  dec_fcb_count (tempDRIVE);
  return 1;
 }

 bool f_write (ulong handle, ulong size, uint seg, uint ofs)
 {
  ulong w_cluster;
  ulong tempDRIVE;
  struct file_control_block tempFCB;
  ulong i=0;

  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);

  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return 0;
  w_cluster = tempFCB.f_cluster;
  tempFCB.f_size = size;
  if (!set_fcb (tempDRIVE,handle,&tempFCB) ) return 0;

  set_cluster (tempDRIVE,w_cluster,1);

  do {

/* !! */
      memcpy (&fcb,(void*)(ofs+i),CLUSTER_SIZE-4);
      i += CLUSTER_SIZE-4;

      set_cluster (tempDRIVE,w_cluster,1);
      if ( i >= size) fcb[FCB_PER_SECTOR-1].f_cluster = 0xffffffff;
      else {
	     fcb[FCB_PER_SECTOR-1].f_cluster = get_cluster_free (tempDRIVE);
	     if (!fcb[FCB_PER_SECTOR-1].f_cluster) return 0;

	   }
      printf ("\ncluster: %d",w_cluster);

      if (absolute_disk_access (tempDRIVE,DISK_WRITE,1,w_cluster+BITMAP_ADDR_START+(disk_state.bitmap_size>>9),FP_SEG(fcb),(uint)&fcb)) return 0;
      printf ("\nsector: %u",w_cluster+BITMAP_ADDR_START+(disk_state.bitmap_size>>9));

      w_cluster = fcb[FCB_PER_SECTOR-1].f_cluster;
      if ( i >= size ) break;

     } while (1);

  return 1;
 }
