; ** hostname.s

mov ah,$16  ; function GET$LOG
int $44     ; call kernel
mov ah,$10  ; function PRINT$LN
int $44     ; call kernel
retf        ; return to caller
