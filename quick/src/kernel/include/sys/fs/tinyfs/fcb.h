/*
 * include/sys/fs/tinyfs/fcb.h
 *
 * Structure d'un FileControlBlock
 */

 #define FCB_SIZE               32        // taille d'un FCB
 #define FCB_PER_SECTOR         16        // Nombre de FCBs par secteur
 #define FCB_SECTORS            200       // Nombre de secteurs allou‚s pour FCBs
 #define FCB_ADDR_BEGIN         18        // d‚but des FCBs
 #define FCB_ADDR_END           218       // fin des FCBs
										  // = (FCB_ADDR_BEGIN + FCB_SECTORS)

// Il est possible de redéfinir le nombre de secteurs alloués au FCBs
// afin d'augmenter le nombre de fichiers/repertoires.

 struct file_control_block
 {
  char          f_name [12];       // nom du FCB 
  ULONG         f_size;           // taille 
  ULONG         f_dir_father;    // adresse du FCB du r‚pertoire 'pŠre'
  UCHAR         f_day;          // jour de cr‚ation
  UCHAR         f_month;       // mois de cr‚ation
  UINT          f_year;       // Y2K Compliant,... encore un chance!
  UCHAR         f_hour;         //
  UCHAR         f_min;         //
  UCHAR         f_attr;       //
  UCHAR         f_unused;    // 
  ULONG         f_cluster;  // adresse logique du premier secteur de donn‚es
 }; /* 32 bytes */
