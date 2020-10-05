section .data
msg1 : db 'Enter first number: ',10
l1 : equ $-msg1
msg2 : db 'Enter second number: ',10
l2 : equ $-msg2
formate1 : db '%lf',0
formate2 : db 'Multiply of these two numbers is: %lf',10

section .bss
temp : resq 1

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

fstp qword[temp]

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,l2
int 80h

call read_float

fmul qword[temp]

call print_float

ffree(ST0)

jmp end

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