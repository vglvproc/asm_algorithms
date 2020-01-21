# asm_algorithms

Here are some algorithms written in assembler.
They should be compiled by [MASM32 Assembler ](http://www.masm32.com/)
You have to replace all D:\masm32\include\.. or D:\masm32\lib\.. paths to your own paths, according to where you MASM32 Assembler is located.

**string_to_uint.asm
This program converts ASCII string to an unsigned integer.
How to compile:
*ml /coff string_to_uint.asm

**string_to_int.asm
This program converts ASCII string to a signed integer.
How to compile:
*ml /coff string_to_int.asm

**ASCIIConverter.asm
This is an auxiliary module containing ASCII_UDWORD and ASCII_DWORD functions which are used by another programs.

**euclidean.asm
This program finds the greatest common divisor of two positive numbers.
How to compile:
*ml /c /coff euclidean.asm ASCIIConverter.asm
*link /SUBSYSTEM:CONSOLE euclidean.obj ASCIIConverter.obj

**RandomLinear.asm
This is an auxiliary module containing randomize, random and rand functions which are used by another programs.

**linear.asm
A linear congruential generator of pseudorandom numbers. Outputs sequence of 10 pseudorandom numbers.
How to compile:
*ml /coff linear.asm

**bubble_sort.asm
This program fills in array with pseudorandom numbers, and then sorts it using bubble sorting algorithm.
How to compile:
*ml /c /coff bubble_sort.asm RandomLinear.asm
*link /SUBSYSTEM:CONSOLE bubble_sort.obj RandomLinear.obj

**insertion_sort.asm
This program fills in array with pseudorandom numbers, and then sorts it using insertion sorting algorithm.
How to compile:
*ml /c /coff insertion_sort.asm RandomLinear.asm
*link /SUBSYSTEM:CONSOLE insertion_sort.obj RandomLinear.obj

**shell_sort.asm
This program fills in array with pseudorandom numbers, and then sorts it using Shell sorting algorithm.
How to compile:
*ml /c /coff shell_sort.asm RandomLinear.asm
*link /SUBSYSTEM:CONSOLE shell_sort.obj RandomLinear.obj