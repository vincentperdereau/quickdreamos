/*
 * include/sys/fs/tinyfs/create.h
 *
 *
 */

   UCHAR nvread (char port);

   ULONG create (STRING fname,
                 UCHAR attr,
                 UCHAR d,
                 ULONG dir_father);

   BOOL valid_name (STRING name);
