section .data
msg1 db'enter the size of array',0ax
len1 equ $-msg1
msg2 db'the average is',0ax
len2 equ $-msg2
msg3 db'count of numbers above average is:',0ax
len3 equ $-msg3

section .bss
num resd 1
size resd 1
temp resb 1
num1 resd 1
count resd 1
array resd 100
counter resd 1
sum resd 1

section .text
global _start:

	read_num:
			pusha
			mov dword[num],0

			loop_read:
				mov eax,3
				mov ebx,0
				mov ecx,temp
				mov edx,1
				int 80h

				cmp byte[temp],0Ah
				je end_read
				mov eax,dword[num]
				mov ebx,10
				mul ebx
				mov bl,byte[temp]
				sub bl,30h
				mov bh,0
				add eax,ebx
				mov dword[num],eax
				jmp loop_read
			end_read:
				popa
				ret


		print_num:
			mov byte[count],0
			pusha
			extract:
				cmp dword[num],0
				je print
				inc byte[count]
				mov edx,0
				mov eax,dword[num]
				mov ebx,10
				div ebx
				push edx
				mov dword[num],eax
				jmp extract
				print:
					cmp byte[count],0
					je end_print
					dec byte[count]
					pop edx
					mov byte[temp],dl
					add byte[temp],30h
					mov eax,4
					mov ebx,1
					mov ecx,temp
					mov edx,1
					int 80h
					jmp print
				end_print:
					mov eax,4
					mov ebx,1
					mov ecx,0Ah
					mov edx,1
					int 80h
					popa
					ret

start_arrayread:
	pusha
	read_loop:
		cmp eax,dword[size]
		je end_read1
		call read_num
		mov ecx,dword[num]
		mov dword[ebx+4*eax],ecx
		inc eax
		jmp read_loop
		end_read1:
			popa
			ret


print_array:
	pusha
	print_loop:
		cmp eax,dword[size]
		je end_print
		mov ecx,dword[ebx+4*eax]
		mov dword[num],ecx
		call print_num
		inc eax
		jmp print_loop
	jstinc:
		inc dword[counter]
		inc eax
		jmp gear
counting:
	pusha
	gear:
	cmp eax,dword[size]
	jg fin
	mov ecx,dword[ebx+4*eax]
	cmp ecx,dword[sum]
	jg jstinc
	inc eax
	jmp gear
	
	fin:
		mov eax,dword[counter]
		mov dword[num],eax
		call print_num
		jmp exit

		
_start:
	mov eax,4
	mov ebx,1
	mov ecx,msg1
	mov edx,len1
	int 80h
	call read_num
	mov eax,dword[num]
	mov dword[size],eax
	mov ebx,array
	mov eax,0
	call start_arrayread
	;mov ebx,array
	;mov eax,0
	;call print_array
	mov eax,4
	mov ebx,1
	mov ecx,msg2
	mov edx,len2
	int 80h
	mov ebx,array
	mov eax,0
	mov dword[sum],0
    avg:
    	cmp eax,dword[size]
    	je end_avg
    	mov ecx,dword[ebx+4*eax]
    	add dword[sum],ecx
    	inc eax
    	jmp avg
    	end_avg:
    		mov edx,0
    		mov eax,dword[sum]
    		mov ebx,dword[size]
    		div ebx
    		mov dword[num],eax
    		mov dword[sum],eax
    		call print_num
   mov eax,4
    mov ebx,1
    mov ecx,msg3
    mov edx,len3
    int 80h
    mov ebx,array
    mov eax,0
    mov dword[counter],0
    call counting
exit:
	mov eax,1
	mov ebx,0
	int 80h