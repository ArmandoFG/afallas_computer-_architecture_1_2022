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
    FileNameDest db "C:/Users/arman/Pictures/PruebaResultado.txt", 0
    ErrorCaption  db "Error!", 0
    ErrorMsg	  db "Cannot open file", 0
    string db '2', 0

    a1 REAL4 0.666667
    a2 REAL4 0.333333


    Punt1 DWORD 0
    Punt2 DWORD 32
    Punt3 DWORD 64
    Punt4 DWORD 96
    Pivote DWORD 0

    VarX DWORD 0

    pruebita DWORD 0

    dataSize dword 65535


.data?
    hFile HANDLE ?
    ihFile HANDLE ?
    hMemory HANDLE ?
    ihMemory HANDLE ?
    pMemory DWORD ?
    ReadSize DWORD ?
    IMemory DWORD ?
    numWord DWORD ?
    contador WORD ?
    contadorInt DWORD ?

    NewMemory DWORD ?
    Px DWORD ?
    Py DWORD ?
    
    StrMemory DWORD ?
    sihMemory HANDLE ?

    val1 DWORD ?

    valC DWORD ?
    valF DWORD ?
    valG DWORD ?
    valJ DWORD ?

    PtrStr DWORD ?

    SizeEnd DWORD ?

    


.const
    MEMORYSIZE equ 65535
    MEMORYSIZE2 equ 65535
    MEMORYSIZE3 equ 65535

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

    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, MEMORYSIZE2
    mov ihMemory, eax
    invoke GlobalLock, ihMemory
    mov NewMemory, eax

    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, MEMORYSIZE3
    mov sihMemory, eax
    invoke GlobalLock, sihMemory
    mov StrMemory, eax

 
    
    invoke ReadFile, hFile, pMemory, MEMORYSIZE - 1, addr ReadSize, NULL


    mov contador, 0
    mov contadorInt, 0
    mov IMemory, esp
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
    add contadorInt, 1
    mov ebx, IMemory
    add ebx, 1
    mov IMemory, ebx
    mov ecx, IMemory
    mov byte ptr[ecx],bl
    mov contador, 0
    cmp byte ptr[eax], 36
    je IniciarAlgoritmo
    jmp ConvertToInt

Conver2Digit:
    add contadorInt, 1
    mov ebx, IMemory
    add ebx, 1
    mov IMemory, ebx
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
    mov ecx, IMemory
    mov byte ptr[ecx], bl
    mov IMemory, ecx
    mov contador, 0
    cmp byte ptr[eax], 36

    je IniciarAlgoritmo
    jmp ConvertToInt

Conver3Digit:
    add contadorInt, 1
    mov ebx, IMemory
    add ebx, 1
    mov IMemory, ebx
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
    mov ecx, IMemory
    mov byte ptr[ecx], bl
    mov contador, 0
    cmp byte ptr[eax], 36
    je IniciarAlgoritmo
    jmp ConvertToInt


IniciarAlgoritmo:
    mov ecx, IMemory
    sub ecx, contadorInt
    
    ;mov eax, offset NewMemory
    ;mov NewMemory, eax
    mov Px, 0
    mov Py, 5

    mov ebx, NewMemory

    jmp InicioCiclo

InicioCiclo:
    add Px, 1
    add Py, 1
    

    add Pivote, 1
   
    cmp Py, 25
    je Fin
    cmp Pivote, 5
    je MoverPunteros
    
    jmp Calc_a

MoverPunteros:
    add Punt1, 96
    add Punt2, 96
    add Punt3, 96
    add Punt4, 96
    mov Pivote, 0
    jmp Calc_a
   
Calc_a:
    
    mov edx, Px    
    add Punt1, 1    
    movzx eax, byte ptr[ecx + edx]
    mov esi, Punt1
    mov edi, Py
    mov byte ptr[ebx + esi], al
    mov Py, edi
    add Punt1, 1
    mov esi, Punt1
    mov byte ptr[ebx + esi], ' '
    add Punt1, 1
    mov esi, Punt1
        
    fld a1
    movzx eax, byte ptr[ecx+edx]
    mov val1, eax
    fimul val1
    fld a2
    movzx eax, byte ptr[ecx + edx+1]
    mov val1, eax
    fimul val1
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    movzx eax, byte ptr[ebx + esi]
    add Punt1, 1
    mov esi, Punt1
    mov byte ptr[ebx + esi], ' '
    finit
    jmp Calc_b
    

