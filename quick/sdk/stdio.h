/* STDIO.H */

#ifndef NULL
 #define NULL 0
#endif

typedef struct
{
 unsigned long handle;
 unsigned int bseg;
 unsigned int bofs;
 unsigned int size;
 int op;
} far FILE;

/* CONIO PROTOS */
extern void printf (char* format, ...);
extern void putc (char c);
extern void puts (char* s);
extern void gets (char* buf, int c);

/* FILES ACCESS PROTOS */
extern FILE* fopen (char* fname, char* flag);
extern fread (void* buf, int size, int nelelm, FILE* fd);
extern fwrite (void* buf, int size, int nelelm, FILE* fd);
extern fseek (FILE* fd, long offset, int whence);
extern fclose (FILE* fd);
extern unsigned long fsize (FILE* fd);
extern char fgetc (FILE* fd);
extern char* fgets (char* buf, int len, FILE* f);

