.386
.model flat, stdcall
option casemap : none

include /masm32/include/windows.inc
include /masm32/include/user32.inc
include /masm32/include/kernel32.inc

includelib /masm32/lib/user32.lib
includelib /masm32/lib/kernel32.lib
include /masm32/include/masm32rt.inc


.data
    FileName db "C:/Users/arman/Pictures/prueba.txt", 0
    ErrorCaption  db "Error!", 0
    ErrorMsg	  db "Cannot open file", 0
    string db '2', 0

.data?
    hFile HANDLE ?
    hMemory HANDLE ?
    pMemory DWORD ?
    ReadSize DWORD ?
    IMemory DWORD ?
    numWord DWORD ?
    contador WORD ?

.const
    MEMORYSIZE equ 65535

.code

start PROC
	
    invoke CreateFile, addr FileName, GENERIC_READ, FILE_SHARE_READ,
    NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    .if eax != INVALID_HANDLE_VALUE
    mov hFile, eax

    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, MEMORYSIZE
    mov hMemory, eax
    invoke GlobalLock, hMemory
    mov pMemory, eax
    
    invoke ReadFile, hFile, pMemory, MEMORYSIZE - 1, addr ReadSize, NULL

    mov contador, 0
    mov IMemory, ecx
    sub IMemory, 1
    mov eax, pMemory
    sub eax, 1
   
    jmp ConvertToInt

    invoke MessageBox, NULL, pMemory, addr FileName, MB_OK
    invoke GlobalUnlock, pMemory
    invoke GlobalFree, hMemory
    invoke CloseHandle, hFile
    .else
    invoke MessageBox, NULL, addr ErrorMsg, addr ErrorCaption, MB_OK

    .endif

    invoke ExitProcess, NULL

ConvertToInt:

    add contador, 1
    add eax, 1
    
    movzx ebx, byte ptr[eax]
    sub ebx, 48
         
    cmp byte ptr[eax + 1], 36
    je Convert
    
    cmp byte ptr[eax+1], 32
    jne ConvertToInt
    je Convert

   
    jmp ConvertToInt

Convert:
    add eax, 1
    cmp contador, 1
    je Conver1Digit
    cmp contador, 2
    je Conver2Digit
    cmp contador, 3
    je Conver3Digit


Conver1Digit:
    add IMemory, 1
    mov byte ptr[IMemory],bl
    mov contador, 0
    cmp byte ptr[eax], 36
    je IniciarAlgoritmo
    jmp ConvertToInt

Conver2Digit:
    add IMemory, 1
    mov pMemory, eax
    mov bl, byte ptr[eax-2]
    sub ebx, 48
    mov eax, ebx
    mov dl, 10
    mul dl
    mov bl, al
    mov eax, pMemory
    mov dl, byte ptr[eax - 1]
    sub dl, 48
    add bl, dl
    mov byte ptr[IMemory], bl
    mov contador, 0
    cmp byte ptr[eax], 36
    je IniciarAlgoritmo
    jmp ConvertToInt

Conver3Digit:
    add IMemory, 1
    mov pMemory, eax
    mov bl, byte ptr[eax-3]
    sub ebx, 48
    mov eax, ebx
    mov dl, 10
    mul dl
    mov bl, al
    mov eax, pMemory
    mov dl, byte ptr[eax - 2]
    sub dl, 48
    add bl, dl
    mov eax, ebx
    mov dl, 10
    mul dl
    mov bl, al
    mov eax, pMemory
    mov dl, byte ptr[eax - 1]
    sub dl, 48
    add bl, dl
    mov byte ptr[IMemory], bl
    mov contador, 0
    cmp byte ptr[eax], 36
    je IniciarAlgoritmo
    jmp ConvertToInt


IniciarAlgoritmo:
    mov eax, 0

start endp
end start