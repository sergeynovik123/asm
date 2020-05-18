.model tiny
.code
org 100h

start:


		ret

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Find byte in mem
; Entry:	di - pointer of start pos
;              	al - byte to find
;               cx - number of bytes in mem
;
; Exit:		di - pointer of finding byte
; Destr:	cx     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
memchr 		proc
		
		cld
		repne scasb
		
		ret
		endp



;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Fill byte in mem
; Entry:	di - pointer of start pos
;              	al - byte to fill
;               cx - number of bytes in mem
;
; Exit:
; Destr:	cx, di     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
memset 		proc
		
		cld
		repne stosb
		
		ret
		endp


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Copy piece of mem from source to destination
; Entry:	si - pointer of start pos in source
;               di - pointer of start pos in destination
;               cx - number of bytes in mem
;
; Exit
; Destr:	cx, di, si     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
memcpy 		proc
		
		cld
		rep movsb
		
		ret
		endp


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Cmp to piece of mem
; Entry:	di - pointer of start in first
;               si - pointer of start in second
;               cx - number of bytes in mem
;
; Exit          ax
; Destr:	cx, di, si     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
memcmp 		proc
		
		cld
		repe cmpsb
				
		dec si
		dec di
		mov ax, [si]
		sub ax, [di]

		
		ret
		endp


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Cmp to piece of mem
; Entry:	di - pointer of start str
;               
; Exit          ax
	; Destr:	cx, di     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
strlen 		proc
		
		xor al, al
                or cx, 0FFFFh
                cld
		repne scasb

		or ax, 0FFFFh
		sub ax, cx
		inc ax	
		
		ret
		endp


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Find first entering char
; Entry:	di - pointer of start str
;		al - char to find               
; Exit          di - pointer finding char
; Destr:	cx, di     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
strchr 		proc
		
		xor di, di
                or cx, 0FFFFh
                cld
		repne scasb
		dec di	
		
		ret
		endp

	


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Find last entering char
; Entry:	di - pointer of start str
;               
; Exit          si
; Destr:	cx, di     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
strrchr		proc
		
                or cx, 0FFFFh
                xor si, si
                cld

@@repnez:	cmp byte ptr [di], 0h
		je @@strend
		scasb
		jne @@repnez
		mov si, di
		jmp @@repnez
		
@@strend:

		ret
		endp


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Copy piece of mem from source to destination
; Entry:	si - pointer of start pos in source
;               di - pointer of start pos in destination
;               cx - number of bytes in mem
;
; Exit
; Destr:	cx, di, si     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
strcpy 		proc
		
		or cx, 0FFFFh
		cld

@@notzero:	cmp byte ptr [di], 0h
		je @@endstr		
         	movsb
         	jmp @@notzero
@@endstr:
		ret
		endp


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Cmp to piece of mem
; Entry:	di - pointer of start in first
;               si - pointer of start in second
;               cx - number of bytes in mem
;
; Exit          ax
; Destr:	cx, di, si     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
strcmp 		proc
		
		mov cx, 0FFFFh
		cld
		
@@cmp:		cmp byte ptr [si], 0h
		je @@endstr
		cmp byte ptr [di], 0h
		je @@endstr
		cmpsb
		jne @@endstr
		je @@cmp
@@endstr:		
		dec si
		dec di
		mov ax, [si]
		sub ax, [di]

		
		ret
		endp
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


Msg1: db 'CHA cha cha', 00h

Msg2: db 'CHa chA', 00h


end start
