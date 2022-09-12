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

    ;Se carga los txt de destino y el que tiene la imagen

    FileName db "C:/Users/arman/Documents/Segundo Semestre 2022/Arqui/Proyecto1Individual/src/proyecto1individual/prueba.txt", 0
    FileNameDest db "C:/Users/arman/Documents/Segundo Semestre 2022/Arqui/Proyecto1Individual/src/proyecto1individual/PruebaResultado.txt", 0
    ErrorCaption  db "Error!", 0
    ErrorMsg	  db "Cannot open file", 0
    string db '2', 0

    ;Se almacenan dos constantes para los calculos de la interpolación

    a1 REAL4 0.666667
    a2 REAL4 0.333333

    ;Punteros a usar para almacenar los datos de la interpolación en memoria

    Punt1 DWORD 0
    Punt2 DWORD 596
    Punt3 DWORD 1192
    Punt4 DWORD 1788
    Pivote DWORD 0

    VarX DWORD 0

    pruebita DWORD 0

    dataSize dword 65535

    ;Contador de caracteres para escribir en el txt
    SizeAscii DWORD 0


.data?

    ;Variables necesarias para leer el txt
    hFile HANDLE ?
    ihFile HANDLE ?
    hMemory HANDLE ?
    ihMemory HANDLE ?
    enteroMemory HANDLE ?


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

    

    

    ;Memoria necesaria para guardar los distintos datos para evitar sobreescritura
.const
    MEMORYSIZE equ 300000
    MEMORYSIZE2 equ 350000
    MEMORYSIZE3 equ 700000

.code

start PROC
    
    ;Se abre el archivo con los valores de pixeles
	
    invoke CreateFile, addr FileName, GENERIC_READ, FILE_SHARE_READ,
    NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    
    mov hFile, eax

    ;Se aparta memoria para leer los datos del txt

    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, MEMORYSIZE
    mov hMemory, eax
    invoke GlobalLock, hMemory
    mov pMemory, eax

    ;Se aparta memoria para la conversión de los datos de ascii a entero

    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, MEMORYSIZE2
    mov enteroMemory, eax
    invoke GlobalLock, enteroMemory
    mov IMemory, eax

    ;Se aparta memoria para el resultado de la interpolacion

    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, MEMORYSIZE2
    mov ihMemory, eax
    invoke GlobalLock, ihMemory
    mov NewMemory, eax

    ;Se aparta memoria para almacenar los datos de entero a ascii

    invoke GlobalAlloc, GMEM_MOVEABLE or GMEM_ZEROINIT, MEMORYSIZE3
    mov sihMemory, eax
    invoke GlobalLock, sihMemory
    mov StrMemory, eax

    

    ;Se lee el archivo txt con los pixeles
    
    invoke ReadFile, hFile, pMemory, MEMORYSIZE - 1, addr ReadSize, NULL


    mov contador, 0
    mov contadorInt, 0
    ;mov IMemory, esp
    mov eax, pMemory
    sub eax, 1

    
  
    
    
    jmp ConvertToInt



ConvertToInt:

    ;Contador para conocer la cantidad de digitos del numero

    add contador, 1
    add eax, 1
    
    movzx ebx, byte ptr[eax]
    sub ebx, 48
         
    cmp byte ptr[eax + 1], 36   ;Se compara para saber si se terminó los datos a conertir
    je Convert
    
    cmp byte ptr[eax+1], 32 ;Compara para saber si encontró un espacio
    jne ConvertToInt
    je Convert

   
    jmp ConvertToInt

Convert:

    ;Compara para saber la cantidad de digitos del numero

    add eax, 1
    cmp contador, 1
    je Conver1Digit
    cmp contador, 2
    je Conver2Digit
    cmp contador, 3
    je Conver3Digit

;Para convertir los numeros si es de 1 solo digito solo se debe convertir a entero restabdo 48 y se
;guarda en memoria

Conver1Digit:
    add contadorInt, 1
    mov ebx, IMemory
    add ebx, 1
    mov IMemory, ebx
    mov pMemory, eax
    mov ecx, IMemory
    mov bl, byte ptr[eax-1]
    sub ebx, 48
    mov byte ptr[ecx],bl
    mov contador, 0
    cmp byte ptr[eax], 36
    je IniciarAlgoritmo
    jmp ConvertToInt


