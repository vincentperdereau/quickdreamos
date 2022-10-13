char* get_argz (char* line,int count)
{
 unsigned char i ;
 unsigned char j ;
 int intern_count=0 ;
 for (i=0;i<=50;i++)
 {
  if (line[i]!=32) { for (j=i;(line[j]!=32)&&(line[j]!=0);j++);line[j]=0;

                     intern_count++;
		     if (intern_count==count) break ;
		     i=j;}
 }
return (line+i);
}
