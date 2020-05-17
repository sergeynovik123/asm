.686
.MODEL FLAT, C
.CODE

hash_xor	PROC arg1:ptr byte
			
			mov eax, 0
			mov ebx, arg1
			xor ecx, ecx
nextsimb:
			cmp [ebx], ecx
			je endstr
			xor eax, [ebx] 
			rol eax, 1
			inc ebx
			jmp nextsimb
endstr:
			retn
hash_xor endp

END
