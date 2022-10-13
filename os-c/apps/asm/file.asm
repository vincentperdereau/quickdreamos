.386P


MGRP    group   VPSEG

       assume CS:MGRP, DS:MGRP, ES:MGRP, SS:MGRP


VPSEG  segment byte public    

public _fopen
public _fcreate
public _fread
public _fwrite
public _fsize

_fopen  proc    near
	push	bp
	mov	bp,sp
	push	si
	push	    ds
	mov	     ax,cs
	mov	     ds,ax
	mov	     ah,00002H
	mov	     si,[bp+4]
	int	     044H
	mov	     edx,eax
	shr	     edx,16
	pop	     ds
	pop	si
	pop	bp
	ret	
_fopen  endp

	assume	cs:MGRP
_fcreate	proc	near
	push	bp
	mov	bp,sp
	push	    si
	push	    ds
	mov	     ax,cs
	mov	     ds,ax
	mov	     ah,00003H
	mov	     si,[bp+4]
	int	     044H
	mov	     edx,eax
	shr	     edx,16
	pop	     ds
	pop	si
	pop	bp
	ret	
_fcreate	endp

	assume	cs:MGRP
_fread	proc	near
	push	bp
	mov	bp,sp
	push	    es
	push	    di
	push	    ecx
	push	    edx
	mov	     ax,[bp+14]
	mov	     es,ax
	mov	     di,[bp+12]
	mov	     ecx,[bp+8]
	mov	     edx,[bp+4]
	mov	     ah,00004H
	int	     044H
	pop	     edx
	pop	     ecx
	pop	     di
	pop	     es
	pop	bp
	ret	
_fread	endp
	assume	cs:MGRP
_fwrite	proc	near
	push	bp
	mov	bp,sp
	push	    ds
	push	    si
	push	    ecx
	push	    edx
	mov	     ax,[bp+14]
	mov	     ds,ax
	mov	     si,[bp+12]
	mov	     ecx,[bp+8]
	mov	     edx,[bp+4]
	mov	     ah,00005H
	int	     044H
	pop	     edx
	pop	     ecx
	pop	     si
	pop	     ds
	pop	bp
	ret	
_fwrite	endp

	assume	cs:MGRP
_fsize	proc	near
	push	bp
	mov	bp,sp
	push	    ecx
	mov	     ah,0000cH
	mov	     edx,[bp+4]
	int	     044H
	mov	     eax,ecx
	mov	     edx,eax
	shr	     edx,16
	pop	     ecx
	pop	bp
	ret	
_fsize	endp

VPSEG  ends

END
