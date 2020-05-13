section			.code

PTR_SIZE		equ 4d




global 			_start

_start:			

;				push string
;				push 100d
;				push test1
;				call printf

;				push 'A'
;				push -15
;				push test2
;				call printf
			
;				push 127d
;				mov ecx, [number]
;				push ecx
;				push 3802d
;				push love
;				push dedtest
;				call printf




				push 127d
				push '!'			
				mov ecx, [number]
				push ecx
				push 3802d
				push love
				push newtest
				call printf






;				push 842d
;				push 842d
;				push 842d
;				push 842d
;				push test3
;				call printf


				mov eax, 1
				xor ebx, ebx
				int 0x80
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;Input:	stack: format string and parametrs
;
;Destr: eax, ebx, ecx, edx
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
printf:			push ebp
				mov ebp, esp
				mov ecx, [ebp + 8]
				add ebp, 12

nextsimb:		cmp byte [ecx], 0			;
				je endstr			;
				cmp byte [ecx], '%'		;		
				je format_percent		;single  		
				mov eax, 4			;char
				mov ebx, 1			;processing	
				mov edx, 1			;		
				int 0x80			;		
				inc ecx				;		
				jmp nextsimb			;
												
format_percent:	mov ebx, jmp_table				;
								;
				inc ecx				;
				cmp byte[ecx], '%'		;percent
				je percent 			;processing
				cmp byte[ecx], 'b'		;
				jb wrongsimb			;
				cmp byte [ecx], 'x'		;
				ja wrongsimb			;


				mov al, 'b'			;
				xor edx, edx			;
next:			cmp al, byte[ecx]			;finding
				je found_simb			;case in
				inc al				;jmp table
				inc edx				;
				jmp next


found_simb:		push ecx				;
				jmp [ebx + edx * PTR_SIZE]	;jmp to func


str:			mov ecx, [ebp]				;
				call printstring		; %s
				jmp printed 			;


char:			mov ecx, [ebp]				;
				mov ebx, bufchar		;
				mov byte [ebx], cl 		;
				mov ecx, bufchar		; %c
				call printchar			;
				jmp printed 			;


dec:			mov ecx, [ebp]				;
				mov ebx, 10			; %d
				call printdec			;
				jmp printed 			;


hex:			mov ecx, [ebp]				;
				mov ebx, 16			; %x
				call print_pow2			;
				jmp printed 			;


oct:			mov ecx, [ebp]				;
				mov ebx, 8			; %o
				call print_pow2			;
				jmp printed 			;


bin:			mov ecx, [ebp]				;	
				mov ebx, 2			; %b
				call print_pow2 		;
				jmp printed 			;


percent:		mov eax, 4				;
				mov ebx, 1			; %%
				mov edx, 1			;
				int 0x80			;
				jmp simbprinted			;

printed: 		add ebp, 4				;go to next param in stack
				pop ecx				;
				jmp simbprinted			;

wrongsimb:		mov eax, 4				;
				mov ebx, 1			; 
				mov edx, 1			;
				int 0x80			;
				

				jmp endstr			;

simbprinted:	inc ecx						;
				jmp nextsimb			;

endstr:			pop ebp							
				ret

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;print str
;Input:	ecx - string ptr
;
;Destr: eax, ebx, ecx, edx
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
printstring:		mov eax, 4
			mov ebx, 1
			mov edx, 1

			int 0x80
			inc ecx
			cmp byte [ecx], 0
			jne printstring
			ret	
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;print one char
;Input: ecx - char ptr
;
;Dertr: eax, ebx, ecx, edx
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
printchar:		mov eax, 4
			mov ebx, 1
			mov edx, 1
			int 0x80

			ret

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;print decimal number
;Input: ecx - numb 
;
;Destr: eax, ebx, ecx, edx, edi
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
printdec:		test ecx, 80000000h				;
			je .positive					; if ecx > 0
												
			push ecx					;
			push ebx					;
				
			mov eax, 4					;
			mov ebx, 1					;
			mov ecx, minus					;print '-'
			mov edx, 1					;
			int 80h 					;
				
			pop ebx						;
			pop ecx						;

			neg ecx						;ecx *= -1

