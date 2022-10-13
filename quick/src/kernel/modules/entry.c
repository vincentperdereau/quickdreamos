/*
 * quick/src/kernel/modules/entry.c
 *
 */

#include <typedef.h>

asm {
                mov dl,al

        jmp main_start

        LABEL DescTabl         // table des descripteurs
                DB 8 DUP(?)    // le 1er descripteur est toujours vide
                DW 0FFFFH      // longueur maximale
                DW 0           // adresse de base 0 (depuis le d‚but)
                DB 0           // idem
                DB 10010010b   // flags
                DB 11001111b   // accŠs
                DB 0           // base 0

        gdtref  DW 0FH         // taille de la GDT: 16 = car 2 descripteurs ( 8 * 2)
        l_ref   DW OFFSET DescTabl,0 // offset de la GDT
main_start:
        cli
        mov ax,1000H                   // es=ds=segment du kernel 1000h
        mov es,ax
        mov ds,ax
        mov eax,10000H                 // on pr‚sente l'adresse physique (1000h * 16 + 0 = 10000h)
        add [DWORD PTR l_ref],eax      // on l'ajoute … l'offset
        lgdt [FWORD PTR cs:gdtref]     // on charge la GDT dans le GDTR
        mov eax,cr0                    //
        or al,1                        // On bascule en mode prot‚g‚
        mov cr0,eax                    //
        jmp @@n                        // on vide la prefetch queue du cpu
        @@n:                           // ( = plus d'instructions )
        mov ax,8                       //
        mov fs,ax                      // fs=8 ie l'adresse du descripteur #1 
        mov eax,cr0                    //
        and al,0FEH                    // on revient en mode r‚el
        mov cr0,eax                    //
        mov ax,0x1000                  // fs: segment de 4 Gb de m‚moire !
        mov es,ax                      //
        mov ds,ax                      //
        sti
};

PROC kernel_entry (UCHAR);

PROC start_program (void)
{
 kernel_entry (_DL);  // le registre 'dl' contient le num‚ro du lecteur
                      // sur lequel le systŠme d‚marre.

}

