.model tiny
.code
org 100h

start:		

;		mov di, offset StrCHA1
;		mov al, 'a'
;		mov cx, 11d
;		call memchr
;		mov ax, 09h
;		mov bx, offset numb
;		mov byte ptr [bx], di
;		mov dx, bx
;		int 21h

;		mov di, offset StrCHA2
;		mov al, 'b'
;		mov cx, 7d
;		call memset
;		mov ax, 09h
;		mov dx, offset SreCHA2
;		int 21h



;		mov si, offset StrCHA1
;		mov di, offset StrCHA2
;		mov cx, 7d
;		call memcpy
;		mov ax, 09h
;		mov dx, offset StrCHA2
;		int 21h

				
;		mov si, offset StrCHA1
;		mov di, offset StrCHA2
;		mov cx, 7d
;		call memcmp
;		mov ax, 09h
;		mov bx, offset numb
;		add di, '0'
;		mov byte ptr [bx], di
;		mov dx, bx
;		int 21h
		
;		mov si, offset StrHello1
;		mov di, offset StrHello2
;		mov cx, 7d
;		call strcmp
;		mov ax, 09h
;		mov bx, offset numb
;		add di, '0'
;		mov byte ptr [bx], di
;		mov dx, bx
;		int 21h
		
		
		
;		mov si, offset StrHello2
;		mov di, offset StrHello3
;		mov cx, 7d
;		call strcmp
;		mov ax, 09h
;		mov bx, offset numb
;		add di, '0'
;		mov byte ptr [bx], di
;		mov dx, bx
;		int 21h



;		mov di, StrCHA1
;		call strlen
;		mov ax, 09h
;		mov bx, offset numb
;		add di, '0'
;		mov byte ptr [bx], di
;		mov dx, bx
;		int 21h




;		mov di, StrHello1
;		mov al, 'l'
;		call strchr
;		mov ax, 09h
;		mov bx, offset numb
;		mov byte ptr [bx], di
;		mov dx, bx
;		int 21h



;		mov di, StrHello1
;		mov al, 'l'
;		call strrchr
;		mov ax, 09h
;		mov bx, offset numb
;		sub di, bx
;		add di, '0'
;		mov byte ptr [bx], di
;		mov dx, bx
;		int 21h

		
		
;		mov si, offset StrHello2
;		mov di, offset StrHello3
;		mov cx, 7d
;		call strcpy
;		mov ax, 09h
;		mov dx, offset StrHello3
;		int 21h
	
	
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
; Exit          ax : = 0 (s1 = s2); < 0 (s1 < s2); > 0 (s1 > s2)
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
; Find length of string
; Entry:	di - pointer of start str
;               
; Exit          ax - len
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
; Find first enter char
; Entry:	di - pointer of start str
;		al - char to find               
;
; Exit          di - pointer finding char
;
; Destr:	cx, di     		
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
strchr 		proc
		
                or cx, 0FFFFh
@@loop:	        cmp byte ptr [di], 0h
		je @@endstr
		cld
		repne scasb
		jne @@loop
		
@@endstr:	dec di
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
; Copy second string in first string
; Entry:	di - pointer of start of first string
;               si - pointer of start of second srting
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
; Cmp strings
; Entry:	di - pointer of start of first string
;               si - pointer of start of second srting
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
		mov ax, [di]

		
		ret
		endp
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


StrCHA1: 	db 'CHA cha cha', 00h, '$'
StrCHA2: 	db 'CHa chA', 00h, '$'
StrHello1:	db 'Hello', 00h, '$'
StrHello2:	db 'hello', 00h, '$'
StrHello3:	db 'hello', 00h, '$'

numb:		db ' ', '$' 



end start
