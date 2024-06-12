/*
 * quick/src/kernel/modules/sys/krnbox/krnbox.c
 *
 * interface noyau / utilisateur via interruption
 */

 #include <typedef.h>
 #include <sys/krnbox/api.h>
 #include <sys/intr/intr.h> // gestion des interruptions

 #include <sys/mm/memory.h>
 #include <sys/disk/disk.h>
 #include <sys/disk/disks.h>
 #include <sys/fs/tinyfs/init.h>
 #include <sys/fs/tinyfs/fcb.h>
 #include <sys/fs/tinyfs/fcb2.h>
 #include <sys/fs/tinyfs/file.h>
 #include <sys/fs/tinyfs/dir.h>

 #define FCB_PER_SECTOR         16        // Nombre de FCBs par secteur

 extern UCHAR DRIVE;
 extern ULONG ACTUAL_DIR_A;
 extern ULONG ACTUAL_DIR_C;
 extern struct s_disk_state disk_state;
 extern struct file_control_block fcb [FCB_PER_SECTOR];

 struct KRNBOX
 {
  UCHAR         function;
  UCHAR         UCHAR1;
  UINT          UINT1;
  UINT          UINT2;
  ULONG         ULONG1;
  ULONG         ULONG2;
 };

 struct KRNBOX  krnbox;

 #define BUFFER_OFS     0x2600     // offset donn‚es temporaires

 #define push_all asm { pushad;push es;push ds } // sauve tous les registres
 #define pop_all  asm { pop ds;pop es; popad   } // restaure tous les registres

 void krnbox_dispatch (void)
 {
   push_all;
     asm { mov ax,0x1000
           mov es,ax
           mov ds,ax }

     switch (krnbox.function)   // fonction
     {
      // renvoie la version du noyau
      case API_TEST:    krnbox.UINT1 = 1234;
			krnbox.UINT2 = 0x0005; /* version */
                        break;
      // ouverture du fichier
      case API_FOPEN:   memcpy (KERNEL_SEG,BUFFER_OFS,krnbox.UINT1,krnbox.UINT2,255);
                        krnbox.ULONG1 = f_open ((STRING)BUFFER_OFS);
			break;
      // cr‚ation du fichier
      case API_FCREATE: memcpy (KERNEL_SEG,BUFFER_OFS,krnbox.UINT1,krnbox.UINT2,255);
                        krnbox.ULONG1 = f_create ((STRING)BUFFER_OFS);
                        break;
      // lecture d'un fichier
      case API_FREAD:   krnbox.UCHAR1 = f_read (krnbox.ULONG1,krnbox.ULONG2,krnbox.UINT1,krnbox.UINT2);
                        break;
      // ecriture d'un fichier
      case API_FWRITE:  krnbox.UCHAR1 = f_write (krnbox.ULONG1,krnbox.ULONG2,krnbox.UINT1,krnbox.UINT2);
                        break;
      // changement de lecteur en usage
      case API_CHDRIVE: krnbox.UCHAR1 = init_disk (krnbox.UCHAR1);
                        break;
      // changement de r‚pertoire en usage
      case API_CHDIR:   memcpy (KERNEL_SEG,BUFFER_OFS,krnbox.UINT1,krnbox.UINT2,255);
                        krnbox.ULONG1 = chgdir ((STRING)BUFFER_OFS);
                        break;
      // cr‚ation de r‚pertoire
      case API_MKDIR:   memcpy (KERNEL_SEG,BUFFER_OFS,krnbox.UINT1,krnbox.UINT2,255);
                        krnbox.UCHAR1 = mkdir ((STRING)BUFFER_OFS);
                        break;
      // liste les FCBs 
      case API_FCBDIR:  krnbox.UCHAR1 = absolute_disk_access (DRIVE,DISK_READ,1,krnbox.ULONG1,krnbox.UINT1,krnbox.UINT2);
                        break;
      // renvoie le disk_state
      case API_INFOS:   memcpy (krnbox.UINT1,krnbox.UINT2,KERNEL_SEG,(UINT)&disk_state,sizeof(disk_state));
                        break;
      // renvoie le nombre de FCBs en usage OU change les attributs d'un fichier
      case API_FCBCOUNT:if (krnbox.UINT1 == 0xa)
                         krnbox.UINT2 = f_set_attr (krnbox.ULONG1,krnbox.UCHAR1);
                        else
                         krnbox.ULONG1 = get_fcb_count (DRIVE);
                        break;
      // renvoie la taille d'un fichier
      case API_FSIZE:   krnbox.ULONG1 = f_size (krnbox.ULONG2);
                        krnbox.UCHAR1 = f_attr (krnbox.ULONG2);
                        break;
      // suppression d'un fichier
      case API_FRM:     krnbox.UCHAR1 = f_remove (krnbox.ULONG1);
                        break;
      // suppression d'un repertoire
      case API_RMDIR:   memcpy (KERNEL_SEG,BUFFER_OFS,krnbox.UINT1,krnbox.UINT2,255);
                        krnbox.UCHAR1 = rmdir ((STRING)BUFFER_OFS);
                        break;
      // renvoie le FCB du repertoire actuel
      case API_ACDIR:
                        if (DRIVE == diskA) krnbox.ULONG1 = ACTUAL_DIR_A;
                        else if (DRIVE == diskC) krnbox.ULONG1 = ACTUAL_DIR_C;
                        else krnbox.ULONG1 = 0xffffffff;
                        break;
      default:  break;
     }

   pop_all;
   asm { iret };
 }

 // renvoie l'adresse de la structure KRNBOX
 void krnbox_retry_addr (void)
 {
  asm {
	mov bx,offset krnbox
	iret
      }
 }

 void krnbox_setup (void)
 {
  intr (krnbox_retry_addr,0x20);  // installe krnbox_retry_addr ()
  intr (krnbox_dispatch,0x21);   // installe krnbox_dispatch ()
 }