.positive:		mov eax, ecx					;
				xor ecx, ecx				;

.putinstk:		xor edx, edx					;
				div ebx					;
				push edx				;put 
				inc ecx					;simbs
				test eax, eax				;in stack
				jne .putinstk				;

				mov edi, simbol 			;

.printnumbs:	pop edx							;

				add edx, '0'				;
				mov [edi], edx				;

				mov eax, 4				;
				mov ebx, 1				;
				push ecx				;print
				mov ecx, edi				;numb
				mov edx, 1				;
				int 80h 				;
				pop ecx					;
				loop .printnumbs			;

				ret	



;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;print decimal number in base 2 / 8 / 16
;Input: ecx - numb 
;		ebx - numb systen base
;
;Destr: eax, ebx, ecx, edx, edi
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print_pow2:		cmp ecx, 0  					
			je .zero
			mov edi, str_bin_pow

			test ecx, 80000000h				;
			je .positive					; if > 0
												
			push ecx					;
			push ebx					;
				
			mov eax, 4					;
			mov ebx, 1					;
			mov ecx, minus					;print '-'
			mov edx, 1					;
			int 80h 					;
				
			pop ebx						;
			pop ecx						;

			neg ecx						;ecx *= -1

.positive:		mov eax, ecx

			cmp ebx, 16					;
			je .hex						;finding 
			cmp ebx, 2					;base of 
			je .bin 					;number
			cmp ebx, 8					;system
			je .oct 					;

			jmp .printed

.bin:			mov ecx, 1					;ecx - n bits
			mov esi, 1b 					;shift
			xor ebx, ebx					;esi last N(pow 2) bits
			jmp .next_simb					;

.oct:			mov ecx, 3					;
			mov esi, 111b 					;
			xor ebx, ebx					;
			jmp .next_simb					;

.hex:			mov ecx, 4					;
			mov esi, 1111b					;
			xor ebx, ebx 					;
			jmp .next_simb 					;




.next_simb:		cmp eax, 0					;
			je .endnumb					;
			mov edx, eax					;put
			and edx, esi 					;chars 
			mov [edi + ebx], dl				;in 
			inc ebx						;buf
			shr eax, cl 					;
			jmp .next_simb					;

.endnumb		mov ecx, ebx
			dec edi				

.printnumbs:		push ecx					;
			add ecx, edi					;conversing
			cmp byte[ecx], 10				;to 
			jb .decimal					;ascii
			add byte[ecx], 'A' - 10				;
			jmp .print 					;

.decimal		add byte[ecx], '0'				;
				
.print			mov eax, 4					;
			mov ebx, 1					;print
			mov edx, 1					;simbs
			int 80h 					;
			pop ecx						;
			loop .printnumbs				;

			jmp .printed 					;



.zero:			mov ecx, simbol	 				;
			mov byte[ecx], '0'				;
			mov eax, 4					;if input 
			mov ebx, 1					;number == 0
			mov edx, 1					;
			int 80h 					;


.printed:		ret




;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
section			.data




newtest:		db "I %% %s %x %d%%%c %b", 10, 0		;
test1:			db "%x, yes, you, %s ", 0ah, 0			;format
test2:			db "%b %c ARRRRRRR ", 0ah, 0			;strings
test3:			db "%x %o %b %d", 0ah, 0			;
dedtest:		db "I %s %x. %d%%%b", 10, 0			;





number			dd 100d						;
love:			db "LOVE", 0					;
Char:			db 'W'						;
Msg:			db "Hey, You", 0				;	
string:			db "HELLO", 0					;






jmp_table:		dd bin,						;%b
			dd char, 					;%c
			dd dec,						;%d
			times ('o' - 'd' - 1) dd wrongsimb,
			dd oct,						;%o
			times ('s' - 'o' - 1) dd wrongsimb,  
			dd str,						;%s
			times ('x' - 's' - 1) dd wrongsimb,  
			dd hex						;%x




str_bin_pow     times 64 db '0' 
minus:			db '-'
simbol:			db 0
bufchar:		db 0
