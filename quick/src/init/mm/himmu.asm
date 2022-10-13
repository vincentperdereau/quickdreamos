 jmp hi_mmu_start

HiMemoryControlBlock struc
; state         db 0
; size          dd 0
ends

hi_mmu_mcb_entry equ 300000h ; 200000h
hi_mmu_mcb_free equ

hi_mmu_malloc:
 mov ebx,hi_mmu_mcb_entry

 mov al,fs:ebx


hi_mmu_start:
