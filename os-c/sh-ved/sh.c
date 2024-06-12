
 #include <startup.h>
 int isecho = 1;
 char is_xsh (void)
{
 asm {
        mov ah,4
        int 0x46
     }
}

 #include <stdout.h>
 #include <stdin.h>
 #include <mm.h>
 #include <file.h>
 #include <dir.h>
 #include <typedef.h>
 #include <string.h>
 #include <disk.h>
 #include <ls.h>
 #include <disk2.h>
 #include <login.h>
 #include <memory.h>
 #include <arg.h>
 #include <pic.h>

 char	prompt [100];
 char   cmdsh [100];
 char   path [100] = "/bin/ ";
 char   temp [100];
 char   buf [100];
 char   diskl;
 unsigned char   usedrive;

 int x;
 int path_count=1;

 static char nl [] = "\r\n";
 static char ERROR [] = "\n\rsh> error";
 static char success [] = "sh> ok";
 static char bad_opcode [] = "\n\rsh> unknown command\n";
 int quit=0;
 int gui=0;
 static char iscolor=0;

 addr bufferbatch;

 unsigned char sector [512] = {0};

 handle         file1, file2;


void batch (char*);

unsigned char get_boot_drive (void)
{
 asm {
       push es
       mov ax,07c0h
       mov es,ax
       mov al,es:[509]
       pop es
      }
}

void writedword (unsigned long dw)
{
 unsigned long i ; unsigned char b ;
 int flag=0;
 for (i=1000000000;i!=0;i/=10)
 {
 b = dw / i ; dw = dw - (b*i) ;
 if (b) flag = 1;
 if ( flag  && isecho)  putc (b+48) ;
 }
}

void cputc (char c, char color)
{
 if ( (iscolor) && ( !is_xsh () ) )
 asm {
	push ax
	push bx
	push cx
	mov ah,9
	mov bh,0
	mov cx,1
	mov al,c
	mov bl,color
	int 10h
	pop cx
	pop bx
	pop ax
     };
 putc (c);
}


void cputs (string s,char color)
{
 int i;
 if (isecho) for (i=0; s[i] != 0; i++) cputc (s[i],color);
}

void dir (int show)
 {
  ulong i;
  ulong j;
  ulong _dir;
  ulong fcb_count;
  ulong counter=0;
  int stat=0;

   _dir = acdir ();
   j = 1;
   fcb_count = get_fcb_count ();
  puts (nl);
  for (i=FCB_ADDR_BEGIN; i <= FCB_ADDR_END; i++)
   {
    fcb_dir (i,&cluster_buffer);
    for (;j <= (FCB_PER_SECTOR-1); j++)
    {
     if ( (counter+1) == fcb_count) { stat=1;break; }
     if (cluster_buffer[j].f_name[0]!=0)
     {
      counter++;
      if (cluster_buffer[j].f_dir_father==_dir) {
						  {
						   if (cluster_buffer[j].f_attr==0xa)
						    { cputs (cluster_buffer[j].f_name,9);putc ('/');}
						   else if (cluster_buffer[j].f_attr==0xc)
						    { cputs (cluster_buffer[j].f_name,2);putc ('*');}
						   else if (cluster_buffer[j].f_attr==0xd)
						    { cputs (cluster_buffer[j].f_name,3);putc ('&');}
						   else { cputs (cluster_buffer[j].f_name,7); putc (' ');}
						   for (x=0;strlen(cluster_buffer[j].f_name)+x<=14;x++) putc(32);
						  }
						}
     }
    }
   j = 0;
   if (stat) break;
   }

 }

 int i;


 void format_disk (unsigned char dr)
 {
  ulong bitmap_size;
  ulong ix;

  puts (nl);
  bitmap_size = (((get_cyl(dr)+1) * (get_head (dr)+1) * get_sector (dr) -1) >> 3)+1;
  writedword (bitmap_size);
  reset_disk (dr);
  puts (nl);
  writedword (220+(bitmap_size>>9)+1);
  for (ix=0;ix <= (220+(bitmap_size>>9)+1); ix++)
   {
   if (absolute_disk_access (dr,DISK_WRITE,1,ix,_CS,(uint)&sector)) return;
   }
  puts (nl);
  puts (success);

 }

 void syst (unsigned char dr)
 {
  ulong i;
  unsigned char odr;

  if (dr==0x00) odr = 0x80;
  if (dr==0x80) odr = 0x00;

  puts (nl);
  puts ("writing boot sector ...");
  if (absolute_disk_access (odr,DISK_READ,1,0,_CS,(uint)&sector)) return;
  sector [509] = dr;
  reset_disk (dr);
  if (absolute_disk_access (dr,DISK_WRITE,1,0,_CS,(uint)&sector)) { puts (ERROR);return;}

  puts ("\n\rwriting kernel sectors ...");

  for (i=1;i<=17;i++)
   {
   writedword (i);
  if (absolute_disk_access (odr,DISK_READ,1,i,_CS,(uint)&sector)) return;
  if (absolute_disk_access (dr,DISK_WRITE,1,i,_CS,(uint)&sector)) return;

   }
  puts (nl);
  puts (success);
 }

