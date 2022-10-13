;***************************
;**   Loading of Driver   **
;***************************
; Support for loading PNP Soundcard initialziation program
; Works at the moment only with Soundcards that have a CS4235 chipset.
; written by Heinz Rath
; Version 1.0 (Date: 1.8.2000)
; email: heinz.rath@gmx.at
; CS4235 is loaded at 4000:0000h
; After initializing the driver isn't needed any more.

                        push ds
                        push si
                        push eax
                        push ecx
                        push edx
                        push es

                        sti
                        xor ax,ax
                        ; The file is opened to see if it exist 
                        ; Opens the "cs4235" file
                        mov  ah,API$FOPEN
                        mov  si,offset cs4235driver
                        int KERNEL$INT      
                        cmp eax,2
                        jl loaded

                        mov edx,eax   
                        push edx
                        mov  ah,API$FSIZE
                        int KERNEL$INT      

                        ; Load and execute the driver
                        pop edx
                        mov ax,4000h
                        mov es,ax
                        mov  ah,API$FREAD
                        mov  di,0000
                        int KERNEL$INT      

                        mov ah,API$PRINTLN
                        mov si,offset loaddone
                        int KERNEL$INT
                        DB 09Ah
                        DW 0000
                        DW 4000h
                        mov     ax,cs
                        mov     ds,ax
                        xor ax,ax
                        mov ah,API$PRINTLN
                        mov si,offset initdone
                        int KERNEL$INT
                        jmp loaded
cs4235driver            DB "/lib/cs4235",0
loaddone                DB 13,10,13,10,"cs4235: ",0
initdone                DB "initialized",0
loaded:                 pop es
                        pop edx
                        pop ecx
                        pop eax
                        pop si
                        pop ds
