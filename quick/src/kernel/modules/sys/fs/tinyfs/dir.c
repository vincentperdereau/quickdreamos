/*
 * modules/sys/fs/tinyfs/dir.c
 *
 * gestion des r‚pertoires
 *
 */

 #include <typedef.h>
 #include <sys/fs/tinyfs/tinyfs.h>

 extern UCHAR DRIVE;
 extern ULONG  ACTUAL_DIR_A;
 extern ULONG  ACTUAL_DIR_C;

 /*
  * mkdir (): cr‚ation d'un repertoire
  *
  */

 BOOL mkdir (STRING dir)
 {
  BOOL ret;
  ULONG dir_father;
  ULONG tempDRIVE;

  // On v‚rifie la validit‚ du nom
  if (!valid_name (extract_filename (dir))) return 0;
  tempDRIVE = DRIVE;
  // On d‚termine l'adresse du r‚pertoire 'pŠre'
  dir_father = path (dir);
  if (dir_father == 0xffffffff) // ERROR
   {
   DRIVE = tempDRIVE; // on r‚tablit les valeurs initiales
   return ERROR;     // et on quitte
   }
  // cr‚ation du FCB avec attribut F_DIR (r‚pertoire)
  ret = create (extract_filename (dir),F_DIR,DRIVE,dir_father);
  DRIVE = tempDRIVE;
  return ret;
 }

 /*
  * rmdir (): suppression d'un r‚pertoire
  *
  */

 BOOL rmdir (STRING dir)
 {
  ULONG dir_father;
  ULONG tempDRIVE;
  ULONG addr;
  struct file_control_block tempFCB;

  tempDRIVE = DRIVE;
  // Adresse FCB r‚pertoire pŠre
  dir_father = path (dir);
  DRIVE = tempDRIVE;
  if (dir_father == 0xffffffff) return ERROR;
  // adresse du FCB du repertoire 'dir', lecture de ce FCB
  addr = get_fcb (tempDRIVE,extract_filename (dir),F_DIR,dir_father,&tempFCB);
  if (!addr) return ERROR;
  tempFCB.f_name [0] = 0; // premier caractŠre effac‚
  dec_fcb_count (tempDRIVE); // on d‚cr‚mente le nombre de FCB en usage
  // On inscrit sur disque le FCB modifi‚
  if (!set_fcb (tempDRIVE,addr,&tempFCB)) return ERROR;
  return OK;
 }

 /*
  * chgdir (): change le r‚pertoire actif (variable ACTUAL_DIR_x)
  *
  */

 ULONG chgdir (STRING dir)
 {
  long tempDIR=0;
  // lecture du FCB du r‚pertoire pŠre
  tempDIR = path (dir);
  if ( tempDIR != 0xffffffff) if (DRIVE == diskA) ACTUAL_DIR_A = tempDIR;
                              else if (DRIVE == diskC) ACTUAL_DIR_C = tempDIR;
                              else tempDIR = 0xffffffff; // ERROR
  return tempDIR;
 }