void up (char* prompt)
{
 char i;
 i = strlen (prompt)-2;
 for (; (i>=0) && (prompt[i] != ':') ; i--)
  if (prompt [i] == '/') { prompt [i+1] = 0; break; }
}


void process (char* prompt, char* dir)
{
 char i,j;

 j =0; i =0;

 temp [j] = 0;
 if (dir[0] == '/') { prompt[0] = '/'; prompt [1] = 0; i++;};

 for (; i<=strlen (dir) ; i++)
 {
  if ( (dir [i] == '.') && (dir [i+1] == '/')) { i = i+1; }
  else if ( (dir [i] == '.') && (dir [i+1] == '.') && (dir [i+2] == '/'))
   {
    up (prompt);
    i = i+2;
   }
  else if ( dir [i] == '/')
  {
   temp [j] = '/';
   temp [j+1] = 0;
   strcat (prompt,temp);
   j =0; temp [j] = 0;
  }
  else temp [j++] = dir [i];
 }
}

 void change_directory (char* new_dir)
 {
  int x1=0;
  int dummy=0;
  unsigned long tempDIR;
  x1 = strlen (new_dir);

  if ( new_dir [x1-1] == '/') { new_dir [x1] = '.';
					      new_dir [x1+1] = 0;
					    }
  else { new_dir [x1] = '/';
	 new_dir [x1+1] = '.';
	 new_dir [x1+2] = 0;
       }

  tempDIR = chdir (new_dir);
  if (tempDIR == 0xffffffff) { puts (ERROR);
				       return ;
				     }
   process (prompt,new_dir);
   }

