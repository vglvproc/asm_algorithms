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
SortInsertionN proto :DWORD, :DWORD, :DWORD, :DWORD
SortShell proto :DWORD, :DWORD
CleanBuffer proto :DWORD, :DWORD
STRSIZE equ 5
ARRSIZE equ 15
.data
strStart BYTE "Welcome! This program sorts array of numbers using Shell sorting algorithm.", 0dh, 0ah
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

invoke SortShell, ADDR array, ARRSIZE

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

SortInsertionN proc ArrayAddr:DWORD, ArraySize:DWORD, Start:DWORD, Increment:DWORD

push eax
push ebx
push ecx
push edx

mov edx, 0
mov eax, ArraySize
sub eax, Start
div Increment

mov ecx, eax

mov esi, ArrayAddr

mov eax, Start
add eax, Increment
dec eax
shl eax, 2
add esi, eax
shr eax, 2
inc eax

iteration:
mov edx, DWORD PTR [esi]
mov ebx, eax
sub ebx, Increment

push esi
inner:
cmp ebx, 1
jl end_iteration
mov esi, ArrayAddr
dec ebx
shl ebx, 2
add esi, ebx
shr ebx, 2
inc ebx
mov edi, DWORD PTR [esi]
cmp edi, edx
jng end_iteration
push eax
push ebx

mov ebx, Increment
shl ebx, 2
add esi, ebx
mov DWORD PTR [esi], edi
sub esi, ebx

pop ebx
pop eax

sub ebx, Increment
jmp inner
end_iteration:
mov esi, ArrayAddr
add ebx, Increment
dec ebx
shl ebx, 2
add esi, ebx
shr ebx, 2
sub ebx, Increment
inc ebx
mov DWORD PTR [esi], edx
pop esi
add eax, Increment
push ebx
mov ebx, Increment
shl ebx, 2
add esi, ebx
pop ebx
loop iteration

pop edx
pop ecx
pop ebx
pop eax

ret
SortInsertionN endp

SortShell proc ArrayAddr:DWORD, ArraySize:DWORD
mov ecx, 0
mov eax, ArraySize

log2n:
shr eax, 1
cmp eax, 0
jz next
inc ecx
jmp log2n

next:
mov eax, 1
push ecx
get_increment:
shl eax, 1
loop get_increment
pop ecx
dec eax
mov edx, 1

insertion:
cmp edx, eax
jg end_insertion
invoke SortInsertionN, ArrayAddr, ArraySize, edx, eax
inc edx
jmp insertion
end_insertion:

loop next

ret
SortShell endp

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