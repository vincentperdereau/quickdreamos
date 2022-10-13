/*
 * quick/src/kernel/modules/fs/tinyfs/file.c
 *
 * derniŠre modification: 
 */

#include <typedef.h>
#include <sys/fs/tinyfs/tinyfs.h>
#include <sys/mm/memory.h>

extern UCHAR DRIVE;

extern struct file_control_block fcb [FCB_PER_SECTOR];


/*
 * f_create (): cr‚ation d'un fichier (n'‚crase pas un fichier pr‚-existant)
 *
 */

 ULONG f_create (STRING s)
 {
  ULONG handle;          // num‚ro d'identification du fichier 
  UCHAR tempDRIVE;       // ce num‚ro correspond … l'adresse FCB du fichier.

  // on v‚rifie que le nom est correct (longeur < 12, caractŠres utilis‚s...)
  if ( !valid_name ( extract_filename (s) ) ) return 0;

  // on sauve la valeur actuelle du disque en usage
  tempDRIVE = DRIVE;
  // on d‚termine le FCB du r‚pertoire 'pŠre'
  path (s);
  // on cr‚e un FCB correspondant.
  handle = create ( extract_filename (s), F_ARCH, DRIVE, path (s) );
  handle = (handle<<1);
  // Si le FCB sur disque A, alors bit-0 ‚teint,
  // Si le FCB sur disque C, alors bit-1 allum‚.
  if (DRIVE==diskA);
  if (DRIVE==diskC) handle |= 1; 
  // on restaure la valeur actuelle du disque en usage
  DRIVE = tempDRIVE;
  return handle; // retourne l'handle (identificateur)
 }

 /*
  * f_open (): ouverture d'un fichier
  *
  */

 ULONG f_open (STRING s)
 {
  ULONG handle;
  UCHAR tempDRIVE;
  struct file_control_block tempFCB;
  tempDRIVE = DRIVE;
  // On d‚termine l'adresse FCB du r‚pertoire 'pŠre'
  path (s);
  // On d‚termine l'adresse du FCB 
  handle = get_fcb (DRIVE,extract_filename (s),1,path (s),&tempFCB);
  handle = (handle<<1);
  if (DRIVE==diskA);
  if (DRIVE==diskC) handle |= 1;
  memcpy (KERNEL_SEG,0x8000,KERNEL_SEG,(UINT)extract_filename (s),12);
  DRIVE = tempDRIVE;
  return handle; // On renvoie l'identificateur (handle)
 }

 /*
  * f_size (): renvoie la taille du fichier
  * usage: size = f_size (f_open ("/bin/as"));
  */

 ULONG f_size (ULONG handle)
 {
  ULONG tempDRIVE;
  struct file_control_block tempFCB;

  // Sur A: ou C: ?
  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);

  // Lecture du FCB correspondant
  if (!read_fcb (tempDRIVE,handle,&tempFCB)) return 0;
  return (tempFCB.f_size); // on renvoie le champ .f_size
 }

 /*
  * f_attr (): renvoie l'attribut d'un fichier
  *
  */

 UCHAR f_attr (ULONG handle)
 {
  ULONG tempDRIVE;
  struct file_control_block tempFCB;

  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);
  // lecture du FCB
  if (!read_fcb (tempDRIVE,handle,&tempFCB)) return ERROR;
  return (tempFCB.f_attr); // renovie le champ .f_attr
 }

 /*
  * f_set_attr (): fixe l'attribut d'un fichier
  *
  */

 UCHAR f_set_attr (ULONG handle, char fattr)
 {
  ULONG tempDRIVE;
  struct file_control_block tempFCB;

  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);
  // Lecture du FCB
  if (!read_fcb (tempDRIVE,handle,&tempFCB)) return ERROR;
  // On fixe l'attribut
  tempFCB.f_attr = fattr;
  // Ecriture du FCB
  if (!set_fcb (tempDRIVE,handle,&tempFCB)) return ERROR;
  return (OK);
 }

 /*
  * f_read (): lecture d'un fichier
  *
  */

 BOOL f_read (ULONG handle, ULONG size, UINT seg, UINT ofs)
 {
  ULONG w_cluster;
  ULONG tempDRIVE;
  struct file_control_block tempFCB;
  ULONG i=0;

  // Sur A: ou C: ?
  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);

  // On d‚termine l'adresse du premier secteur de donn‚es
  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return ERROR;
  w_cluster = tempFCB.f_cluster; // w_cluster = premier secteur de donn‚es

  do {
      // lecture du secteur de donn‚es
      if (absolute_disk_access (tempDRIVE,DISK_READ,1,w_cluster+BITMAP_ADDR_START+(bitmap_size (tempDRIVE)>>9),KERNEL_SEG,(UINT)&fcb)) return ERROR;
      // Si donn‚es encore voulues (taille)
      if (size > (CLUSTER_SIZE-4) )
           // copie les donn‚es du secteur dans le buffer donn‚ en paramŠtre
           memcpy (seg,(UINT)(ofs+i),KERNEL_SEG,(UINT)&fcb,CLUSTER_SIZE-4);
      else  {
           // copie les donn‚es du secteur dans le buffer donn‚ en paramŠtre
             memcpy (seg,(UINT)(ofs+i),KERNEL_SEG,(UINT)&fcb,size);
	     break;
	    }
      // On d‚termine l'adresse du prochain secteur de donn‚es
      w_cluster = fcb [FCB_PER_SECTOR-1].f_cluster; // les 4 derniers octets

      // 0xFFFFFFFF => dernier secteur
      if (fcb [FCB_PER_SECTOR-1].f_cluster == 0xffffffff) break;
      size -= CLUSTER_SIZE -4; // on d‚cr‚mente la taille de donn‚es souhait‚es
      i += CLUSTER_SIZE -4; // on incr‚mente l'adresse du tampon (=buffer)

     } while (1);
  return OK; // All Is Good!
 }

