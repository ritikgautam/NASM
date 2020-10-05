section .data
msg1 : db 'Enter the value of angle x: ',10
l1 : equ $-msg1
msg2 : db 'Cosx value by calc: ',10
l2 : equ $-msg2
msg3 : db 'Cosx value by FCOS: ',10
l3 : equ $-msg3
formate1 : db "%lf",0
formate2 : db "%lf",10

section .bss
x : resq 1
sqox : resq 1
temp : resq 1
ans : resq 1
i : resd 1
n : resd 1
sign : resd 1

section .text
global main
extern scanf
extern printf

main:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,l1
int 80h

call read_float

fldpi
fmul ST1
mov word[temp],180
fidiv word[temp]
fst qword[x]
fmul ST0
fstp qword[sqox]

mov dword[n],30
mov dword[i],1
mov word[temp],1
fild word[temp]
fst qword[ans]
mov dword[sign],1

loop1:
mov eax,dword[n]
cmp dword[i],eax
je exloop

jmp g1

og1:
mov dword[temp],2
mov eax,dword[i]
div dword[temp]
mov dword[sign],edx

fst qword[temp]
cmp dword[sign],0
jne chsgn

here:
fadd qword[ans]
fstp qword[ans]
fld qword[temp]
inc dword[i]
jmp loop1

exloop:
mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,l2
int 80h

fld qword[ans]

call print_float

mov eax,4
mov ebx,1
mov ecx,msg3
mov edx,l3
int 80h

fld qword[x]
fcos

call print_float

jmp end

g1:
fmul qword[sqox]
mov eax,dword[i]
mov dword[temp],2
mul dword[temp]
mov dword[temp],eax
fidiv dword[temp]
dec dword[temp]
fidiv dword[temp]
jmp og1

chsgn:
fchs
jmp here

print_float:
push ebp
mov ebp,esp
sub esp,8
fst qword[ebp-8]
push formate2
call printf
mov esp,ebp
pop ebp
ret

read_float:
push ebp
mov ebp,esp
sub esp,8
lea eax,[esp]
push eax
push formate1
call scanf
fld qword[ebp-8]
mov esp,ebp
pop ebp
ret

end:
mov eax,1
mov ebx,0
int 80h