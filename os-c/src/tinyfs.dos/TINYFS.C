
 /* DOS Interface */
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <conio.h>
 #include <dos.h>
 #include <io.h>

 #define write_string(x)	printf (x);
 #define write_char(x)		putc (x,stdout);
 #define write_hex_byte(x)      printf ("%X",x);
 #define write_hex_word(x)	printf ("%X",x);
 #define write_hex_dword(x)	printf ("%X",x);

 char	cmd [100];
 char   cmd1 [100];
 char   cmd2 [100];
 char   cmd3 [100];
 char   prompt [100];
 unsigned char fbuffer [40000];

 /*****************/


 #include "typedef.h"
 #include "disk.h"

 #include "fcb.h"
 #include "attr.h"
 #include "bitmap.h"
 #include "init.h"
 #include "fcb2.h"
 #include "create.h"
 #include "path.h"
 #include "dir.h"
 #include "file.h"
 #include "tinyfs.h"


 struct file_control_block myFCB;

 char cluster [512] = {0};
  ulong temp;

 void dir (string pt)
 {
  ulong i;
  ulong j;
  ulong _dir;
  ulong fcb_count;
  ulong counter=1;
  int quit=0;

   _dir = ACTUAL_DIR;
   fcb_count = get_fcb_count (0);

  for (i=FCB_ADDR_BEGIN; i <= FCB_ADDR_END; i++)
   {
    absolute_disk_access (0,DISK_READ,1,i,FP_SEG(fcb),(uint)&fcb);
    for (j=1;j <= (FCB_PER_SECTOR-1); j++)
    {
     //if ( (((i-FCB_ADDR_BEGIN)<<4)+j) > fcb_count ) goto ending;
     if (counter == fcb_count) {quit=1; break;}
     if (fcb[j].f_name[0]!=0)
      {
       counter++;
       if (fcb[j].f_dir_father==_dir) { printf ("\n%12s   %c    %5d   y%d",fcb[j].f_name,(fcb[j].f_attr==F_DIR) ? 'D' : 'A',fcb[j].f_size,fcb[j].f_year);}
      }
    }
   if (quit) break;
   }
 ending:
 printf ("\n");
 }

 void format (uchar d)
 {
  ulong i;
  if (reset_disk (d)) { printf ("\nreset_disk () error %d!\n",reset_disk(d));
			 return;
		       }
  printf ("\nreset_disk () Ok");

  for (i=0;i<=disk_state.max_addr;i++)
   {
   printf ("%4d.",i);
     if (absolute_disk_access (0,DISK_WRITE,1,i,FP_SEG(cluster),FP_OFF(cluster)))
     { printf ("\nerror at %d",i); return; }
   }

  printf ("\nformat () Ok\n");
 }

 FILE *stream;
 ulong handle;

 void main (int argc, char* argv[])
 {

  printf ("\ntinyfs.exe");
  printf ("\ntype 'exit' to quit\n");
  init_disk (0);

  strcpy (prompt,"a:/"); 
  do {
	printf ("\n%s",prompt);
	if (argc > 1) strcpy (cmd,argv[1]);
	else gets (cmd);
	sscanf (cmd,"%s %s %s",cmd1,cmd2,cmd3);

	if (!strcmp (cmd1,"ls")) dir (cmd2);
	else if (!strcmp (cmd1,"format")) format (0);
	else if (!strcmp (cmd1,"mkdir")) mkdir (cmd2);
	else if (!strcmp (cmd1,"get")) {
				       handle = f_open (cmd2);
				       if (!handle) break;
				       temp = f_size (handle);
				       f_read (handle,temp,FP_SEG(fbuffer),FP_OFF(fbuffer));
				       printf ("\n%s -> %s [%d]",cmd2,cmd3,temp);
				       stream = fopen (cmd3,"wb");
				       if (stream==NULL) break;
				       fwrite (fbuffer,temp,1,stream);
				       fclose (stream);
				       }
	else if (!strcmp (cmd1,"put")) {
					stream = fopen (cmd2,"rb");
					if (stream==NULL) break;
					fread (fbuffer,filelength ( fileno(stream)),1,stream);
					printf ("\n%s -> %s [%u]\n",cmd2,cmd3,filelength ( fileno(stream)));
					handle = f_create (cmd3);
					printf ("\nhandle: %d\n",handle);
					printf ("\n%d\n",f_write (handle,filelength ( fileno(stream)),FP_SEG(fbuffer),FP_OFF(fbuffer)));
					fclose (stream);
				       }
	else if (!strcmp (cmd1,"rm")) {

				       handle = f_open (cmd2);
				       if (!handle) break;
				       if (!f_remove (handle)) printf ("\nerror\n");

				      }
	else if (!strcmp (cmd1,"rmdir")) { if (!rmdir (cmd2)) printf ("\nerreur\n"); }


	else if (!strcmp (cmd1,"cd")) {

					if ( cmd2 [strlen(cmd2)-1] != '/')
					strcat (cmd2,"/.");
					else strcat (cmd2,".");


					temp = (path (cmd2));
					if (temp==0xffffffff) printf ("\nerreur\n");
					else ACTUAL_DIR=temp;
					printf ("\ntemp=%d\n",temp);

				      }
	else if (!strcmp (cmd1,"path")) printf ("\n%d\n",path(cmd2));
	else if (!strcmp (cmd1,"handle")) {
					    handle = f_open (cmd2);
					    printf ("\n%d\n",handle);
					  }


	else if (!strcmp (cmd1,""));
	else if (!strcmp (cmd1,"exit"));
	else printf ("unknown command\n");

     } while ( (strcmp(cmd1,"exit")) && (argc < 2));

 }
