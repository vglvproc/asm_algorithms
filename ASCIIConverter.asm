.386
.model flat, stdcall
option casemap:none
.code

ASCII_UDWORD proc AddrInput :DWORD, InputSize :DWORD,\
AddrOutput :DWORD

mov ecx, InputSize
mov ebx, 0
mov esi, 0
mov edi, 0

count:

mov edx, AddrInput
add edx, ebx
mov al, BYTE PTR [edx]

cmp al, 0dh
jz convert
cmp al, 00h
jz convert

sub al, 30h
cmp al, 9h
jg error
cmp al, 0h
jl error

movsx eax, al
push eax

inc esi
inc ebx

loop count

convert:
cmp esi, 0
jz error

mov eax, 0

mov ecx, esi
clc

next:
pop edx
push ecx
mov ecx, edi
cmp ecx, 0
jz after_ten

ten:

mov ebx, edx
shl edx, 1
jc error
shl edx, 1
jc error
shl edx, 1
jc error
add edx, ebx
jc error
add edx, ebx
jc error

loop ten
after_ten:

add eax, edx
jc error

inc edi

pop ecx
loop next

mov ecx, AddrOutput
mov DWORD PTR [ecx], eax
mov eax, 0
jmp exit

error:
mov eax, -1
exit:
ret

ASCII_UDWORD endp

ASCII_DWORD proc AddrInput :DWORD, InputSize :DWORD, \
AddrOutput :DWORD
LOCAL sign :BYTE

mov sign, 0
mov ecx, InputSize
mov ebx, 0
mov esi, 0
mov edi, 0

mov edx, AddrInput
add edx, ebx
mov al, BYTE PTR [edx]

cmp al, 2dh

jnz count
mov sign, 1
dec ecx
inc ebx

count:

mov edx, AddrInput
add edx, ebx
mov al, BYTE PTR [edx]

cmp al, 0dh
jz convert
cmp al, 00h
jz convert

sub al, 30h

cmp al, 9h
jg error
cmp al, 0h
jl error

movsx eax, al
push eax

inc esi
inc ebx

loop count

convert:
cmp esi, 0
jz error
mov eax, 0
mov ecx, esi
clc

next:
pop edx
push ecx
mov ecx, edi

cmp ecx, 0
jz after_ten

ten:

mov ebx, edx
shl edx, 1
js error
shl edx, 1
js error
shl edx, 1
js error
add edx, ebx
js error
add edx, ebx
js error

loop ten
after_ten:

add eax, edx

cmp eax, 80000000h
ja error
jnz after_cmp
cmp sign, 1
jnz error

after_cmp:

inc edi

pop ecx
loop next

cmp sign, 0
jz exit
neg eax
jmp exit

error:
mov eax, -1
ret
exit:
mov ecx, AddrOutput
mov DWORD PTR [ecx], eax
mov eax, 0
ret

ASCII_DWORD endp
end