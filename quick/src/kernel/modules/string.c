 /*
  * quick/src/kernel/modules/string.c
  *
  */

#include <typedef.h>

  /*
   * strcpy (): copie la chaine de caractäre 's' dans 'c'.
   *
   */

  PROC strcpy (STRING c, STRING s)
  {
   register UCHAR i;
   for (i=0;s[i]!=0;i++) c[i]=s[i];
   c[i]=0;
  }

  /*
   * strlen (): renvoie la longueur de 's'
   *
   */

  UCHAR strlen (STRING s)
  {
   register UCHAR i;
   for (i=0;s[i]!=0;i++);
   return i;
  }

  /*
   * strcmp (): renvoie 0 si a egal b.
   *
   */

  BOOL strcmp (STRING a, STRING b)
  {
   register UCHAR i;
   for (i=0;((a[i]==b[i])&&(a[i]!=0)&&(b[i]!=0));i++);
   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   else return 1;
  }
