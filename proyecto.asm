.model small
.stack 100h
.data 
    header db 6 ,'A','B','C','D','E','F', 0   ; Header row, null-terminated
    matrixShips db 6 dup('0')                ; Matrix of ships (6x6)
                db 6 dup('0') 
                db 6 dup('0') 
                db 6 dup('0') 
                db 6 dup('0') 
                db 6 dup('0') 
                
    matrixUser db 6 dup('*')                 ; User matrix (6x6)
               db 6 dup('*')
               db 6 dup('*')
               db 6 dup('*')
               db 6 dup('*')
               db 6 dup('*')       
               
    counter db 0
               
    newline db 0Dh, 0Ah, '$'                 ; Newline characters (carriage return and line feed)

.code
main proc
    mov ax, @data        ;gets @data segment
    mov ds, ax           ;saves the pointer of @data to ax
    mov es, ax           ;extra segment register has also the pointer
             
    mov ah,7             ;seven as its 7 rows counting header
    push ax
    ; Print header
    lea dx, header
    call PrintString
    
    ; Print newline
    lea dx, newline
    call PrintString
    
    ; Print matrixUser
    lea si, matrixUser
    mov cx, 6            ; Number of rows    
    
    call PrintMatrix
    
    jmp salir
main endp  



;------
;print string function
;------
PrintString:
    mov ah, 09h
    int 21h
    ret

;---------------------------------------------------------------
; PrintMatrix: Prints a 6x6 matrix
;--------------------------------------------------------------- 

PrintMatrix:
    push cx       ;push the counter
    push si       ;push the index we are in. starting in 0
PrintMatrixRow:
    mov cx, 6            ; Number of rows  
    cmp counter,6
    je salir
    
PrintMatrixCol:
    lodsb                ; Load byte at DS:SI into AL, increment SI    ;;; ayuda a recorrer la fila (0,5 va el index)
    call PrintChar       ; Print the character in AL
    loop PrintMatrixCol  ; Repeat for 6 columns
    
    ; Print newline
    lea dx, newline      ;regresa a la siguiente linea
    call PrintString     ;imprimo el salto de linea
    
    ;compare if counter or something is 6   
    add counter,1
    loop PrintMatrixRow  ; Repeat for 6 rows
    
    pop si               ; pop 6
    pop cx               ; pop 6
    ret

;---------------------------------------------------------------
; PrintChar: Prints a character in AL
;---------------------------------------------------------------
PrintChar:
    mov ah, 0Eh          ; Teletype output
    int 10h              ; BIOS video interrupt
    ret

salir: