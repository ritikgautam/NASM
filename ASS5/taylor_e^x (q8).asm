section .data
msg1 : db 'Enter the value of x: ',10
l1 : equ $-msg1
msg2 : db 'e^x value by calc: ',10
l2 : equ $-msg2
formate1 : db "%lf",0
formate2 : db "%lf",10

section .bss
x : resq 1
temp : resq 1
ans : resq 1
i : resd 1
n : resd 1

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

fst qword[x]

mov dword[n],100
mov dword[i],1
mov word[temp],1
fild word[temp]
fst qword[ans]

loop1:
mov eax,dword[n]
cmp dword[i],eax
je exloop

jmp g1

og1:
fst qword[temp]
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

jmp end

g1:
fmul qword[x]
fidiv dword[i]
jmp og1

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