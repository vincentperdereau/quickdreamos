/*
 * include/sys/fs/tinyfs/fcb2.h
 *
 *
 */


 ULONG get_fcb_free (UCHAR d);

 BOOL set_fcb (UCHAR d,ULONG fcb_addr,struct file_control_block *FCB);

 BOOL read_fcb (UCHAR d,ULONG fcb_addr,struct file_control_block *FCB);

 ULONG get_fcb_count (UCHAR d);

 BOOL inc_fcb_count (UCHAR d);

 BOOL dec_fcb_count (UCHAR d);

 ULONG get_fcb (UCHAR d,
		STRING fname,
		UCHAR attr,
		ULONG dir_father,
                struct file_control_block *FCB);
