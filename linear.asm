.386
.model flat, stdcall
option casemap:none
include D:\masm32\include\kernel32.inc
include D:\masm32\include\user32.inc
include D:\masm32\include\windows.inc
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\user32.lib
randomize proto
random proto
rand proto :DWORD, :DWORD
STRSIZE equ 20
.data
buf DWORD STRSIZE dup(?)
ifmt BYTE "%d", 0
stdout DWORD ?
cWritten DWORD ?
value DWORD ?
.code
main:
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax

invoke randomize

mov ecx, 10
print:
push ecx
mov ecx, STRSIZE

clean:
mov edx, OFFSET buf
add edx, ecx
dec edx
mov BYTE PTR [edx], 0
loop clean

invoke rand, -100, 100
invoke wsprintf, ADDR buf, ADDR ifmt, eax
invoke WriteConsoleA, stdout, ADDR buf, STRSIZE,\
ADDR cWritten, 0
pop ecx

loop print

invoke ExitProcess, 0

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

end main