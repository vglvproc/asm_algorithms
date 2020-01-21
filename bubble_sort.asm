.386
.model flat, stdcall
option casemap:none
include D:\masm32\include\kernel32.inc
include D:\masm32\include\windows.inc
include D:\masm32\include\user32.inc
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\user32.lib
randomize proto
random proto
rand proto :DWORD, :DWORD
SortBubble proto :DWORD, :DWORD
CleanBuffer proto :DWORD, :DWORD
STRSIZE equ 5
ARRSIZE equ 15
.data
strStart BYTE "Welcome! This program sorts array of numbers using bubble sorting algorithm.", 0dh, 0ah
strBefore BYTE "Array before sorting: ", 0dh, 0ah
strAfter BYTE "Array after sorting: ", 0dh, 0ah
newLine BYTE 0dh, 0ah
ifmt BYTE "%d", 0
buf BYTE STRSIZE dup(?)
array DWORD ARRSIZE dup(?)
stdout DWORD ?
cWritten DWORD ?
.code
main:
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax

invoke randomize
invoke WriteConsoleA, stdout, ADDR strStart,\
sizeof strStart, ADDR cWritten, 0
invoke WriteConsoleA, stdout, ADDR strBefore,\
sizeof strBefore, ADDR cWritten, 0

mov ecx, ARRSIZE
mov esi, OFFSET array
filling:
invoke rand, 1, 100
mov DWORD PTR [esi], eax
add esi, 4
loop filling

mov ecx, ARRSIZE
mov esi, OFFSET array

output_before:
mov eax, DWORD PTR [esi]
push ecx
invoke wsprintf, ADDR buf, ADDR ifmt, eax
invoke WriteConsoleA, stdout, ADDR buf, STRSIZE,\
ADDR cWritten, 0
invoke CleanBuffer, ADDR buf, STRSIZE
pop ecx
add esi, 4
loop output_before

invoke SortBubble, ADDR array, ARRSIZE

invoke WriteConsoleA, stdout, ADDR newLine,\
sizeof newLine, ADDR cWritten, 0

invoke WriteConsoleA, stdout, ADDR strAfter,\
sizeof strAfter, ADDR cWritten, 0

mov ecx, ARRSIZE
mov esi, OFFSET array

output_after:
mov eax, DWORD PTR [esi]
push ecx
invoke wsprintf, ADDR buf, ADDR ifmt, eax
invoke WriteConsoleA, stdout, ADDR buf, STRSIZE,\
ADDR cWritten, 0
invoke CleanBuffer, ADDR buf, STRSIZE
pop ecx
add esi, 4
loop output_after

invoke ExitProcess, 0

SortBubble proc ArrayAddr:DWORD, ArraySize:DWORD
push eax
push edx
push ecx
push esi
mov eax, 1
sort_outer:
cmp eax, 1
jnz sort_end
mov eax, 0

mov ecx, ArraySize
dec ecx
mov esi, OFFSET array

sort_inner:
mov ebx, DWORD PTR [esi]
mov edx, DWORD PTR [esi+4]
cmp ebx, edx
jng nochange
mov DWORD PTR [esi+4], ebx
mov DWORD PTR [esi], edx
mov eax, 1
nochange:
add esi, 4
loop sort_inner
jmp sort_outer

sort_end:

pop esi
pop ecx
pop edx
pop eax

ret
SortBubble endp

CleanBuffer proc BufferAddr:DWORD, BufferSize:DWORD
push esi
push ecx

mov ecx, BufferSize
mov esi, BufferAddr
clean_before:
mov BYTE PTR [esi], 0
inc esi
loop clean_before

pop ecx
pop esi
ret
CleanBuffer endp

end main