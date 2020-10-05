
section .text
global main
extern scanf
extern printf



print:
push ebp
mov ebp, esp
sub esp, 8
fst qword[ebp-8]
push format2
call printf
mov esp, ebp
pop ebp
ret


read:
push ebp
mov ebp, esp
sub esp, 8
lea eax, [esp]
push eax
push format1
call scanf
fld qword[ebp-8]
mov esp, ebp
pop ebp
ret

readnat:
push ebp
mov ebp, esp
sub esp , 2
lea eax , [ebp-2]
push eax
push format3
call scanf
mov ax, word[ebp-2]
mov word[num], ax
mov esp, ebp
pop ebp
ret


read_float:
push ebp
mov ebp, esp
sub esp, 8
lea eax, [esp]
push eax
push format1
call scanf
fld qword[ebp - 8]
mov esp, ebp
pop ebp
ret

print_float:
push ebp
mov ebp, esp
sub esp, 8
fst qword[ebp - 8]
push format2
call printf
mov esp, ebp
pop ebp
ret


main:

mov eax,4
mov ebx,1
mov ecx,msg1
mov edx,len1
int 80h

call read_float
fstp qword[float1]

fldpi
fdiv qword[n]
fmul qword[float1]
fstp qword[float2]
fld qword[float2]
fld qword[float2]
fmul st1
fmul st1
fmul st1
fdiv qword[n1]
fsub st1
fchs


call print_float
ffree st0
ffree st1
fld qword[float2]
fsin

call print_float
exit:
mov eax, 1
mov ebx, 0
int 80h



section .data
format1: db "%lf",0
format2: db "The sin value  is  %lf",10
format3: db "%d", 0
msg1: db "Enter the angle : "
len1: equ $-msg1
n: dq 180.0
n1: dq 6.0

section .bss
float1: resq 1
float2: resq 1
num1: resw 1
num: resw 1

