/*
 * include/sys/fs/tinyfs/bitmap.h
 *
 *
 */

 #define        BITMAP_ADDR_START       219
 #define        CLUSTER_SIZE            512

 ULONG get_cluster_free (UCHAR d);

 BOOL set_cluster (UCHAR d, ULONG cluster, UCHAR state);
