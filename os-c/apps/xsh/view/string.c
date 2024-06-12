  typedef char* string;

  void strcpy (string c, string s)
  {
   register unsigned char i;
   for (i=0;s[i]!=0;i++) c[i]=s[i];
   c[++i]=0;
  }

  unsigned char strlen (string s)
  {
   register unsigned char i;
   for (i=0;s[i]!=0;i++);
   return i;
  }

  void strcat (string c, string s)
  {
   strcpy ( (string)&(c[strlen(c)]),s);
  }

  int strcmp (string a, string b)
  {
   register unsigned char i;
   for (i=0;((a[i]==b[i])&&(a[i]!=0)&&(b[i]!=0));i++);
   if ( (i==strlen(a))&&(i==strlen(b))) return 0;
   else return 1;
  }
