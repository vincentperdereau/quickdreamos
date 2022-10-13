/*
 *
 * 
 *
 *
 *
 */

 #define INCLUDE_SYS_I386_FS_TINYFS_PATH_H      1

 ulong  ACTUAL_DIR=0;

 // return dir_father cluster 

 // ex: s = a:/usr/bin/arch

 ulong path (string s)
 {
  uchar  i;
  uchar  j;
  char   Dir [12];
  ulong  tempDIR;
  struct file_control_block tempFCB;

  i=0;
  tempDIR = ACTUAL_DIR;

  if ( s [strlen(s)-1] == '/') s [strlen (s)-1] = 0;

  if (s[1] == ':') {
                    if (s[0]  == 'a') DRIVE =diskA;
                    else if (s[0] == 'c') DRIVE =diskC;
                    else return 0;
                    i = 2;
                    init_disk (DRIVE);
                   }
  if (s[i] == '/') {
                    tempDIR = 0;
                    i++;
                   }
  j = 0;
  do
  {
   if (s[i] == 0) break;

   if (s[i] == '/') { Dir [j] = 0;

                      if (!strcmp (Dir,".")) ;
                      else
                      if ( (!strcmp (Dir,".."))) if (!tempDIR);
                                                 else
                                                      {
                                                      if (!read_fcb (DRIVE,tempDIR,&tempFCB)) return 0xffffffff;
                                                      tempDIR = tempFCB.f_dir_father;
                                                      }
                      else {
                            tempDIR = get_fcb (DRIVE,Dir,F_DIR,tempDIR,&tempFCB);
                            if (!tempDIR) return 0xFFFFFFFF;
                           }

                      j=0; i++; }

   Dir [j] = s[i];
   i++;j++;

  } while (1);
 return tempDIR;
 }

 string extract_filename (string path)
 {
  int i;
  if ( path [strlen(path)-1] == '/') path [strlen (path)-1] = 0;
  for (i=strlen (path)-1; i >= 0; i--)
  {
   if ( (path [i] == '/') || (path [i] == ':') ) return (path+i+1);
  }
  return (path) ;
 }
