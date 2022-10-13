/*
 *
 *
 *
 *
 *
 */

   #define      INCLUDE_SYS_I386_FS_TINYFS_CREATE_H       1

   ulong fcluster;

   ulong create (string fname,
                 uchar attr,
                 uchar d,
                 ulong dir_father)
   {
    struct file_control_block tempFCB;
    ulong fcb_cluster;
    struct time t;
    struct date da;

    // find if FCB doesn't exist yet
    if (get_fcb (d,fname,attr,dir_father,&tempFCB)) return 0;
    // find free fcb
    fcb_cluster = get_fcb_free (d);
    if (!fcb_cluster) return 0;
    // fill FCB fields
    strcpy (tempFCB.f_name,fname);
    tempFCB.f_attr = attr;
    tempFCB.f_dir_father = dir_father;
    tempFCB.f_cluster = get_cluster_free (d);

    gettime (&t);
    tempFCB.f_hour = t.ti_hour;
    tempFCB.f_min = t.ti_min;
    getdate (&da);
    tempFCB.f_year = da.da_year;
    tempFCB.f_month = da.da_mon;
    tempFCB.f_day = da.da_day;

    fcluster = tempFCB.f_cluster;
    tempFCB.f_size = 0;
    // write fcb
    if (!set_fcb (d,fcb_cluster,&tempFCB)) return 0;
    inc_fcb_count (d);
    // return FCB cluster
    return fcb_cluster;
   }

   bool valid_name (string name)
   {
    uchar i;
    if (strlen (name) >= 12) return 0;
    if (name[0] == 0) return 0;
    for (i=0;i <= (strlen (name)-1); i++)
    {
          if ( (name [i] > 96) && (name [i] < 123) );
     else if ( (name [i] > 47) && (name [i] < 58) ) ;
     else if ( (name [i] > 63) && (name [i] < 91 ) );
     else if ( name [i] == 46 );
     else return 0;
    }
    return 1;
   }