;Para convertir los numeros si es de 2 digitos, se resta 48 al primer valor y se multiplica por 10 
;al segundo digito tambien se le resta 48 pero se suma al resultado anterior

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

;Para convertir los numeros si es de 3 digitos, se resta 48 al primer valor y se multiplica por 10 
;al segundo digito tambien se le resta 48 pero se suma al resultado anterior
;A la suma de los numeros pasados se les multiplica por 10 y al tercer digito se conviertr y se suma a este numero

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


;Inicio de la interpolación

IniciarAlgoritmo:
    mov ecx, IMemory
    sub ecx, contadorInt
    
    ;mov eax, offset NewMemory
    ;mov NewMemory, eax
    mov Px, 0       ;Se colocan los punteros para recorrer la matriz
    mov Py, 100

    mov ebx, NewMemory

    jmp InicioCiclo

InicioCiclo:
    add Px, 1
    add Py, 1
    

    add Pivote, 1   ;El pivote funciona para conocer cuando llegamos al fin de una fila y pasar a la siguiente
   
    cmp Py, 10000   ;Esto nos indica que hemos analizado todos los valores
    je Fin
    cmp Pivote, 100 ;Indica que se debe pasar de fila
    je MoverPunteros
    
    jmp Calc_a

MoverPunteros:
    add Px, 1
    add Py, 1

    ;Al llegar al fin de una fila se deben mover los punteros 1192 posiciones para 
    ;no caer encima de los datos anteriores
   
    add Punt1, 1192 
    add Punt2, 1192
    add Punt3, 1192
    add Punt4, 1192
    mov Pivote, 0
    add Pivote, 1
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
       
    fld a1                                  ;Esta instrucción nos carga el valor decimal al stack(0)
    movzx eax, byte ptr[ecx+edx]
    mov val1, eax
    fimul val1                              ;Acá se multiplica el valor del pixel por el valor del stack(0)
    fld a2                                  ;Esta instrucción nos carga el valor decimal al stack(1)
    movzx eax, byte ptr[ecx + edx+1]
    mov val1, eax
    fimul val1                              ;Acá se multiplica el valor del pixel por el valor del stack(1)
    fadd st, st(1)                          ;Se suma el valor del stack(0) y stack(1)
    fist val1                               ;Este redondea la suma del stack(0) y lo almacena en val1
    mov eax, val1
    mov byte ptr[ebx + esi], al
    movzx eax, byte ptr[ebx + esi]
    add Punt1, 1
    mov esi, Punt1
    mov byte ptr[ebx + esi], ' '
    finit                                   ;Se limpia el stack
    jmp Calc_b
    

Calc_b:
    
    mov edx, Px
        add Punt1, 1
        mov edi, Px
        mov esi, Punt1
        fld a2
        movzx eax, byte ptr[ecx + edx]
        mov val1, eax
        fimul val1
        fld a1
        movzx eax, byte ptr[ecx + edx + 1]
        mov val1, eax
        fimul val1
        fadd st, st(1)
        fist val1
        mov eax, val1
        mov byte ptr[ebx + esi], al
        add Punt1, 1
        mov esi, Punt1
        mov byte ptr[ebx + esi], ' '

        cmp Pivote, 99
        je PonerUltimoValor

        ;add Punt1, 1
        ;mov esi, Punt1
        ;movzx eax, byte ptr[ecx + edx + 1]
        ;mov byte ptr[ebx + esi], al
        ;add Punt1, 1
        ;mov esi, Punt1
        ;mov byte ptr[ebx + esi], ' '

    

        mov Px, edi
        finit
    
    
        jmp Calc_c

PonerUltimoValor:
    add Punt1, 1
    mov esi, Punt1
    movzx eax, byte ptr[ecx + edx + 1]
    mov byte ptr[ebx + esi], al
    add Punt1, 1
    mov esi, Punt1
    mov byte ptr[ebx + esi], ' '

    mov Px, edi
    finit
    
    
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
    mov edi, Py
    mov byte ptr[ebx + esi], al
    mov Py, edi
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
    cmp Pivote, 99
    je Calc_l_final
    
    ;add Punt4, 1
    ;mov esi, Punt4
    ;movzx eax, byte ptr[ecx + edx+1]
    ;mov byte ptr[ebx + esi], al
    ;add Punt4, 1
    ;mov esi, Punt4
    ;mov byte ptr[ebx + esi], 32
    finit
    jmp Calc_f

