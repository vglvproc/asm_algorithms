.386
.model flat, stdcall
option casemap:none
include D:\masm32\include\kernel32.inc
includelib D:\masm32\lib\kernel32.lib
.data
value DWORD ?
.code

randomize proc
invoke GetTickCount
and eax, 0FFFFh
mov value, eax
ret
randomize endp

random proc
mov eax, value
mov ebx, 25173
mul ebx
mov ebx, 13849
add eax, ebx
mov ebx, 65536
div ebx
mov value, edx
mov eax, edx
ret
random endp

rand proc minValue :DWORD, maxValue :DWORD
mov eax, minValue
cmp eax, maxValue
jng nochange
push minValue
push maxValue
pop minValue
pop maxValue
nochange:
invoke random
mov edx, 0
mov ebx, maxValue
sub ebx, minValue
inc ebx
div ebx
mov eax, edx
add eax, minValue
ret
rand endp

end