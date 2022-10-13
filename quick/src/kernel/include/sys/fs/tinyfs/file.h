/*
 * include/sys/fs/tinyfs/file.h
 *
 *
 */


 ULONG f_create (STRING s);

 ULONG f_open (STRING s);

 ULONG f_size (ULONG handle);

 UCHAR f_attr (ULONG handle);

 UCHAR f_set_attr (ULONG handle, char fattr);

 BOOL f_read (ULONG handle, ULONG size, UINT seg, UINT ofs);

 BOOL f_remove (ULONG handle);

 BOOL f_write (ULONG handle, ULONG size, UINT seg, UINT ofs);