/*
 * f_remove (): Suppression des fichiers
 *
 */

 BOOL f_remove (ULONG handle)
 {
  ULONG w_cluster;
  ULONG tempDRIVE;
  struct file_control_block tempFCB;

  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);

  // Lecture du FCB
  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return ERROR;
  // On d‚t‚rmine l'adresse du premier secteur de donn‚es (w_cluster)
  w_cluster = tempFCB.f_cluster;
  // On ‚teint le bit relatif … ce secteur dans la 'bitmap'
  set_cluster (tempDRIVE,w_cluster,0);
  // On efface le premier caractŠre du nom dans le FCB
  // Cela ne vous rappelle pas 'undelete' … l'‚poque des DOS 6.x ?
  tempFCB.f_name [0] = 0;
  // On ‚crit le FCB modifi‚
  set_fcb (tempDRIVE,handle,&tempFCB);

  // Peut etre une simple entr‚e ?
  if ( tempFCB.f_size == 0) { dec_fcb_count (tempDRIVE); // On d‚cr‚mente le nombre de FCB en usage
                              return OK;
                            }
  // Boucle: on eteind tous les bits des diff‚rents secteurs utilis‚s par le
  //         fichier
  do {
      if (absolute_disk_access (tempDRIVE,DISK_READ,1,w_cluster+BITMAP_ADDR_START+(bitmap_size (tempDRIVE)>>9),KERNEL_SEG,(UINT)&fcb)) return ERROR;
      // 0xFFFFFFFF => dernier secteur, on quitte
      if (fcb[FCB_PER_SECTOR-1].f_cluster == 0xffffffff) break;
      // On d‚termine l'adresse du prochain secteur
      w_cluster = fcb[FCB_PER_SECTOR-1].f_cluster;
      // On ‚teind ce secteur dans la bitmap
      set_cluster (tempDRIVE,w_cluster,0);
     } while (1);
  dec_fcb_count (tempDRIVE); // On d‚cr‚mente le nombre de FCB en usage
  return OK;
 }

/*
 * f_write (): ‚criture dans un fichier
 *
 */

 BOOL f_write (ULONG handle, ULONG size, UINT seg, UINT ofs)
 {
  ULONG w_cluster;
  ULONG tempDRIVE;
  struct file_control_block tempFCB;
  ULONG i=0;

  // Disk A: ou Disk C:
  if ( (handle & 1) == 1) tempDRIVE = diskC;
  else tempDRIVE = diskA;
  handle = (handle >> 1);
  // On d‚termine l'adresse du premier secteur de donn‚es libre
  if (!read_fcb (tempDRIVE,handle,&tempFCB )) return ERROR;
  w_cluster = tempFCB.f_cluster;
  // On inscrit la taille dans le FCB
  tempFCB.f_size = size;
  // Mise … jour du FCB
  if (!set_fcb (tempDRIVE,handle,&tempFCB) ) return ERROR;
  // On alloue le secteur (bit … 1)
  set_cluster (tempDRIVE,w_cluster,1);
  do {
      // Copie du tampon vers le tampon interne (fcb)
      memcpy (KERNEL_SEG,(UINT)&fcb,seg,(UINT)(ofs+i),CLUSTER_SIZE-4);
      // On incr‚mente 'i' taille des donn‚es sur un secteur (512-4)
      i += CLUSTER_SIZE-4;
      // On alloue le secteur
      set_cluster (tempDRIVE,w_cluster,1);
      // Si tout est inscrit, on indique que c'est le dernier secteur
      // via le drapeau (0xffffffff).
      if ( i >= size) fcb[FCB_PER_SECTOR-1].f_cluster = 0xffffffff;
      else {
             // On recherche un secteur de donn‚es libre.
             fcb[FCB_PER_SECTOR-1].f_cluster = get_cluster_free (tempDRIVE);
             if (!fcb[FCB_PER_SECTOR-1].f_cluster) return ERROR;
	   }
      // Ecriture sur disque.
      if (absolute_disk_access (tempDRIVE,DISK_WRITE,1,w_cluster+BITMAP_ADDR_START+(bitmap_size(tempDRIVE)>>9),KERNEL_SEG,(UINT)&fcb)) return ERROR;
      // prochain cluster...
      w_cluster = fcb[FCB_PER_SECTOR-1].f_cluster;
      if ( i >= size ) break;
     } while (1);
  return OK;
 }
