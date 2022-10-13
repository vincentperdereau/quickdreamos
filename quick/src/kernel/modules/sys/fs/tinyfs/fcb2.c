/*
 * modules/sys/fs/tinyfs/fcb2.c
 *
 * gestion des FCBs
 */

 #include <typedef.h>
 #include <sys/fs/tinyfs/tinyfs.h>
 #include <sys/mm/memory.h>
 #include <string.h>

 // d‚finition de la structure
 struct file_control_block fcb [FCB_PER_SECTOR];

 /*
  * get_fcb_free (): recherche un FCB libre sur le lecteur 'd'
  *
  */

 ULONG get_fcb_free (UCHAR d)
 {
  ULONG i;
  ULONG j=1;

  // On recherche … travers tous les FCBs 
  for (i=FCB_ADDR_BEGIN;i <= FCB_ADDR_END; i++)
  {
   if (absolute_disk_access (d,DISK_READ,1,i,KERNEL_SEG,(UINT)&fcb)) return ERROR;
   {
    for (; j <= (FCB_PER_SECTOR-1); j++)
    {
     // Premier caractŠre du nom = 0 signifie FCB libre.
     // On retourne l'adresse de ce FCB.
     if (fcb[j].f_name[0]==0) return (((i-FCB_ADDR_BEGIN)<<4)+j+1);
    }
   j = 0;
   }
  }
  return ERROR;
 }

 /*
  * set_fcb (): ecrit un FCB su disque
  *
  */

 BOOL set_fcb (UCHAR d,ULONG fcb_addr,struct file_control_block *FCB)
 {
  ULONG dummy;
  dummy = ((fcb_addr-1)>>4);
  // Lecture du FCB
  if (absolute_disk_access (d,DISK_READ,1,dummy+FCB_ADDR_BEGIN,KERNEL_SEG,(UINT)&fcb)) return ERROR;
  // Copie de la structure (*FCB)
  memcpy (KERNEL_SEG,(UINT) & (fcb [fcb_addr - (dummy<<4) -1]), KERNEL_SEG,(UINT)FCB, FCB_SIZE);
  // Ecriture du FCB
  if (absolute_disk_access (d,DISK_WRITE,1,dummy+FCB_ADDR_BEGIN,KERNEL_SEG,(UINT)&fcb)) return ERROR;
  return OK;
 }

 /*
  * read_fcb (): lecture d'un FCB
  *
  */

 BOOL read_fcb (UCHAR d,ULONG fcb_addr,struct file_control_block *FCB)
 {
  ULONG dummy;
  dummy = ((fcb_addr-1)>>4);
  // Lecture sur disque du FCB
  if (absolute_disk_access (d,DISK_READ,1,dummy+FCB_ADDR_BEGIN,KERNEL_SEG,(UINT)&fcb)) return ERROR;
  // Copie vers la structure (*FCB)
  memcpy (KERNEL_SEG,(UINT)FCB,KERNEL_SEG,(UINT)& (fcb [fcb_addr - (dummy<<4) -1]), FCB_SIZE);
  return OK;
 }

 /*
  * get_fcb_count (): renvoie le nombre de FCBs en usage
  *
  */

 ULONG get_fcb_count (UCHAR d)
 {
  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,KERNEL_SEG,(UINT)&fcb)) return 0;
  // Le nombre de FCB en usage est inscrit dans le champ f_size du
  // tout premier FCB.
  return (fcb[0].f_size+1);
 }

 /*
  * inc_fcb_count (): incr‚mente le nombre de FCB en usage
  *
  */

 BOOL inc_fcb_count (UCHAR d)
 {
  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,KERNEL_SEG,(UINT)&fcb)) return 0;
  fcb[0].f_size++;
  if (absolute_disk_access (d,DISK_WRITE,1,FCB_ADDR_BEGIN,KERNEL_SEG,(UINT)&fcb)) return 0;
  return 1;
 }

 /*
  * dec_fcb_count (): d‚cr‚ment le nombre de FCB en usage
  *
  */

 BOOL dec_fcb_count (UCHAR d)
 {
  if (absolute_disk_access (d,DISK_READ,1,FCB_ADDR_BEGIN,KERNEL_SEG,(UINT)&fcb)) return 0;
  fcb[0].f_size--;
  if (absolute_disk_access (d,DISK_WRITE,1,FCB_ADDR_BEGIN,KERNEL_SEG,(UINT)&fcb)) return 0;
  return 1;
 }

 /*
  * get_fcb (): recherche d'un FCB portant les attributs (nom,attribut,rep pŠre)
  *
  */

 ULONG get_fcb (UCHAR d,
		STRING fname,
		UCHAR attr,
		ULONG dir_father,
		struct file_control_block *FCB)
 {
  ULONG i,j;
  ULONG fcb_count;
  ULONG counter=0;

  fcb_count = get_fcb_count (d); // Inutile de chercher plus loin

  j = 1;
  for (i=FCB_ADDR_BEGIN; i <= FCB_ADDR_END; i++)
  {
   // Lecture sur disque
   if (absolute_disk_access (d,DISK_READ,1,i,KERNEL_SEG,(UINT)&fcb)) return ERROR;
   for (;j <= (FCB_PER_SECTOR-1); j++)
   {
    if ( (counter+1) == fcb_count ) return ERROR; // pas trouv‚
    if ( fcb[j].f_name [0] != 0) counter++; // si f_name[0]!=0, alors FCB est allou‚
    if (   (!strcmp (fname,fcb[j].f_name)) // alors on compare le nom,...
        && ( (attr == fcb[j].f_attr) || ( (attr==1) && (fcb[j].f_attr != F_DIR) ) ) // ...les attributs,...
        && (dir_father == fcb[j].f_dir_father) )  // et l'adresse du rep.pŠre
	{
                // Alors nous avons trouv‚. => On copie dans le tampon le FCB
                memcpy (KERNEL_SEG,(UINT)FCB,KERNEL_SEG, (UINT)& (fcb [j]), FCB_SIZE);
                return (((i-FCB_ADDR_BEGIN)<<4)+j+1); // retourne l'adresse du FCB
	}
   }
  j = 0;
  }
  return ERROR;
 }