Calc_l_final:
    add Punt4, 1
    mov esi, Punt4
    movzx eax, byte ptr[ecx + edx + 1]
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
    cmp Pivote, 99
    je Calc_f_ultimo
    ;mov byte ptr[ebx + esi+5], al
    
    ;mov byte ptr[ebx + esi+6], 32
    mov valF, eax
    finit
    jmp Calc_j

Calc_f_ultimo:
    mov byte ptr[ebx + esi + 5], al

    mov byte ptr[ebx + esi + 6], 32
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
    cmp Pivote, 99
    je Calc_j_ultimo
    ;mov byte ptr[ebx + esi+5], al
    
    ;mov byte ptr[ebx + esi+6], 32
    mov valJ, eax
    finit
    jmp Calc_d

Calc_j_ultimo:
    mov byte ptr[ebx + esi+5], al
    
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
    cmp Pivote, 99
    je Calc_e_ultimo
    ;add Punt2, 2
    finit
    jmp Calc_h

Calc_e_ultimo:
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
    cmp Pivote, 99
    je Calc_i_ultimo
    ;add Punt3, 2
    
    finit
    jmp InicioCiclo

Calc_i_ultimo:
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

    ;Convertir los enteros a su valor en  ascii

IntoString:
    mov esi, PtrStr
    mov eax, StrMemory
    add eax, MEMORYSIZE3-1
    
    add StrMemory, MEMORYSIZE3 - 1
    sub StrMemory, edi

    jmp BuscarEspacio

        ;Se buca un espacio que nos indique cuando escontró un valor

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


        ;Comparando el valor con 99 o 9 sabremos si es de 1, 2 o 3 digitos

ConDigitos:
    cmp esi, 0
    je BuscarEspacio
    movzx ebp, byte ptr[ebx + edi + 1]
    cmp ebp, 99
    jg Digitos3
    cmp byte ptr[ebx + edi+1], 9
    jg Digitos2
    jmp Digitos1


    ;Para convertir a ascii los valores debemos dividirlos entre 10 y ir convirtiendo la parte decimal
    ;Para convertir debemos sumar por 48

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
    add SizeAscii, 4
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
    add SizeAscii, 3
    jmp BuscarEspacio

Digitos1:
    mov esi, -1
    movzx ecx, byte ptr[ebx + edi + 1]
    add ecx, 48
    mov byte ptr[eax], cl
    sub eax,1
    mov byte ptr[eax], ' '
    sub eax,1
    add SizeAscii, 2
    jmp BuscarEspacio


prueba:
    
    mov esi, pruebita
    movzx eax, byte ptr[ebx + esi]
    add pruebita, 1
    cmp pruebita, 174
    je pueba2
    jmp prueba

pueba2:
    jmp prueba

Write:
   
    sub SizeAscii, 1
    add eax, 2
    mov StrMemory, eax
    mov eax, StrMemory

    ;Se abre el archivo txt donde se quiere guardar los datos
    
    invoke CreateFile, addr FileNameDest, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    cmp eax, INVALID_HANDLE_VALUE
    je openFail
    push ebx
    mov ebx, eax

    sub esp, 4
    mov edx, esp
    invoke WriteFile, ebx, StrMemory, SizeAscii, edx, 0 ;Se escriben los datos al txt
    add esp, 4
    test eax, eax

    invoke GlobalUnlock, pMemory
    invoke GlobalUnlock, StrMemory
    invoke GlobalFree, hMemory
    invoke CloseHandle, hFile
    
    jz fail

ok:
    invoke CloseHandle, ebx
    xor eax,eax

done:
    pop ebx
    invoke ExitProcess, NULL

fail:
    invoke  CloseHandle, ebx
    invoke ExitProcess, NULL

openFail:
    mov eax, -1
  

start endp
end start