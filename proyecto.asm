.model small
.stack 100h
.data
board db 36 dup(0) ; Tablero 6x6 inicializado a 0
missiles db 18 ; Misiles restantes
msg_prompt db 'Misil ', 0
msg_input db ', ingrese la celda a atacar (ej. A1): $'
msg_no_impact db 'Sin impacto', 13, 10, '$'
msg_impact db 'Impacto confirmado', 13, 10, '$'
msg_sunk db 'Impacto confirmado; submarino hundido.', 13, 10, '$'
msg_game_over db 'Juego terminado. Desea jugar de nuevo? (S/N): $'
msg_winner db 'Has hundido toda la flota enemiga! Felicidades!', 13, 10, '$'
msg_loser db 'No lograste hundir toda la flota enemiga. Fin del juego.', 13, 10, '$'
ctrl_e_exit db 'Saliendo del programa.', 13, 10, '$'  
newline db 0Dh, 0Ah, '$'
numMisil db 0    
msg_error db 'Ingresa letras MAYUSCULAS entre (A-F) y numeros entre (0-5). $'

.code
main:
    mov ax, @data
    mov ds, ax
    mov es, ax

start_game:   
    mov numMisil,1
    call init_board
    call print_board

    


game_start:
    
    call get_input
    call check_impact
    inc numMisil 
    cmp numMisil,19
    je game_OVER
    jmp game_start

game_over:
    ; Verificar si todos los barcos han sido hundidos
    call check_all_sunk
    ret

init_board:
    ; Inicializar el tablero y colocar barcos
    call clear_board
    call place_carrier
    call place_destroyer
    call place_submarine
    ret

clear_board:
    ; Limpiar el tablero
    mov si, 0
    mov cx, 36
    clear_loop:
        mov byte ptr [board + si], 0
        inc si
        loop clear_loop
    ret

place_carrier:
    ; Colocar portaviones de forma aleatoria
    ; Aqu� se debe implementar la l�gica para colocaci�n aleatoria
    ; Este es un ejemplo simple con colocaci�n fija para simplificar
    mov byte ptr [board + 0], 1
    mov byte ptr [board + 1], 1
    mov byte ptr [board + 2], 1
    mov byte ptr [board + 3], 1
    mov byte ptr [board + 4], 1
    ret

place_destroyer:
    ; Colocar destructor de forma aleatoria
    ; Este es un ejemplo simple con colocaci�n fija para simplificar
    mov byte ptr [board + 6], 2
    mov byte ptr [board + 7], 2
    mov byte ptr [board + 8], 2
    ret

place_submarine:
    ; Colocar submarino de forma aleatoria
    ; Este es un ejemplo simple con colocaci�n fija para simplificar
    mov byte ptr [board + 12], 3
    mov byte ptr [board + 13], 3
    mov byte ptr [board + 14], 3
    ret

get_input:       
    ; Leer entrada del usuario (coordenadas del ataque)
    call imprimirNumMisil    
    
    call read_input
    ; Convertir entrada a �ndice de matriz
    call convert_input
    ret   
    
imprimirNumMisil: 
    lea dx, msg_prompt
    mov ah, 09h
    int 21h
    lea dx, numMisil
    mov ah, 09h
    int 21h
    ret
    
    

read_input:      
    lea dx,msg_prompt 
    mov ah,09h   
    int 21h
    lea dx,newline 
    mov ah,09h      
    int 21h
    ; Leer dos caracteres del usuario (ej. A1)
    ; Suponer que los caracteres se almacenan en bx
    mov ah, 01h
    int 21h
    mov bl, al ; Primer car�cter
    int 21h
    mov bh, al ; Segundo car�cter
    ret

convert_input:
    ; Convertir la letra de columna a un �ndice de 0 a 5
    sub bl, 'A'      ; A = 0, B = 1, ..., F = 5
    ; Verificar si la letra est� fuera del rango permitido
    cmp bl, 5
    jae invalid_input

    ; Convertir el n�mero de fila a un �ndice de 0 a 5
    sub bh, '1'      ; 1 = 0, 2 = 1, ..., 6 = 5
    ; Verificar si el n�mero est� fuera del rango permitido
    cmp bh, 5
    jae invalid_input

    ; Calcular �ndice de la matriz: index = row * 6 + column
    mov al, bh       ; Almacenar fila en AL
    mov cl, 6
    mul cl           ; AX = row * 6
    add al, bl       ; AX = row * 6 + column
    mov si, ax       ; Almacenar �ndice en SI

    ret

