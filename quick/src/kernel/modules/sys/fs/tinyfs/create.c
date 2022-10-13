/*
 * quick/src/kernel/modules/sys/fs/tinyfs/create.c
 *
 * cr‚ation d'un FCB.
 *
 */

  #include <typedef.h>
  #include <sys/fs/tinyfs/tinyfs.h>
  #include <sys/mm/memory.h>
  #include <string.h>

/*
 * nvread (): lecture du RTC (RealTimeClock)
 * utilis‚ pour connaitre date/heure
 *
 */

   UCHAR nvread (char port)
   {
    asm {
                push dx
                mov dx,0x70
                mov al,port
                out dx,al
                mov dx,0x71
                in al,dx
                pop dx
        }
   }

   ULONG fcluster;

 /*
  * create (): cr‚ation d'un FCB
  *
  */

   ULONG create (STRING fname,
                 UCHAR attr,
                 UCHAR d,
                 ULONG dir_father)
   {
    struct file_control_block tempFCB;
    ULONG fcb_cluster;
    // on d‚termine date/heure
    int th = nvread (4);
    int tm = nvread (2);
    int dy = nvread (9);
    int dm = nvread (8);
    int dd = nvread (7);
    int dc = nvread (0x32);
    UCHAR tattr;

    if (attr==F_DIR) tattr = F_DIR;
    else tattr = 1;

    // on v‚rifie qu'un fcb identique n'existe pas
    if (get_fcb (d,fname,tattr,dir_father,&tempFCB)) return ERROR;
    // recherche un fcb libre
    fcb_cluster = get_fcb_free (d);
    if (!fcb_cluster) return ERROR;
    // on remplit les champs du FCB … partir des paramŠtres
    strcpy (tempFCB.f_name,fname);
    dy = (((dy >> 4) & 0x0F) * 10) + (dy & 0x0F);
    dc = (((dc >> 4) & 0x0F) * 10) + (dc & 0x0F);
    tempFCB.f_year = dc*100 + dy;
    tempFCB.f_month = (((dm >> 4) & 0x0F) * 10) + (dm & 0x0F);
    tempFCB.f_day = (((dd >> 4) & 0x0F) * 10) + (dd & 0x0F);
    tempFCB.f_hour = (((th >> 4) & 0x0F) * 10) + (th & 0x0F);
    tempFCB.f_min = (((tm >> 4) & 0x0F) * 10) + (tm & 0x0F);
    tempFCB.f_attr = attr;
    tempFCB.f_dir_father = dir_father;
    tempFCB.f_cluster = get_cluster_free (d);
    fcluster = tempFCB.f_cluster;
    tempFCB.f_size = 0;
    // On ‚crit le FCB sur disque
    if (!set_fcb (d,fcb_cluster,&tempFCB)) return ERROR;
    inc_fcb_count (d); // On incr‚mente le nombre de FCB en usage
    // On renvoie l'adresse du FCB
    return fcb_cluster;
   }

 /*
  * valid_name (): v‚rifie le nom
  *
  */

   BOOL valid_name (STRING name)
   {
    UCHAR i;
    if (strlen (name) >= 12) return 0; // plus de 12 cars., ERROR
    if (name[0] == 0) return 0; // nom vide, ERROR
    for (i=0;i <= (strlen (name)-1); i++)
    {
          if ( (name [i] > 96) && (name [i] < 123) ); // Minuscules
     else if ( (name [i] > 47) && (name [i] < 58) ) ; // Chiffres
     else if ( (name [i] > 63) && (name [i] < 91 ) ); // Majuscules
     else if ( name [i] == 46 ); // on accepte '.'
     else return 0;
    }
    return 1;
   }
