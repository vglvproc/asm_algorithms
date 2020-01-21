.386
.model flat, stdcall
option casemap:none
include D:\masm32\include\kernel32.inc
include D:\masm32\include\windows.inc
include D:\masm32\include\user32.inc
includelib D:\masm32\lib\kernel32.lib
includelib D:\masm32\lib\user32.lib
ASCII_UDWORD proto :DWORD, :DWORD, :DWORD
STRSIZE equ 20
.data
strStart1 BYTE "Welcome! This program finds",
" the greatest common divisor ", 0dh, 0ah
strStart2 BYTE "of two positive numbers", 0dh, 0ah
strInputFirst BYTE "Input the first number (positive integer):", 0dh, 0ah
strInputSecond BYTE "Input the second number (positive integer):", 0dh, 0ah
strInputError BYTE "You have entered wrong value.", 0dh, 0ah
strResult BYTE "The greatest common divisor equals to "
ifmt BYTE "%d", 0
buf BYTE STRSIZE dup(?)
stdout DWORD ?
stdin DWORD ?
cWritten DWORD ?
cRead DWORD ?
number_1 DWORD ?
number_2 DWORD ?
.code
main:
invoke GetStdHandle, STD_OUTPUT_HANDLE
mov stdout, eax
invoke GetStdHandle, STD_INPUT_HANDLE
mov stdin, eax
invoke WriteConsoleA, stdout, ADDR strStart1,\
sizeof strStart1, ADDR cWritten, 0
invoke WriteConsoleA, stdout, ADDR strStart2,\
sizeof strStart2, ADDR cWritten, 0
input_1:
invoke WriteConsoleA, stdout, ADDR strInputFirst,\
sizeof strInputFirst, ADDR cWritten, 0
invoke ReadConsoleA, stdin, ADDR buf,\
STRSIZE, ADDR cRead, 0
invoke ASCII_UDWORD, ADDR buf, STRSIZE, ADDR number_1
cmp eax, -1
jz error_1
cmp number_1, 0
jnz input_2
error_1:
invoke WriteConsoleA, stdout, ADDR strInputError,\
sizeof strInputError, ADDR cWritten, 0
jmp input_1
input_2:
invoke WriteConsoleA, stdout, ADDR strInputSecond,\
sizeof strInputSecond, ADDR cWritten, 0
invoke ReadConsoleA, stdin, ADDR buf,\
STRSIZE, ADDR cRead, 0
invoke ASCII_UDWORD, ADDR buf, STRSIZE, ADDR number_2
cmp eax, -1
jz error_2
cmp number_2, 0
jnz algorithm
error_2:
invoke WriteConsoleA, stdout, ADDR strInputError,\
sizeof strInputError, ADDR cWritten, 0
jmp input_2

algorithm:
mov edx, 0
mov eax, number_1
div number_2
cmp edx, 0
jz exit
mov ebx, number_2
mov number_1, ebx
mov number_2, edx
jmp algorithm

exit:
invoke WriteConsoleA, stdout, ADDR strResult,\
sizeof strResult, ADDR cWritten, 0

mov ecx, STRSIZE
clean:
mov edx, OFFSET buf
add edx, ecx
dec edx
mov BYTE PTR [edx], 0
loop clean

invoke wsprintf, ADDR buf, ADDR ifmt, number_2
invoke WriteConsoleA, stdout, ADDR buf,\
STRSIZE, ADDR cWritten, 0

invoke ExitProcess, 0
end main