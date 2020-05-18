.model tiny
.code
org 100h

;===============================================================================
		VIDEOSEG equ 0b800h
		COLOR equ 40h			;0010 0000 
		COLOR_SHD equ 30h 		;0011 0000
		NEXT_LINE equ 80 * 2
;===============================================================================
DELAY 		macro
		mov cx, 1h
		mov ah, 86h
		int 15h
		endm
;===============================================================================
start:		mov bx, VIDEOSEG
		mov es, bx		

		call draw_anim_frame

		mov ax, 4c00h
		int 21h
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Draws frame with animation
; Input:frame style
;	x, y coord of centre
;	n-coloms n-lines (n-coloms >= 10, n-lines > 6)	
;
; Destr: ax, bx, cx, dx, di, si
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Draw_anim_frame	proc

		call getint
		mov si, cx
		
		call getint        		;
		mov dh, cl                      ; input x, y of center 
		call getint                     ;
		mov dl, cl     	                ; and
		push dx
		call getint                     ;
		mov dh, cl                      ; lenght of line
		call getint	                ; n-coloms
		mov dl, cl		  	;
		mov bx, dx			; ah - x-coord center
		pop dx				; al - y-coord center
		mov ax, dx			; bh - n-coloms
						; bl - n-lines

		cmp si, 1			; if 1
		jne m2				; 
		mov si, offset arr1		; first style
		jmp found			;

m2:		cmp si, 2			; if 2
		jne notfound			;
		mov si, offset arr2		; second style
		jmp found			;

notfound:	mov si, offset newarr		; else
		push si				; input 7
		push ax				; symbols
		mov cx, 7d			;
scan:		mov ah, 01h			;
		int 21h				;
		mov byte ptr [si], al		;
		int 21h				;
		inc si				;
		loop scan			;
		
		pop ax	
		pop si

found:
		mov cx, 6d                      ; 
		sub bh, 12d                     ; dec n-coloms 12
		sub bl, 6d		        ; dec n-lines  6
		push ax	                        

frame_again:    push cx                         
	        push bx                        
	        push ax                        

		call Drawframe                  ; Draws frame 
       		DELAY	                        ;
		
		pop ax                          
		pop bx                          
		add bh, 2                       ; inc n-coloms 2
		add bl, 1                       ; inc n-lines  1

		pop cx                          ; 
		loop frame_again                ;


		pop ax                          ;
		mov bx, offset Msg              ; Print str in frame
		sub ah, 3d                      ;
		call puts_in_vid                ;

                
                ret
                endp


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Entry:ah - x-coord center
;	al - y-coord center
;	
;	bh - n-colomns
;	bl - n-lines
;	
;	si - &arr frame style
; Destr: ax, bx, cx, dx, di
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
drawframe	proc
		
		push si
		sub bl, 2		
		sub bh, 2

		mov dx, bx				; finds x, y coords of
		shr dh, 1       		        ; top left	
		shr dl, 1       		        ; angle
		sub ah, dh    			        ;
		sub al, dl    		         	;
		
		mov dl, ah      		        ;
		mov ah, 80d     		        ; converts x, y coords 
		mul ah
		xor dh, dh          		        ; to byte in
		add ax, dx      		        ; videoseg
		mov di, ax     			        ;
		shl di, 1            	  		;      	
               	mov dx, bx	       			;
		                                	
		xor cx, cx             			; mov cx length line
		mov cl, dh             			;

			
		mov al, [si]				; put symbols into: al	
		inc si                                  ; 
		mov bl, [si]                            ; bl
		inc si                                  ;
		mov bh, [si]                            ; bh
		inc si                                  ;
		mov ah, COLOR                           ; to call Line_in_vid


		push di		                	;
		call Line_in_vid                        ; draws line
		pop di                                  ;

		add di, NEXT_LINE		        ; jump next line
		mov cl, dl	                        ; mov cx n-coloms
		mov bx, (0bah shr 8) or 0               ;
		mov bh, [si]
		xor bl, bl

			                                        
line:		push cx                                 ;
		push di	                                ; 
		mov cl, dh                              ; mov cx line length
		mov al, [si]				;
		mov ah, COLOR		                ;
		call Line_in_vid                        ;

		mov ax, (COLOR_SHD shl 8) or 0          ; draws shadow
		call Drawchar                           ;

	        pop di                                  ;
	        add di, NEXT_LINE                       ; jump next line
	        pop cx                                  ; while cx > 0
	        loop line                               ;
		inc si


	        mov cl, dh                              ; 
		mov ah, COLOR                           ;
		mov al, [si]                            ; puts symbols into: al	
		inc si                                  ;
		mov bl, [si]                            ; bl
		inc si                                  ;
		mov bh, [si]                            ; bh
							; to draw line
		
       		push cx                                 ; Draws bot line 
		push di                                 ; with right shadow
		call Line_in_vid                        ;
		mov ax, (COLOR_SHD shl 8) or 0          ;
		call Drawchar                           ;

		pop di                                  ;
		add di, NEXT_LINE + 2                   ;
		pop cx                                  ; Draws bot
		mov bx, 0h		                ; shadow
		mov ax, (COLOR_SHD shl 8) or 0h         ;
		call Line_in_vid                        ;
                
		pop si
		ret
		endp
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 
; Entry: ah - color attr
;	 al - left char to draw
;	 bl - middle char to draw
;	 bh - right char to draw
;	 cx - line length
;	 di - coord
; Exit:  cx is 0
; Destr: ax bx di 
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Line_in_vid 	proc

                stosw
                mov al, bl
                rep stosw
                mov al, bh
                stosw

		ret
		endp	
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Entry: ah - color attr
;	 al - char to draw
;	 di - coord
; Destr: cx es 	
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Drawchar	proc

                stosw

                ret
		endp
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Scan int
; return cx
; destr ax, bx
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
getint		proc

		mov ah, 01h
		int 21h

		sub al, 30h
		mov ah, 0
		mov bl, 10d
		mov cl, al

getsimb:	mov ah, 01h
		int 21h		
		cmp al, 0dh
		je endscan
		cmp al, 20h
		je endscan
		sub al, 30h

		xchg al, cl
		mul bl
		add cl, al

		jmp getsimb

endscan:
		ret
		endp				
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Print str in video
;Input: ah - x
;	al - y
;	bx - str pointer
;Destr: ax, bx, dx
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
puts_in_vid	proc
			
		mov dl, ah
		mov ah, 80d
		mul ah
		add al, dl	
		mov di, ax
		shl di, 1
		
		mov ah, COLOR

print:		mov al, [bx]
		stosw
		inc bx
		cmp al, 0
		loopne print

		ret
		endp




Msg:		db 'Hello', 0
arr1:	db 0c9h, 0cdh, 0bbh, 0bah, 0c8h, 0cdh, 0bch
arr2:	db 0dah, 0c4h, 0bfh, 0b3h, 0c0h, 0c4h, 0d9h
newarr: db 0   , 0   , 0   , 0   , 0   , 0   , 0 			
