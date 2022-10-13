/*
 * quick/src/kernel/include/sys/mm/memory.h
 *
 *
 * routines for memory access (low-mem)
 *
 */

/*
 * memcpy
 *
 */

PROC memcpy (UINT segc,UINT ofsc,UINT segs,UINT ofss,UINT count);

/*
 * memset
 *
 */

PROC memset (UINT segs,UINT ofss,UINT count,UCHAR b);
