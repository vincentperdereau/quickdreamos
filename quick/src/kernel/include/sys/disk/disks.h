/*
 * quick/src/kernel/include/sys/disks/disks.h
 *
 *
 */


  struct s_disk_state                     // structure d'informations pour
  {                                       // un lecteur
   UINT         cyl;                      // Nombre de cylindres
   UCHAR        head;                     // Nombre de tˆtes
   UCHAR        sector;                   // Nombre de secteurs
   ULONG        max_addr;                 // Adresse logique maximale
   ULONG        bbitmap_size;             // Taille du 'bitmap' en bytes
   UCHAR        drive;                    // num‚ro du lecteur (x00 ou x80,...)
  };
