;;;nahi samajh aaye to puch lena;;;



read_string:
pusha
mov byte[len],0
mov dword[size],0
mov eax,0
mov ebx,string
read_loop:
pusha
mov eax,3
mov ebx,0
mov ecx,temp
mov edx,1
int 80h
popa
cmp byte[temp],10
je end_read
mov cl,byte[temp]
cmp cl,' '
je inc_eax
mov cl,byte[temp]
mov byte[ebx+eax],cl
inc eax
inc byte[len]
jmp read_loop

end_read:
mov byte[ebx+eax],' '
inc eax
mov byte[ebx+eax],0
cmp byte[len],0
je lll
inc dword[size]

lll:
popa
ret

 inc_eax:
 mov byte[ebx+eax],' '
 inc eax
 inc dword[size]
loop1:
cmp eax,20
ja end_loop1
mov cl,al
mov byte[ebx+eax],10
inc eax
jmp loop1
end_loop1:
 mov eax,20
 add ebx,eax
 mov eax,0
 jmp read_loop


print_string:
pusha
mov ebx,string
prints_loop:
cmp byte[ebx],0
je end_prints
mov cl,byte[ebx]
cmp cl,10
je inc_ebx
mov byte[temp],cl
pusha
mov eax,4
mov ebx,1
mov ecx,temp
mov edx,1
int 80h
popa

inc ebx
jmp prints_loop
end_prints:
popa 
ret

inc_ebx:
inc ebx
jmp prints_loop

print_num:
pusha
mov byte[count],0
cmp byte[num1],0
je print_zero
ext:

cmp word[num1],0
je print
inc byte[count]
mov dx,0
mov ax,word[num1]
mov bx,10
div bx
push dx
mov word[num1],ax
jmp ext

print:
cmp byte[count],0
je end_print
dec byte[count]
pop dx
mov byte[num1], dl
add byte[num1],30h
mov eax,4
mov ebx,1
mov ecx,num1
mov edx,1
int 80h

jmp print

end_print:
popa
ret

print_zero:
mov word[num1],30h
mov eax,4
mov ebx,1
mov ecx,num1
mov edx,1
int 80h
jmp end_print

section .data
newl : db 10
section .bss 

string : resb 1000
len : resd 1
temp : resd 1
array : resb 100
size : resd 1
count : resd 1
num1 : resd 1
temp1 : resd 1
temp2 : resd 1
i : resd 1
j : resd 1
k : resd 1
 section .text


 global _start:
 _start:

  mov ebx,string
  call read_string
  call remove_rep
  call print_string
  mov eax,1
  mov ebx,0
  int 80h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  remove_rep:
	pusha
	mov ebx,string
	mov dword[i],0

    loop_remi:                               
 		mov cl,byte[i]
		cmp cl,byte[size]
		jnb end_rem
		mov byte[j],cl
		inc byte[j]
        mov eax,20
	loop_remj:
        mov cl,byte[j]
		cmp cl,byte[size]
		jnb end_loopj
		jmp cmp_fullstring	
 

	end_loopj:
		inc byte[i]
		add ebx,20
		jmp loop_remi

	end_rem:
	popa 
	ret


cmp_fullstring:
	
		mov ecx,0
	loop_c:
		cmp ecx,20
		jnb equal
		mov dl,byte[ebx+ecx]
		add ecx,eax
		cmp dl,byte[ebx+ecx]
		jne end_equal
		cmp dl,' '
		jmp equal                                ;;;;;;;;;;;;;
		sub ecx,eax
		inc ecx
           jmp loop_c
		
		end_equal:
		inc byte[j]
		add eax,20
		jmp loop_remj


	equal:
	mov word[k],0
	mov ecx,eax
	loop_eq:
		cmp word[k],20
		jnb end_equal
		mov byte[ebx+ecx],10
		inc word[k]
		inc ecx
		jmp loop_eq