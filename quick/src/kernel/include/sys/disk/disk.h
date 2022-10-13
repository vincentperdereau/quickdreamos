/*
 * quick/src/kernel/include/sys/disk/disk.h
 *
 * routines and constants for disk access
 *
 */


  #define       diskA           0x00      // A: num‚ro x00 (pour int x13)
  #define       diskC           0x80      // C: num‚ro x80 (NB: x81 pour 2nd HD)
  #define       DISK_READ       0x02      // fonction Lecture (int x13)
  #define       DISK_WRITE      0x03      // fonction Ecriture (int x13)
  #define       SECTOR_SIZE     512       // Taille d'un secteur 512 bytes


/*
 * reset_disk ()
 *
 */

  BOOL reset_disk (UCHAR d);

/*
 * get_cyl ()
 *
 */

  ULONG get_cyl (UCHAR d);

/*
 * get_head ()
 *
 */

  ULONG get_head (UCHAR d);

/*
 * get_sector ()
 *
 */

  ULONG get_sector (UCHAR d);

  BOOL disk_access (UCHAR d,               // lecteur
                    int h,                 // tˆte
                    int c,                 // cylindre
                    int s,                 // secteur
                    int count,             // nombre de secteur(s) … ‚crire
                    void* ofs,             // 'offset' du buffer
                    UINT segm,             // 'segm' du buffer
                    int op);                // op‚ration … effecteur 

  BOOL absolute_disk_access (UCHAR d,       // lecteur
                            int op,        // op‚ration … affectuer
                            int count,     // nombre de secteur
                            ULONG addr,    // adresse logique
                            UINT seg,      // adresse buffer 
                            UINT ofs);      // seg:ofs
