section .data
msg1: db 'Enter array size:',10
l1: equ $-msg1
msg2: db 'Enter array elements:',10
l2: equ $-msg2
msg3: db 'Not Found',10
l3: equ $-msg3
msg4: db 'Found at position: ',10
l4: equ $-msg4
msg5 : db 'Enter the element u want to search for:',10
l5 : equ $-msg5

section .bss
ele : resd 1
n : resd 1
array : resd 50
temp : resd 1
just_print : resd 1
just_read : resd 1
counter : resd 1
zero : resd 1

section .text
global _start:
_start:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,l1
int 80h

call read_num
mov eax,dword[just_read]
mov dword[n],eax

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,l2
int 80h

call read_array

mov eax,4
mov ebx,1
mov ecx,msg5
mov edx,l5
int 80h

call read_num
mov eax,dword[just_read]
mov dword[ele],eax

mov ebx,array
mov eax,0
mov ecx,dword[n]
dec ecx

bin_search:
cmp eax,ecx
ja fail
push eax
push ecx
mov edx,0
add edx,eax
add edx,ecx
mov eax,edx
mov ebx,2
mov edx,0
div ebx
mov ebx,array
mov edx,eax
pop ecx
mov eax,dword[ele]

cmp dword[ebx+4*edx],eax
je print_ele

cmp dword[ebx+4*edx],eax
ja above

cmp dword[ebx+4*edx],eax
jb below

cont:
jmp bin_search

fail:
mov eax,4
mov ebx,1
mov ecx,msg3
mov edx,l3
int 80h
jmp end

above:
pop eax
dec edx
mov ecx,edx
jmp cont

below:
pop eax
inc edx
mov eax,edx
jmp cont

print_ele:
push edx

mov eax,4
mov ebx,1
mov ecx,msg4
mov edx,l4
int 80h

pop edx

mov dword[just_print],edx
call print_num

jmp end


read_array:
	pusha
	
	mov ebx,array
	mov eax,0
	while:
	cmp eax,dword[n]
	je end_read_array
	call read_num
	mov ecx,dword[just_read]
	mov dword[ebx+4*eax],ecx
	inc eax
	jmp while
	
end_read_array:
	popa
	ret

print_num:
        pusha
        mov dword[counter],0
        cmp dword[just_print],0
        jne extracting
        mov dword[zero],30h
        mov eax,4
        mov ebx,1
        mov ecx,zero
        mov edx,1
        int 80h
        jmp end_print

        extracting:
                cmp dword[just_print],0
                je printing
                mov eax, dword[just_print]
                mov ebx,10
                mov edx,0
                div ebx
                push edx
                mov dword[just_print],eax
                inc dword[counter]
                jmp extracting

printing:
        cmp dword[counter],0
        je end_print
        pop edx
        add edx,30h
        mov dword[temp],edx
        mov eax,4
        mov ebx,1
        mov ecx,temp
        mov edx,1
        int 80h
        dec dword[counter]
        jmp printing

end_print:
        popa
        ret

read_num:
        pusha
        mov dword[just_read], 0

        reading:
                mov eax,3
                mov ebx,0
                mov ecx,temp
                mov edx,1
                int 80h

                cmp dword[temp],10
                je end_read
                sub dword[temp],30h
                mov eax,dword[just_read]
                mov ebx, 10
                mov edx,0
                mul ebx
                add eax,dword[temp]
                mov dword[just_read], eax
                jmp reading

end_read:
        popa
        ret

      

end:
mov eax,1
mov ebx,0
int 80h