Calc_b:
    
    mov edx, Px
    add Punt1, 1
    mov edi, Px
    mov esi, Punt1
    fld a2
    movzx eax, byte ptr[ecx+edx]
    mov val1, eax
    fimul val1
    fld a1
    movzx eax, byte ptr[ecx + edx+1]
    mov val1, eax
    fimul val1
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt1, 1
    mov esi, Punt1
    mov byte ptr[ebx + esi], ' '
    add Punt1, 1
    mov esi, Punt1
    movzx eax, byte ptr[ecx + edx+1]
    mov byte ptr[ebx + esi], al
    add Punt1, 1
    mov esi, Punt1
    mov byte ptr[ebx + esi], ' '
    movzx eax, byte ptr[ebx]
    movzx eax, byte ptr[ebx + 1]
    movzx eax, byte ptr[ebx + 2]
    movzx eax, byte ptr[ebx+3]
    movzx eax, byte ptr[ebx + 4]
    movzx eax, byte ptr[ebx + 5]

    mov Px, edi
    finit
    
    ;jmp Fin
    jmp Calc_c
   

Calc_c:

    mov edx, Px
    add Punt2, 1
    mov esi, Punt2
    fld a1
    movzx eax, byte ptr[ecx+edx]
    mov val1, eax
    fimul val1
    fld a2
    
    mov edx, Py
    movzx eax, byte ptr[ecx + edx]
    mov Py, edx
    mov val1, eax
    fimul val1
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt2, 1
    mov esi, Punt2
    mov byte ptr[ebx + esi], 32
    mov valC, eax
    finit
    jmp Calc_g
   

Calc_g:
    mov edx, Px
    add Punt3, 1
    mov esi, Punt3
    fld a2
    movzx eax, byte ptr[ecx+edx]
    mov val1, eax
    fimul val1
    fld a1
    mov edx, Py
    movzx eax, byte ptr[ecx + edx]
    mov val1, eax
    fimul val1
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt3, 1
    mov esi, Punt3
    mov byte ptr[ebx + esi], 32
    mov valG, eax
    finit   
   jmp Calc_k

Calc_k:
    mov edx, Py
    add Punt4, 1
    movzx eax, byte ptr[ecx + edx]
    mov esi, Punt4
    mov byte ptr[ebx + esi], al
    add Punt4, 1
    mov esi, Punt4
    mov byte ptr[ebx + esi], 32
    add Punt4, 1
    mov esi, Punt4


    fld a1
    movzx eax, byte ptr[ecx+edx]
    mov val1, eax
    fimul val1
    fld a2
    movzx eax, byte ptr[ecx + edx+1]
    mov val1, eax
    fimul val1
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt4, 1
    mov esi, Punt4
    mov byte ptr[ebx + esi], 32
    finit
    jmp Calc_l

Calc_l:
    mov edx, Py
    add Punt4, 1
    mov esi, Punt4
    fld a2
    movzx eax, byte ptr[ecx+edx]
    mov val1, eax
    fimul val1
    fld a1
    movzx eax, byte ptr[ecx + edx+1]
    mov val1, eax
    fimul val1
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt4, 1
    mov esi, Punt4
    mov byte ptr[ebx + esi], 32
    add Punt4, 1
    mov esi, Punt4
    movzx eax, byte ptr[ecx + edx+1]
    mov byte ptr[ebx + esi], al
    add Punt4, 1
    mov esi, Punt4
    mov byte ptr[ebx + esi], 32
    finit
    jmp Calc_f

Calc_f:
    mov edx, Px
    ;add Punt2, 1
    mov esi, Punt2
    fld a1
    movzx eax, byte ptr[ecx+edx+1]
    mov val1, eax
    fimul val1
    fld a2
    mov edx, Py
    movzx eax, byte ptr[ecx + edx+1]
    mov val1, eax
    fimul val1
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi+5], al
    ;add Punt2, 1
    ;mov esi, Punt2
    mov byte ptr[ebx + esi+6], 32
    mov valF, eax
    finit
    jmp Calc_j

Calc_j:
    mov edx, Px
    ;add Punt3, 1
    mov esi, Punt3
    fld a2
    movzx eax, byte ptr[ecx+edx+1]
    mov val1, eax
    fimul val1
    fld a1
    mov edx, Py
    movzx eax, byte ptr[ecx + edx+1]
    mov val1, eax
    fimul val1
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi+5], al
    ;add Punt3, 1
    ;mov esi, Punt3
    mov byte ptr[ebx + esi+6], 32
    mov valJ, eax
    finit
    jmp Calc_d

Calc_d:
    mov edx, Px
    add Punt2, 1
    mov esi, Punt2
    fld a1
    fimul valC
    fld a2
    mov edx, Py
    fimul valF
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt2, 1
    mov esi, Punt2
    mov byte ptr[ebx + esi], 32
    finit
    jmp Calc_e

