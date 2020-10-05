section .data
msg1 : db 'Enter A,B,C values for Ax^2+Bx+c=0: ',10
l1 : equ $-msg1
msg2 : db 'The roots are: ',10
l2 : equ $-msg2
msg3 : db 'Roots are Imaginary.',10
l3 : equ $-msg3
msg4 : db 'Enter A:',0
l4 : equ $-msg4
msg5 : db 'Enter B:',0
l5 : equ $-msg5
msg6 : db 'Enter C:',0
l6 : equ $-msg6
formate1: db '%lf',0
formate2 : db '%lf',10


section .bss
temp : resq 1
temp1 : resq 1
A : resq 1
B : resq 1
C : resq 1

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

mov eax,4
mov ebx,1
mov ecx,msg4
mov edx,l4
int 80h

call read_float

fstp qword[A]

mov eax,4
mov ebx,1
mov ecx,msg5
mov edx,l5
int 80h

call read_float

fstp qword[B]

mov eax,4
mov ebx,1
mov ecx,msg6
mov edx,l6
int 80h

call read_float

fstp qword[C]

fld qword[A]
fmul qword[C]

mov word[temp],4
fimul word[temp]

fld qword[B]
fmul ST0
fsub ST1
fst qword[temp1]

mov dword[temp],0

fcomp dword[temp]
fstsw ax
sahf
jb br

fld qword[temp1]
fsqrt

fld qword[A]
mov word[temp],2
fimul word[temp]

fld qword[B]		
fchs
fadd ST2
fdiv ST1

mov eax,4
mov ebx,1
mov ecx,msg2
mov edx,l2
int 80h

call print_float

fstp qword[temp]

fld qword[B]		
fchs
fsub ST2
fdiv ST1

call print_float

ffree(ST0)
ffree(ST1)
ffree(ST2)

jmp end

br:
mov eax,4
mov ebx,1
mov ecx,msg3
mov edx,l3
int 80h

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