/*
 * quick/src/kernel/modules/sys/fs/tinyfs/path.c
 * 
 * d‚termine l'adresse du repertoire 'pŠre'
 */

 #include <typedef.h>
 #include <sys/fs/tinyfs/tinyfs.h>

 extern UCHAR DRIVE;

 #include <string.h>

 ULONG  ACTUAL_DIR_A=0;
 ULONG  ACTUAL_DIR_C=0;

/*
 * path(): renvoie l'adresse du repertoire pŠre
 * ex: path ("/usr/bin/cc")
 *
 */

 ULONG path (STRING s)
 {
  UCHAR  i;
  UCHAR  j;
  char   Dir [12];
  ULONG  tempDIR;
  struct file_control_block tempFCB;

  i=0;
  // R‚pertoire actuel
  if (DRIVE == diskA ) tempDIR = ACTUAL_DIR_A;
  if (DRIVE == diskC ) tempDIR = ACTUAL_DIR_C;
  // Si dernier caractŠre '/' on l'annulle.
  if ( s [strlen(s)-1] == '/') s [strlen (s)-1] = 0;
  // Si second caractŠre = ':' alors on change de lecteur
  if (s[1] == ':') {
                    if (s[0]  == 'a') { DRIVE =diskA; tempDIR = ACTUAL_DIR_A ; }
                    else if (s[0] == 'c') { DRIVE =diskC; tempDIR = ACTUAL_DIR_C ; }
                    else return ERROR; // pas a:, pas c: connait-pas
                    i = 2; // caractŠre: position dans la chaine 's'
                    init_disk (DRIVE); // on initialise la structure disk_state
                   }
  // Si 's' commence par '/' alors on est dans la racine '/'
  // dir_father = 0
  if (s[i] == '/') {
                    tempDIR = 0;
                    i++;
                   }
  j = 0;
  do
  {
   if (s[i] == 0) break; // fin de chaine
   if (s[i] == '/') { Dir [j] = 0;
                      if (!strcmp (Dir,".")) ; // rep virtuel '.'
                      else  
                      // rep viruel '..', on revient en arriŠre
                      // on cherche le repertoire pŠre
                      if ( (!strcmp (Dir,".."))) if (!tempDIR); // si dans racine, rien
                                                 else
                                                      {
                                                      // on recherche l'adresse du rep. pŠre
                                                      if (!read_fcb (DRIVE,tempDIR,&tempFCB)) return 0xffffffff;
                                                      tempDIR = tempFCB.f_dir_father;
                                                      }
                      else {
                            // nouveau r‚pertoire, on le recherche...
                            tempDIR = get_fcb (DRIVE,Dir,F_DIR,tempDIR,&tempFCB);
                            if (!tempDIR) return 0xFFFFFFFF; // ERROR
                           }
                      j=0; i++; }
   Dir [j] = s[i];
   i++;j++;
  } while (1);
 return tempDIR;
 }

/*
 * extract_filename (): renvoie le nom de fichier d'un path.
 * ex: extract_filename ("/home/work/doc1") renvoie 'doc1'
 *
 */

 STRING extract_filename (STRING path)
 {
  int i;
  if ( path [strlen(path)-1] == '/') path [strlen (path)-1] = 0;
  for (i=strlen (path)-1; i >= 0; i--)
  {
   if ( (path [i] == '/') || (path [i] == ':') ) return (path+i+1);
  }
  return (path) ;
 }
