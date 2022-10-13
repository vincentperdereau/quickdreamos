
 /*
  * include/string.h
  *
  * created: 08/16/99
  * modified: 08/16/99
  *
  */

  #define       INCLUDE_STRING_H        1
  #define       STRING_H                1

  void strcpy (string c, string s)
  {
   register uchar i;
   for (i=0;s[i]!=0;i++) c[i]=s[i];
   c[i]=0;
  }

  uchar strlen (string s)
  {
   register uchar i;
   for (i=0;s[i]!=0;i++);
   return i;
  }

  void strcat (string c, string s)
  {
   strcpy ( (string)&(c[strlen(c)]),s);
  }

  bool strcmp (string a, string b)
  {
   register uchar i;
   for (i=0;((a[i]==b[i])&&(a[i]!=0)&&(b[i]!=0));i++);
   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   else return 1;
  }