void doCmd (char* cmd)
{
    if (!strcmp ((string)get_argz(cmd,1),"ls")) dir(0);
    else if (!strcmp ((string)get_argz(cmd,1),"dir")) dir(0);
   else if (!strcmp ((string)get_argz(cmd,1),"ds")) {	   puts (nl);
						 puts ("max_addr: ");writedword (DISK_STATE.max_addr);
						 puts (" bitmap:   ");writedword (DISK_STATE.bitmap_size);
					       }
   else if (!strcmp ((string)get_argz(cmd,1),"mkdir")) {
							  if (!mkdir (get_argz(cmd,2))) puts (ERROR); }
   else if (!strcmp ((string)get_argz(cmd,1),"rmdir")) {
							if (!rmdir (get_argz(cmd,2))) puts (ERROR); }
   else if (!strcmp ((string)get_argz(cmd,1),"cd")) change_directory (get_argz(cmd,2));
   else if (!strcmp ((string)get_argz(cmd,1),"mem")) { puts (nl);
                                                      puts ("Memory usage:"); puts (nl);
                                                      puts (" used blocks: ");writedword (avail()); puts (nl);
                                                      puts (" used memory: ");writedword (avail()<<4); puts (nl);
                                                      puts (" free memory: ");writedword ( 458752 - (avail()<<4) );

                                                }
   else if (!strcmp ((string)get_argz(cmd,1),"rem")) ;
   else if (!strcmp ((string)get_argz(cmd,1),"#"));
   else if (!strcmp ((string)get_argz(cmd,1),"ver")) { puts (nl); puts (nl); puts ("QuickDreamOS Version 0.5"); puts (nl); puts (nl);}
   else if (!strcmp ((string)get_argz(cmd,1),"color"))
   {
    if (!strcmp ((string)get_argz(cmd,2),"on")) iscolor =1;
    if (!strcmp ((string)get_argz(cmd,2),"off")) iscolor =0;
   }
   else if (!strcmp ((string)get_argz(cmd,1),"setpath")) {
						       strcpy ((string)get_argz(path,path_count)+strlen((string)get_argz(path,path_count))+1
						       ,(string)get_argz(cmd,2));
						       path_count++;
						      }
   else if (!strcmp ((string)get_argz(cmd,1),"size")) {
						       puts (nl);
						       file1 = fopen (get_argz(cmd,2));
						       if (file1 <2) return;
						       else writedword (fsize(file1));
						      }
   else if (!strcmp ((string)get_argz(cmd,1),"pic")) { if (!is_xsh ()) pic ((string)get_argz(cmd,2),get_argz(cmd,3)[0] ); }
   else if (!strcmp ((string)get_argz(cmd,1),"device")) exec (get_argz(cmd,2),_CS,(unsigned int)buf,0);
   else if (!strcmp ((string)get_argz(cmd,1),"pwd")) puts (prompt);
   else if (!strcmp ((string)get_argz(cmd,1),"chmod")) {
							//puts (nl);
							file1 = fopen (get_argz(cmd,3));
							if (file1 <2) return;
							if ( (string)get_argz(cmd,2)[0] == 'x') setattr (file1,0xc);
							if ( (string)get_argz(cmd,2)[0] == 'a') setattr (file1,0xb);
							if ( (string)get_argz(cmd,2)[0] == 's') setattr (file1,0xd);
						       }
   else if (!strcmp ((string)get_argz(cmd,1),"rm")) {
						  puts (nl);
						  file1 = fopen (get_argz(cmd,2));
                                                  if (file1 <2) { puts (ERROR); return;}
						  if (!fremove(file1)) puts (success);
						}
   else if (!strcmp ((string)get_argz(cmd,1),"clear")) { if (!is_xsh()) asm { mov ax,3 ; int 0x10 ; } }
   else if (!strcmp ((string)get_argz(cmd,1),"halt"))  { batch ("/etc/shut.rc");quit=1;}
   else if (!strcmp ((string)get_argz(cmd,1),"exit"))  quit=1;
   else if (!strcmp ((string)get_argz(cmd,1),"gui"))  gui=1;
   else if (!strcmp ((string)get_argz(cmd,1),"off")) isecho = 0;
   else if (!strcmp ((string)get_argz(cmd,1),"on")) isecho = 1;
   else if (!strcmp ((string)get_argz(cmd,1),"echo")) {  x = isecho; isecho=1;puts (nl); puts ((string)get_argz(cmd,1)+5);isecho=x; }
   else if (!strcmp ((string)get_argz(cmd,1),"mkfs")) {
							 if (get_argz(cmd,2)[0] == 'a') format_disk (0x00);
							 if (get_argz(cmd,2)[0] == 'c') format_disk (0x80);
							}
   else if (!strcmp ((string)get_argz(cmd,1),"sethostname")) ;//strcat (prompt,(string)get_argz(cmd,2));
   else if (!strcmp ((string)get_argz(cmd,1),"c:")) {
						      chdir ("c:/.");
                                                      change_disk (0x80);
						      usedrive = 'c';
						    }
   else if (!strcmp ((string)get_argz(cmd,1),"a:")) {
						      chdir ("a:/.");
						      change_disk (0x00);
						      usedrive = 'a';
						    }
   else if (!strcmp ((string)get_argz(cmd,1),"pause")) getch();
   else if (!strcmp ((string)get_argz(cmd,1),"sys")) {
							 if (get_argz(cmd,2)[0] == 'a') syst (0x00);
							 if (get_argz(cmd,2)[0] == 'c') syst (0x80);
						     }
   else if (!strcmp ((string)get_argz(cmd,1),"cp")) {

						  file1 = fopen (get_argz(cmd,2));
						  puts ("\n\rread,");
						  if (file1 <2) { puts (ERROR);
								  return;

								}
						  file2 = fcreate (get_argz(cmd,3));
						  puts ("write\n\r");
						  if (file2 <2) { puts (ERROR);
								  return;
								}
						  if (!fread (file1,fsize(file1),0,0x9000)) {puts (ERROR); return;}
						  if (!fwrite (file2,fsize(file1),0,0x9000)) {puts (ERROR); return;}

						  puts (success);
						 }
  else if (!strcmp ((string)get_argz(cmd,1),""));
  else   {

	  if ( ((string)get_argz(cmd,1)[0] == '/'))
	  {
	   file2 = fopen (get_argz(cmd,1));
	   if (file2 <2) { puts (bad_opcode);
			}
	   else exec (get_argz(cmd,1),_CS,(unsigned int)buf,1);
	  }
	  else
	  if ( ((string)get_argz(cmd,1)[0] == '.') && ((string)get_argz(cmd,1)[1] == '/'))
	  {
	   file2 = fopen (get_argz(cmd,1)+2);
	   if (file2 <2) { puts (bad_opcode);
			}
	   else exec (get_argz(cmd,1)+2,_CS,(unsigned int)buf,1);
	  }
	  else
	  {
	   for (x=1; x<=path_count; x++)
	   {
	    memset ( _CS,(uint)temp,100,0 );
	    strcpy ( temp,(string)get_argz(path,x));
	    strcat ( temp,(string)get_argz(cmd,1));
	    file2 = fopen (temp);
	    if (file2 <2);
	    else { exec (temp,_CS,(unsigned int)buf,1); break; }
	   }
	  if (file2 <2)
	  puts (bad_opcode);
	  }
	 }
}

 void clearBufferSegment (void)
 {
  asm {
	push ax
	push cx
	push es
	push di
	mov ax,bufferbatch
	mov es,ax
	mov di,0
        mov cx,0xfff0
	mov ax,0
	rep stosb
	pop di
	pop es
	pop cx
	pop ax
      }
 }

 char peekchar (uint ofs)
 {
  asm {
	push ds
	push si
	mov ax,bufferbatch
	mov ds,ax
	mov si,ofs
	lodsb
	pop si
	pop ds
      }
 }

 int file_offset;

 int fgets (char* s)
 {
  int i;
  for (i=0; (peekchar (file_offset+i) != 13) && (peekchar (file_offset+i) != 0);i++) s[i] = peekchar (file_offset+i);
  if (peekchar (file_offset+i) == 0) return 0;
  s[i] = 0;
  file_offset += i+2;
  return 1;
 }

 void batch (char* batchfile)
 {
  handle bfile;

  bufferbatch = malloc (0xfff);

  if (!bufferbatch) return;
  clearBufferSegment ();

  bfile = fopen (batchfile);
  if (bfile < 2) {      puts ("\n\rscript> file '");
			puts (batchfile);
			puts ("' can't be found.");
			return; }
  fread (bfile,fsize (bfile),0,bufferbatch);
  file_offset = 0;
  while ( fgets (cmdsh) )
  {
   memset (_CS,(uint)buf,100,0);
   strcpy (buf,cmdsh);
   doCmd (cmdsh);
   memset (_CS,(uint)cmdsh,100,0);
  }
  free (bufferbatch);
 }

 void far shell (void)
 {
  _DS = _CS;

  while (1)
  {
   puts (nl);
   cputc (usedrive,7); cputc (':',7);cputs (prompt,7); cputc ('>',7);
   memset (_CS,(uint)cmdsh,100,0);
   gets (cmdsh,100);
   memset (_CS,(uint)buf,100,0);
   strcpy (buf,cmdsh);

   if ( !strcmp ((string)get_argz(cmdsh,1),"make")) batch ("Makefile");
   else if ( ((string)get_argz(cmdsh,1))[0] == '$') batch ( (string)get_argz(cmdsh,1)+1);
   else if ( ((string)get_argz(cmdsh,1))[0] == '@')
   {
    doCmd (cmdsh+1);
    quit = 1;
   }
   else {
	   doCmd (cmdsh);
           _DS = _CS;
        }
   if (quit) break;
  }
 quit = 0;
 }

 void main ()
 {

  get_disk_state (&DISK_STATE);

 // prompt [0] = '[';
 // login (_CS,(uint)prompt+1);

  prompt [0] = '/';
  prompt [1] = 0;

  usedrive = (get_boot_drive () == 0x80) ? 'c' : 'a';

  batch ("/etc/init.rc");

  asm {
        push si
        push di
	push ax
        mov si,ds
        mov di,offset shell
        mov ah,1
        int 0x46
        pop ax
        pop di
        pop si
      };


//  strcat (prompt," ");
  puts (nl);

  if (gui) exec ("/bin/xsh",0,0,1);

  shell ();

 }
