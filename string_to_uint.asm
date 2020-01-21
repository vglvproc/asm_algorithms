.386
.model flat, stdcall
option casemap:none
include D:\masm32\include\kernel32.inc
include D:\masm32\include\user32.inc
include D:\masm32\include\windows.inc
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\user32.lib
ASCII_UDWORD proto :DWORD, :DWORD, :DWORD

STRSIZE equ 20

.data
strStart BYTE "Welcome! This program converts",
" ASCII string to unsigned integer.", 0dh, 0ah
strInput BYTE "Input an unsigned integer value within the range 0..4294967295.", 0dh, 0ah
strError BYTE "You have entered wrong value.", 0dh, 0ah
strOutput BYTE "You have entered: "
newline BYTE 0dh, 0ah
ifmt BYTE "%u", 0
buf BYTE STRSIZE dup(?)
stdout DWORD ?
stdin DWORD ?
cWritten DWORD ?
cRead DWORD ?
output DWORD ?

.code
main:

invoke GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
invoke GetStdHandle, STD_INPUT_HANDLE
mov stdin, eax
invoke WriteConsoleA, stdout, ADDR strStart,\
sizeof strStart, ADDR cWritten, 0
invoke WriteConsoleA, stdout, ADDR newline,\
sizeof newline, ADDR cWritten, 0
invoke WriteConsoleA, stdout, ADDR strInput,\
sizeof strInput, ADDR cWritten, 0
invoke ReadConsole, stdin, ADDR buf,\
STRSIZE, ADDR cRead, 0
invoke ASCII_UDWORD, ADDR buf, STRSIZE, ADDR output

cmp eax, -1
jz prog_error

mov ecx, STRSIZE
clean:
mov edx, OFFSET buf
add edx, ecx
dec edx
mov BYTE PTR [edx], 0
loop clean

invoke wsprintf, ADDR buf, ADDR ifmt, output
invoke WriteConsoleA, stdout, ADDR strOutput,\
sizeof strOutput, ADDR cWritten, 0
invoke WriteConsoleA, stdout, ADDR buf,\
sizeof buf, ADDR cWritten, 0
jmp prog_exit

prog_error:

invoke WriteConsoleA, stdout, ADDR strError,\
sizeof strError, ADDR cWritten, 0
prog_exit:
invoke ExitProcess, 0

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

end main