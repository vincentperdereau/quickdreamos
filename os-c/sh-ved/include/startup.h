void    main    (void);

void
startup    (void)
{
 asm {
        mov     ax,cs
        mov     ds,ax
        mov     es,ax
     }
        main ();
 asm { retf }
}