Calc_e:
    mov edx, Px
    add Punt2, 1
    mov esi, Punt2
    fld a2
    fimul valC
    fld a1
    mov edx, Py
    fimul valF
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt2, 1
    mov esi, Punt2
    mov byte ptr[ebx + esi], 32
    add Punt2, 2
    finit
    jmp Calc_h

Calc_h:
    mov edx, Px
    add Punt3, 1
    mov esi, Punt3
    fld a1
    fimul valG
    fld a2
    mov edx, Py
    fimul valJ
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt3, 1
    mov esi, Punt3
    mov byte ptr[ebx + esi], 32
    finit
    jmp Calc_i

Calc_i:
    mov edx, Px
    add Punt3, 1
    mov esi, Punt3
    fld a2
    fimul valG
    fld a1
    fimul valJ
    fadd st, st(1)
    fist val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    add Punt3, 1
    mov esi, Punt3
    mov byte ptr[ebx + esi], 32
    add Punt3, 2
    
    finit
    jmp InicioCiclo

Fin:
    
    mov PtrStr, -1
    mov edi, Punt4
    mov SizeEnd, edi
    
    jmp IntoString
    
    movzx eax, byte ptr[ebx + edi]
    
    jmp Fin

IntoString:
    mov esi, PtrStr
    mov eax, StrMemory
    add eax, MEMORYSIZE3-1
    
    add StrMemory, MEMORYSIZE3 - 1
    sub StrMemory, edi

    jmp BuscarEspacio

BuscarEspacio:
    sub edi, 1
    add esi, 1
    movzx ecx, byte ptr[ebx + edi]
    cmp edi, 3
    je salto
    cmp edi, -1
    je Write
    cmp ecx, ' '
    je ConDigitos
    cmp ecx, 0
    je ConDigitos
    jmp BuscarEspacio

salto:
    jmp ConDigitos

ConDigitos:
    cmp esi, 0
    je BuscarEspacio
    movzx ebp, byte ptr[ebx + edi + 1]
    cmp ebp, 99
    jg Digitos3
    cmp byte ptr[ebx + edi+1], 9
    jg Digitos2
    jmp Digitos1

Digitos3:
    mov esi, -1
    mov ebp, eax
    movzx eax, byte ptr[ebx + edi + 1]
    mov edx, 0
    mov ecx, 10
    idiv ecx
    mov ecx, eax
    add edx, 48
    mov eax, ebp
    mov byte ptr[eax], dl
    sub eax, 1
    mov ebp, eax
    mov eax, ecx
    mov edx, 0
    mov ecx, 10
    idiv ecx
    mov ecx, eax
    add edx, 48
    mov eax, ebp
    mov byte ptr[eax], dl
    sub eax, 1
    add ecx, 48
    mov byte ptr[eax], cl
    sub eax, 1
    mov byte ptr[eax], ' '
    sub eax, 1
    jmp BuscarEspacio


Digitos2:
    mov esi, -1
    mov ebp, eax
    movzx eax, byte ptr[ebx + edi + 1]
    mov edx, 0
    mov ecx, 10
    idiv ecx
    mov ecx, eax
    add edx, 48
    mov eax, ebp
    mov byte ptr[eax], dl
    sub eax, 1
    add ecx, 48
    mov byte ptr[eax], cl
    sub eax, 1
    mov byte ptr[eax], ' '
    sub eax, 1
    jmp BuscarEspacio

Digitos1:
    mov esi, -1
    movzx ecx, byte ptr[ebx + edi + 1]
    add ecx, 48
    mov byte ptr[eax], cl
    sub eax,1
    mov byte ptr[eax], ' '
    sub eax,1
    jmp BuscarEspacio


prueba:
    
    mov esi, pruebita
    movzx ebx, byte ptr[eax+ esi]
    add pruebita, 1
    jmp prueba

Write:
   
    add eax, 2
    mov StrMemory, eax
    mov eax, StrMemory
    
    invoke CreateFile, addr FileNameDest, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    cmp eax, INVALID_HANDLE_VALUE
    je openFail
    push ebx
    mov ebx, eax

    sub esp, 4
    mov edx, esp
    invoke WriteFile, ebx, StrMemory, 856, edx, 0
    add esp, 4
    test eax, eax
    jz fail

ok:
    invoke CloseHandle, ebx
    xor eax,eax

done:
    pop ebx
    ret

fail:
    invoke  CloseHandle, ebx

openFail:
    mov eax, -1
   
    
    
    

start endp
end start