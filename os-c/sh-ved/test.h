void printf (char* format,...)
{

 va_list vl;

 va_start (vl,format);

 while (*format)
 {
  if (*format != '%')
   putc (*format);
  else
  {
   switch (*++format)
   {
    case 's':   puts ( va_arg(vl,char*) );
                break;

    default: 	putc (*format);

   }
  }
  format++;
  }
 va_end (vl);

}