invalid_input:
    ; Manejo de entrada inv�lida, aqu� se puede agregar c�digo para manejar errores
    ; Por ahora, solo salir de la funci�n con SI = 0 para evitar acceso fuera de l�mites
    xor si, si      
    lea dx, msg_error
    mov ah,09h
    int 21h
    ret


check_impact:
    ; Verificar si la celda atacada tiene un barco
    ; Actualizar estado del barco (hundido o no)
    mov al, byte ptr [board + si]
    cmp al, 0
    je no_impact
    ; Impacto confirmado
    cmp al, 1
    je carrier_hit
    cmp al, 2
    je destroyer_hit
    cmp al, 3
    je submarine_hit

no_impact:
    lea dx, msg_no_impact 
    mov ah,09h
    int 21h
    lea dx,newline  
    mov ah,09h
    int 21h
    jmp check_impact_end

carrier_hit:
    lea dx, msg_impact 
    mov ah,09h 
    int 21h
    lea dx,newline
    int 21h
    mov byte ptr [board + si], 0
    ret

destroyer_hit:
    lea dx, msg_impact 
    mov ah,09h
    int 21h
    lea dx,newline
    int 21h
    mov byte ptr [board + si], 0
    ret

submarine_hit:
    lea dx, msg_sunk 
    mov ah,09h
    int 21h
    lea dx,newline   
    mov ah,09h
    int 21h
    mov byte ptr [board + si], 0
    ret

check_impact_end:
    ret 
    
print_board:
    ; Mostrar el tablero actual (6x6)   
    push cx
    mov cx, 6 ; N�mero de filas
    mov di, offset board ; Direcci�n del inicio del tablero
    mov bx, 0 ; �ndice para las filas

print_row:
    ; Mostrar una fila del tablero
    mov si, 0 ; �ndice de la columna
print_col:
    
    ; Calcular la direcci�n de la celda
    mov ax, di 
    mov bx,ax
   
    add ax, si
    mov al, byte ptr [bx]   
    
    
    ; Convertir el valor de la celda a car�cter
    call convert_to_char
    ; Mostrar el car�cter
    mov ah, 02h
    int 21h
    ; Mover al siguiente car�cter en la fila
    inc si
    cmp si, 6
    jne print_col
    
    ; Mover a la siguiente fila
    add di, 6
    ; Imprimir nueva l�nea
    mov dl, 13 ; Car�cter de retorno de carro
    mov ah, 02h
    int 21h
    mov dl, 10 ; Car�cter de nueva l�nea
    mov ah, 02h
    int 21h

    loop print_row 
    pop cx
    ret

convert_to_char:
    ; Convertir el valor de la celda a un car�cter para mostrar
    cmp al, 0
    je cell_empty
    cmp al, 1
    je cell_carrier
    cmp al, 2
    je cell_destroyer
    cmp al, 3
    je cell_submarine
    cmp al, 4
    je cell_hit

cell_empty:
    mov dl, '~'
    ret
cell_carrier:
    mov dl, 'C'
    ret
cell_destroyer:
    mov dl, 'D'
    ret
cell_submarine:
    mov dl, 'S'
    ret
cell_hit:
    mov dl, 'X'
    ret



check_all_sunk:
    ; Verificar si todos los barcos han sido hundidos
    ; Asumir que todos los barcos hundidos significa que todas las celdas de barcos son 0
    mov cx, 36
    mov si, 0
    mov al, 0
    check_loop:
        cmp byte ptr [board + si], 0
        jne not_sunk
        inc si
        loop check_loop
    mov al, 1 ; Todos los barcos hundidos 
    ; Mostrar mensaje de victoria o derrota
    call display_game_result
    ; Ofrecer opci�n de jugar nuevamente o salir
    call restart_game
not_sunk:
    ret

display_game_result:
    cmp al, 1
    je display_winner
    lea dx, msg_loser
    int 21h
    jmp display_end

display_winner:
    lea dx, msg_winner
    int 21h

display_end:
    ret

restart_game:
    ; Ofrecer opci�n de reiniciar el juego
    lea dx, msg_game_over             
    mov ah,09h
    int 21h
    call read_input
    cmp bl, 'S'
    je start_game
    lea dx, ctrl_e_exit  
    mov ah,09h
    int 21h
    mov ax, 4c00h 
    mov ah,09h
    int 21h
    ret

print_string:
    ; Imprimir una cadena terminada en '$' a la consola   
    
    int 21h
    lea dx,newline
    ret

end main
