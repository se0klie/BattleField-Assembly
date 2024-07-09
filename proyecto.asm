name "BATTLEFIELD JESUS SUAREZ,HAILIE JIMENEZ"  
.model small
.stack 100h
.data                   

;MATRIZ DEL JUGADOR     // inicializamos la matriz de jugador con 0s
matriz_navios_comp db 36 dup(0)
;SETEO DE VARIABLES
linea db 00h                            
coluna db 00h
sentido dw 00h
endereco_lin_col dw 00h
simbolo db 00h 
tamanobarco db 00h     

;COLUMNAS VALIDAS       // creamos un arreglo de todas las columnas inputs validas para el usuario                     
columnas_mayus db 'A', 'B', 'C', 'D', 'E', 'F'
columnas_minus db 'a', 'b', 'c', 'd', 'e', 'f'
cabecera_matriz db "  A B C D E F", 10, 13, "$"

;VARIABLES PARA EL MANEJO DEL CURSOR
colcursor db 00h
lincursor db 00h
pagcursor db 00h 
;VARIABLES PARA CONTABILIZAR LOS TIROS
tiros db 00h
tiros_repetidos db 20 dup(100)
coltiros EQU 7
lintiros EQU 22
acertos db 00h 
linacertos EQU 6
;BANDERAS PARA UBICAR 'P', 'D' Y 'S'
ubicando_portaviones db 0
ubicando_destructor db 0
ubicando_submarino db 0

;CONTADORES PARA CONFIRMAR BARCOS HUNDIDOS (ENCERAR AL FINAL DEL JUEGO)
tamano_p db 0
tamano_d db 0
tamano_s db 0
CR EQU 13    ; ENTER
LF EQU 10    ; LINEA  

   MSGINICIO1 DB 0BAh,'          B A T A L L A    N A V A L             ',0BAh,'$' 
   MSGINICIO3 DB 0BAh,'         JESUS SUAREZ,   HAILIE JIMENEZ          ',0BAh,'$' 

   
   CLINICIAL EQU 14

   COLUNA_CONFIG EQU 30   
    
   MSG_CONFIG21 DB '                    ','$'
   MSG_CONFIG22 DB '                   ESPERE UN MOMENTO       ','$'
 
    COLUNA_TIRO EQU 1 
    ;COLUNA_STATS EQU 28
    
    MSGJUEGOTIRO1 DB   3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,'$'
    MSGJUEGOTIRO2 DB   0B3h,'  BATALLA NAVAL ',0B3h,'$'
    MSGJUEGOTIRO3 DB   3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,'$'
    MSGJUEGOTIRO4 DB   0B3h,'  A',0B3h,'B',0B3h,'C',0B3h,'D',0B3h,'E',0B3h,'F',0B3h,'$'
    MSGJUEGOTIRO6 DB   0B3h,'1            ',0B3h,'$'
    MSGJUEGOTIRO7 DB   0B3h,'2            ',0B3h,'$'
    MSGJUEGOTIRO8 DB   0B3h,'3            ',0B3h,'$'
    MSGJUEGOTIRO9 DB   0B3h,'4            ',0B3h,'$'                                                   
    MSGJUEGOTIRO10  DB 0B3h,'5            ',0B3h,'$'
    MSGJUEGOTIRO11  DB 0B3h,'6            ',0B3h,'$'
    MSGJUEGOTIRO15  DB 3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,'$'
    
   
    ;MSGSTAT1 DB  0B3h,'Jugador           ',0B3h,'$'
    ;MSGSTAT2 DB  0B3h,'  Tiros:          ',0B3h,'$'
    ;MSGSTAT3 DB  0B3h,'  Aciertos:       ',0B3h,'$'  
     
    COLUNA_COORDENADAS EQU 23
    COLUNA_MENSAGENS EQU 38
    
    MSGINPUT1 DB 0DAh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,3Dh,0BFh,'$' 
    MSGINPUT2 DB ,'MISIL 00 EN LA CELDA:      ',0B3h,'MENSAJE: $'    

    MSG_TURNO1 db "SU TURNO$"

    MSG_HIT db "IMPACTO$"
    
    MSG_P_HUNDIDO db "  PORTAVIONES HUNDIDO$"
    
    MSG_D_HUNDIDO db "  DESTRUCTOR HUNDIDO$"
    
    MSG_S_HUNDIDO db "  SUBMARINO HUNDIDO$"

    MSG_MISS db "SIN IMPACTO$"

    MSG_DOUBLE db "POSICION REPETIDA$"
    
    MSG_LIMPA_MSG db '                                   $'

    MSG_LIMPA_COOR db '   $'
    MSG_VITORIA db "HAS GANADO$"

    MSG_DERROTA db "HAS PERDIDO, 18 MISILES AGOTADOS$" 

    ;MSGFINAL1 db 0C9h,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0BBh,'$'
    MSGFINAL1 db 0BAh,'               FIN  DEL  JUEGO              ',0BAh,'$'
    MSGFINAL2 db 0BAh,'                                            ',0BAh,'$'
    MSGFINAL3 db 0BAh,'      [J]ugar de nuevo       [S]alir        ',0BAh,'$'
   
    LINHA_FINAL EQU 10
    COLUNA_FINAL EQU 17
.code
push_all MACRO  ; macro para salvar el contexto // se hace push a todos los registros utilizados
    push ax
    push bx
    push cx
    push dx
    ;;;;;;;
    push si
    push di
    push bp
endm

pop_all MACRO      ; macro para restaurar el contexto        // se hace pull a todos los registros utilizados
    pop bp
    pop di
    pop si
    ;;;;;;
    pop dx
    pop cx
    pop bx
    pop ax
endm
readkeyboard proc ; leer un caracter sin eco en AL
    mov ah, 7
    int 21H   
    ret       
endp
writechar proc    ;Escribe un caracter
    push ax       
    mov ah, 02H
    int 21H
    pop ax
    ret
endp 
writedirect proc    ;Escribe un caracter
    push ax       
    mov ah, 06H
    int 21H
    pop ax
    ret
endp 
posicionacursor proc  ;Coloque el cursor, necesite la pagina en BH, la columna en DL y la fila en DH
    push ax 
    mov ah,02h     
    int 10h 
    pop ax 
    ret
endp
printstring proc ;Imprime string terminada en $ , necesita de OFFSET en DX
    push ax
    mov ah,09h
    int 21h
    pop ax
    ret
endp  

getcursorposition proc ;obtener la posicion del cursor, por ahora solo necesita la columna, asi que eso es lo que guarda
    push_all
    mov ah,03h
    mov bh,pagcursor
    int 10h
    mov colcursor,DL 
    pop_all
    ret
endp
drawsymbol proc    ;dibuja los simbolos de los barcos
    push ax 
    push cx
    mov ah,09h
    mov cx,1
    int 10h
    pop cx
    pop ax
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________ 
drawhit proc    ;disena el simbolo de hit en la matriz de tiros
    push_all 
    mov bh,02
    mov AH,09h
    mov AL,031h ;1 si es correcto
    mov CX,1
    mov BL,0Ah
    int 10h
    pop_all
    ret
endp 
drawmiss proc    ;disena el simbolo de miss en la matriz de tiros
    push_all 
    mov bh,02
    mov AH,09h
    mov AL,030h
    mov CX,1
    mov BL,04h
    int 10h
    pop_all
    ret
endp 
disenacuadrado proc
    push_all
    mov bh,02
    mov AH,09h
    mov AL,0A4h ; símbolo ASCII 254 (¦)
    mov CX,1
    mov BL,0Eh 
    int 10h
    pop_all
    ret
endp  
victorymsg proc      ;escribe el mensaje de victoria mostrado al usuario cuando gana
    push_all                ;primero guarda todo lo esencial
    ;Limpia la linea
    mov bh,02
    mov dh,22   ;linea para mandar mensajes
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG                ; carga el mensaje que limpia la linea
    call printstring

    ;Manda un mensaje
    mov bh,02
    mov dh,22 
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_VITORIA   ;"Has Ganado"
    call printstring

    ;espera 5 segundos
    mov ah,86h
    mov cx,4Ch
    mov Dh,04Bh
    mov dl,040h
    int 15h
    pop_all
    ret
endp                  
defeatmsg proc                                  ; escribe el mensaje de derrota al usuario cuando pierde
    push_all
    ;Limpia la linea
    mov bh,02
    mov dh,22   ;linea donde se imprime el mensaje
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG                 ;se envia la linea para limpiar
    call printstring

    ;Manda un mensaje
    mov bh,02
    mov dh,22 
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_DERROTA                   ;"HAS PERDIDO, MISILES AGOTADOS"
    call printstring
    
    ;espera 5 segundos
    mov ah,86h
    mov cx,4Ch
    mov Dh,04Bh
    mov dl,040h
    int 15h
    pop_all
    ret
endp  
missedshot proc              
    push_all                                    ;carga todo lo esencial
    ;Limpia una linea
    mov bh,02
    mov dh,22   ;linea para mandar mensajes
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG                 ; limpia la linea
    call printstring

    ;Manda un mensaje
    mov bh,02
    mov dh,22 
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_MISS                      ;"Error de tiro"
    call printstring
    pop_all
    ret
endp
hitshot proc                                    ;muestra el mensaje de impacto
    push_all
    ;Limia la linea
    mov bh,02
    mov dh,22   ;linea para mandar mensajes
    mov dl,COLUNA_MENSAGENS
    call posicionacursor                        
    mov DX,OFFSET MSG_LIMPA_MSG                 ;limpia la linea
    call printstring

    ;Imprime un mensaje
    mov bh,02
    mov dh,22   ;linea para mandar mensaje
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_HIT                       ;"Acerto el tiro!!"
    call printstring
    cmp tamano_p, 4
    je P_HUNDIDO
    cmp tamano_d, 2
    je D_HUNDIDO
    cmp tamano_s, 2
    je S_HUNDIDO
    jne FIN_HITSHOT
  P_HUNDIDO:
    lea DX,MSG_P_HUNDIDO                        ;"Acerto el tiro!!"
    call printstring
    mov tamano_p, 0
    jmp FIN_HITSHOT
  D_HUNDIDO:
    lea DX,MSG_D_HUNDIDO                        ;"Acerto el tiro!!"
    call printstring
    mov tamano_d, 0
    jmp FIN_HITSHOT
  S_HUNDIDO:
    lea DX,MSG_S_HUNDIDO                        ;"Acerto el tiro!!"
    mov tamano_s, 0
    call printstring    
  FIN_HITSHOT:
    pop_all
    ret
endp  
doublehit proc                                  ; imprime msg para mostrar que uso una posicion ya usada
    push_all
    ;Limpia la linea
    mov bh,02
    mov dh,22   ;linea para mandar mensajes
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG
    call printstring

    ;Imprime un mensaje
    mov BH,02
    mov DH,22
    mov DL,COLUNA_MENSAGENS
    call posicionacursor
    mov DX, OFFSET MSG_DOUBLE
    call printstring
    pop_all
    ret
endp  

RNG proc                                        ;genera posiciones random
    push_all
    mov ah, 00h                                 ; Tomar el tiempo del sistema       
    int 1AH            

    mov  ax, dx                                 ;move valor para dividir
    xor  dx, dx  
    mov  cx, 36                                 ;dividir por 100 para que el restante sea de 0 a 99  
    div  cx                                     ; DX tener el resto de la division
    mov endereco_lin_col, dx

    push dx
    mov ax,dx
    xor dx,dx
    mov cx, 6                                   ;dividir por 10 para agrefar el valor a la coluna
    div cx
    mov coluna,dl
    mov linea,al
    pop dx

    mov ax,dx
    xor dx,dx
    mov cx,2                                    ;elige el sentido
    div cx
    cmp dx,1
    je RNGh                                     ;revisa por  1 = horizontal
    mov sentido, 'v'
    jmp RNGok
  RNGh:                                         ;sentido horizontal
    mov sentido, 'h'
  RNGok: 
    pop_all                                     ;vacia el stack
    ret
endp  
definemode proc                                 ; define el modo
    push ax
    mov al, 03h                                 ; modo texto 80 x 25
    mov ah, 00h                                 ; modo de video
    int 10h
    pop ax
    ret
endp 
changepage proc                                 ; muda a pagina, o numero da pagina definido em al
    push ax
    mov ah, 05h                                 ; numero de interrupciones de BIOS
    int 10h
    pop ax
    ret
endp
   
verificanavio proc                              ;proc para comprobar si no habra superposicion de barcos o bordes | necesita desplazamiento de matriz en SI y end_lin_col en BX
    mov cl,tamanobarco                         
    cmp sentido, 'h'                            ;checks si la orientacion es horizontal
    je VERIFHORIZ 
  VERIFVERT:                                    ;verifica si es vertical
	cmp byte ptr [SI+BX], 0 ;Prueba si hay algo en la posicion
    ja VERIFICANAVIOINVALIDO     
    cmp BX,36
    jb NELV ;N?o Estoy en la linea vertical
    jmp VERIFICANAVIOINVALIDO
    NELV:                                       ;va a la siguiente fila
    add BX,6
    loop VERIFVERT                              ;Loop basado en el tamano del barco
    jmp VALIDO
    
  VERIFHORIZ:                                   ;verifica orientacion horizontal
    mov cl,tamanobarco
    mov bl,coluna
  LOOPVERIFHORIZ1:                              ;Prueba si no rompe la linea
    add BX, 1
    cmp BX,6
    jb NELH                                     ;No estoy en linea horizontal
    ja VERIFICANAVIOINVALIDO
    NELH:
    loop LOOPVERIFHORIZ1                        ;Loop basado en el tamano del barco
    mov BX,endereco_lin_col
    mov cl,tamanobarco
  LOOPVERIFHORIZ2:              
    cmp byte ptr[SI+BX], 0                      ;Prueba si hay algo en la posicion
    ja VERIFICANAVIOINVALIDO                    ;si hay error por index, jump a invalido
    add BX, 1
    loop LOOPVERIFHORIZ2    
    jmp VALIDO
   
  VERIFICANAVIOINVALIDO:                        ;se busca invalido, BX = 100 
    mov BX,100
    jmp FIM_VERIFICACION   
  VALIDO:   ;Si es valido reestablece los valores
    mov bx, endereco_lin_col
    mov cl, tamanobarco
  FIM_VERIFICACION:
    ret
endp
    
readinputaction proc                            ; Lee los datos de entrada del disparo
   push_all
   
    mov cx, 2
  PULOACTION:
    dec cx
    cmp cx, 0
    je LEERFILA
  LEERCOLUMNA:
    call readkeyboard                           ; lee input de keyboard
    cmp al, CR                                  ; verifica si es ENTER
    jz LEERCOLUMNA ; je
     
    cmp al, 'a'
    jl INPUT_MAYUS                              ;checa si ingreso una minus
    jge INPUT_MINUS
    
  INPUT_MAYUS:
    cmp al, 'A'                                 ; verifica si es valido
    jb LEERCOLUMNA 
  
    cmp al, 'F'
    ja LEERCOLUMNA
    
    jmp COL_VALIDA    
    
  INPUT_MINUS:
    cmp al, 'a'                                 ; verifica si es valido
    jb LEERCOLUMNA 
  
    cmp al, 'f'
    ja LEERCOLUMNA
    
  COL_VALIDA:
    mov bx, 0
    xor ah, ah
    cmp al, 'a'
    jl INDICE_COLMAYUS
    jge INDICE_COLMINUS
    
  INDICE_COLMAYUS:
    mov SI,OFFSET columnas_mayus
    cmp byte ptr [SI+BX], al
    je SETTEAR_INDICECOL
    inc bx
    jmp INDICE_COLMAYUS
      
  INDICE_COLMINUS:
    mov SI,OFFSET columnas_minus
    cmp byte ptr [SI+BX], al
    je SETTEAR_INDICECOL
    inc bx
    jmp INDICE_COLMINUS
       
  SETTEAR_INDICECOL:  
    mov dl,al
    call writechar
    
  VALORCOLUNAACTION:
    mov coluna,bl                                ;COLUMNA
    mov cx,1
    jmp PULOACTION
  LEERFILA:
    call readkeyboard
    cmp al,CR                                   ; verifica si es ENTER
    jz LEERFILA ; je
     
    cmp al,'1'                                  ; verificar si es valido
    jb LEERFILA 
  
    cmp al,'6'
    ja LEERFILA
    mov dl,al
    call writechar
    sub al,'1'
    mov ah,0
    mov linea,al
    mov dl,6
    mul dl
    mov ah, coluna
    add al,ah                                   ;(linea*10)+coluna
    xor ah,ah
    mov endereco_lin_col,ax                     ;mover direccion decimal = posicion el vector
    pop_all  
  ret
endp  
addbarco proc                                   ;necesita indice en BX, direccion de matriz en SI y tamano de barco en CX
    push dx
    push cx
    
    cmp ubicando_portaviones, 1                 ;comprueba si estan ubicados los barcos
    je UBICAR_PORTAVIONES
    cmp ubicando_destructor, 1
    je UBICAR_DESTRUCTOR
    cmp ubicando_submarino, 1
    je UBICAR_SUBMARINO
    
    UBICAR_PORTAVIONES:                         ;asigna p a portaviones
        mov dl, 'P'                             ;salta a definir sentido
        jmp DEFINIR_SENTIDO
    UBICAR_DESTRUCTOR:
        mov dl, 'D'
        jmp DEFINIR_SENTIDO
    UBICAR_SUBMARINO:
        mov dl, 'S'
    
    DEFINIR_SENTIDO:
        cmp sentido, 'h'                        ;comprueba si es horizontal
        je HORIZONTAL
    
  VERTICAL:     
    mov [SI+BX],dl                              ;Coloca valor de DL en la posicion BX de la matriz ("vetor")
    add BX, 6
    loop VERTICAL                               ;LOOP Decrementa o cx
    jmp BARCOOK
  HORIZONTAL:
    mov [SI+BX], dl                             ;Coloca valor de DL en la posicion BX de la matriz ("vetor")
    add BX, 1
    loop HORIZONTAL                             ;decrementa cx mientras no sea 0 y repite el bucle
    jmp BARCOOK
    
  BARCOOK:
    pop cx                                      ;restaura valor de cx desde la pila
    pop dx 
    ret
endp   
actualizarstats proc 
    push_all                                    ;GUARDA REGISTROS ANTES DE COMENZAR
    ;Tiros Jugador 
    xor CX, CX
    mov BH, 02                                  ;SELECCIONA PAG 2
    mov DL, coltiros                            ;COLUMNA DONDE SE MUESTRAN LOS TIROS
    mov DH, lintiros                            ;FILAS DONDE SE MUESTRAN LOS TIROS
    call posicionacursor
      xor DX,DX
      xor AX,AX
	  mov DL, tiros
	  add DL, 48                                ;CONVIERTE A ASCII
	  TIROSREP:
	  cmp DL, 58                                ;COMPARA DL CON ":"
	  jb ESCRIBETIROS
	  sub DL, 10
	  inc AL
	  mov DH, AL
	  loop TIROSREP 
	  ESCRIBETIROS:                             ;REPITE BUCLE HASTA QE CX = 0
	  mov AL, DL
	  mov DL, DH
	  add DL, 48
	  call writedirect                          ;ESCRIBE EN PANTALLA
	  mov DL, coltiros+1 
      mov DH, lintiros
    call posicionacursor
      xor DX,DX
      mov DL, AL
      call writedirect	
      
      
    xor AX,AX
    xor CX, CX
    ;Aciertos Jugador
	mov DL, coltiros                            ;hace lo mismo que en la parte superior pero con los aciertos
    mov DH,linacertos
    call posicionacursor
      xor DX,DX
	  mov DL, acertos
	  add DL, 48
	  ACIERTOSREP:
	  cmp DL, 58
	  jb ESCRIBEACIERTOS
	  sub DL, 10
	  inc AL
	  mov DH, AL
	  loop ACIERTOSREP 
	  ESCRIBEACIERTOS:
	  
	  mov DL, coltiros+1
      mov DH, linacertos
      call posicionacursor
      xor DX,DX
      mov DL, AL
      
    pop_all
    ret
endp  
   
   
fireshot proc                           ;"Dispara" la toma modificando el vector, la matriz de pantalla y actualizando las estadisticas
    push bx
    mov SI, OFFSET matriz_navios_comp
    mov al, bl
    mov BX, endereco_lin_col
    mov byte ptr[SI+BX], al
    pop bx
    ;Vector modificado   
    cmp bx, 'P'                         ;compara si golpeo un portaviones
    je GOLPE
    cmp bx, 'D'                         ;compara si fue un destryctir
    je GOLPE                            ;compara si golpeo un submarino
    cmp bx, 'S'
    je GOLPE
    jmp MISS                            ;saltp a miss



  GOLPE:
    mov bh,coluna                               
    mov al,2
    mul bh                                      ;multiplica por 2 para obtener el equivalente "grafico"
    add al,4                                    ;Suma con columna inicial
    mov bh,02                                   ;pagina atual
    mov dh,linea
    add dh,7
    mov dl,al
    call posicionacursor
    call drawhit
    ;Matriz de pantalla modificada

    inc acertos
    inc tiros   
    jmp FIM_FS

  MISS:
    mov bh,coluna
    mov al,2
    mul bh                                      ;multiplica por 2 para encontrar el equivalente "grafico"
    add al,4                                    ;Suma con columna inicial
    mov bh,02                                   ;pagina atual 
    mov dh,linea
    add dh,7
    mov dl,al
    call posicionacursor
    call drawmiss                               ;dibuja el fallo
    ;Matriz de pantalla modificada

    inc tiros 
                                                ;incremento tiros hasta 18
  FIM_FS:
    ret
endp  

configboardcomputer proc                        ;crea el tablero como computador
                                                ;"Colocando los barcos del computador."
    mov bh,2
    mov dh,19
    mov dl,COLUNA_CONFIG+1
    call posicionacursor
    mov DX, OFFSET MSG_CONFIG21
    call printstring
    
    mov bh,2
    mov dh,20
    mov dl,COLUNA_CONFIG+1
    call posicionacursor
    mov DX, OFFSET MSG_CONFIG22
    call printstring
   
    ;Ubicacion del portaviones
  CPU_PORTA_AVIONES:
    mov ubicando_portaviones, 1
    mov ubicando_destructor, 0
    mov ubicando_submarino, 0   
    call RNG ;"input" del computador
    mov bx, endereco_lin_col
    mov tamanobarco, 5
    mov SI, OFFSET matriz_navios_comp 
    call verificanavio
    cmp BX,100                      ;si es 100, la posicion no es valida
    jne CPU_AVALIDO
    jmp CPU_PORTA_AVIONES
  CPU_AVALIDO:
    call addbarco                   ;agregar el barco al vector de barcos

  CPU_NAVIO_GUERRA:
    mov ubicando_portaviones, 0
    mov ubicando_destructor, 1
    mov ubicando_submarino, 0  
    call RNG ;"input" del computador
    mov bx, endereco_lin_col
    mov tamanobarco, 3
    call verificanavio
    cmp BX,100                      ;si es 100, la posicion no es valida
    jne CPU_BVALIDO
    jmp CPU_NAVIO_GUERRA
  CPU_BVALIDO:
    call addbarco ;agregar el barco al vector de barcos

  CPU_SUBMARINO:
    mov ubicando_portaviones, 0
    mov ubicando_destructor, 0
    mov ubicando_submarino, 1   
    call RNG ;"input" del computador
    mov bx, endereco_lin_col
    mov tamanobarco, 3
    call verificanavio
    cmp BX,100  ;si es 100, la posicion no es valida
    jne CPU_SVALIDO
    jmp CPU_SUBMARINO
  CPU_SVALIDO:
    call addbarco ;agregar el barco al vector de barcos
 
    ret
endp                        

disenobarco proc                        ;proc poner barcos en pantalla
   
    add linea,7                         ;convertir de ascii a decimal y agregar 7 de la l?nea de inicio
    mov bh,coluna
    mov al,2
    mul bh                              ;multiplica por 2 para tener el equivalente "grafico"
    add al,33                           ;suma con columna inicial
    mov coluna,al

    ;posicionamento cursor                                                                         
    mov dh,linea 
    mov dl,coluna
  LOOPDISENO:  
    mov bh,2
    call posicionacursor
    
    mov al, simbolo
    mov bh,2 ; pagina
    mov bl,0Fh  ;el color blanco
    call drawsymbol 
    
    ;incremento
    cmp sentido, 'h'
    je DHORIZONTAL
    inc dh                              ;si es vertical, s? Incrementar fila y columna permanecen iguales
    loop LOOPDISENO
    jmp FINDISENO
  DHORIZONTAL:
    add dl,2                            ;si es dos, se incrementa 1 porque una columna ocupa 2 espacios
    loop LOOPDISENO 
    jmp FINDISENO
  FINDISENO:
    ret
endp
 
verifyshot proc                         ;comprueba el tiro
    mov bx,0                            ;limite es 18 tiros
    mov cx,18
    mov SI,OFFSET tiros_repetidos       ;puntero al arreglo de tiros
    mov ax,endereco_lin_col             ;carga pos del tiro en AX
  VERIFICAR_DUPLICADO:                  ;VERIFICA LOS DUPLICADOS
    cmp byte ptr [SI+BX],al             ;SI ESTA DUPLICADO, SALTA
    je TIRO_DUPLO
    inc bx
    loop VERIFICAR_DUPLICADO            ;SIGUE VERIFICANDO
    
    mov ax,endereco_lin_col             ;GUARDA LA POSICION DEL TIRO PARA LUEGO ALMACENARLO COMO REPETIDO
    mov bh,0
    mov bl,tiros
    mov SI,OFFSET tiros_repetidos       ;PUNTERO A TIROS REP
    mov byte ptr [SI+BX],al             ;ALMACENA EN TIROS REP
    
    mov bx,endereco_lin_col             ;AQUI VERIFCA A QUE LE GOLPEO
    mov SI,OFFSET matriz_navios_comp
    cmp byte ptr [SI+BX], 'P'
    je GOLPEO_PORTAVIONES
    cmp byte ptr [SI+BX], 'D'
    je GOLPEO_DESTRUCTOR
    cmp byte ptr [SI+BX], 'S'
    je GOLPEO_SUBMARINO        
    
    call missedshot
    mov bx,0                            ;SALE DEL PROCESO
    jmp fimVS
  GOLPEO_PORTAVIONES:
    call hitshot
    mov bx,'P'                          ;LLAMA A FUNCION PARA DECIR QUE FUE ACIERTO
    jmp fimVS
  GOLPEO_DESTRUCTOR:
    call hitshot
    mov bx,'D'                          ;LLAMA A FUNCION PARA DECIR QUE FUE ACIERTO
    jmp fimVS
  GOLPEO_SUBMARINO:
    call hitshot
    mov bx,'S'                          ;LLAMA A FUNCION PARA DECIR QUE FUE ACIERTO
    jmp fimVS
  TIRO_DUPLO:
    call doublehit
    mov bx,2                            ;LLAMA A FUNCION PARA DECIR QUE FUE ACIERTO
  fimVS:
    ret
endp
 
yourturn proc
    push_all
  LER_OUTRO_INPUT:  
    mov bh,02
    mov dh,22                           ;COLUMNA PARA MSJS
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    push dx
    mov DX, OFFSET MSG_LIMPA_MSG        ;Limpa el espacio para los mensajes
    call printstring

    pop dx
    call posicionacursor
    mov DX, OFFSET MSG_TURNO1           ;PIDE INPIUT
    call printstring                    ;IMPRIME

    mov dh,22                           ;LINEA PARA COORDENADAS
    mov dl,COLUNA_COORDENADAS           ;LINEA PARA COLUMNA
    call posicionacursor
    mov DX, OFFSET MSG_LIMPA_COOR       ;Limpia el espacio de coordenadas
    call printstring
    mov dh,22
    mov dl,COLUNA_COORDENADAS
    call posicionacursor
    mov columnas_mayus[0], 'A'
    mov columnas_mayus[1], 'B'
    mov columnas_mayus[2], 'C'
    mov columnas_mayus[3], 'D'
    mov columnas_mayus[4], 'E'
    mov columnas_mayus[5], 'F'
    mov columnas_minus[0], 'a'
    mov columnas_minus[1], 'b'
    mov columnas_minus[2], 'c'
    mov columnas_minus[3], 'd'
    mov columnas_minus[4], 'e'
    mov columnas_minus[5], 'f'   
    
    call readinputaction                ;lee el input
    call verifyshot                     ;Verifica el contenido
    cmp bx,2
    je LER_OUTRO_INPUT
    call fireshot                       ;REALIZA EL TIRO
    cmp bx,0                            ;compara para saber si el resultado es verificado
    jne ATIRAR  
    jmp LER_OUTRO_INPUT    
    
  ATIRAR:                               ;COMPARA QUE GOLPEO
    cmp bl, 'P'
    je INCREMENTAR_CONTADOR_P
    cmp bl, 'D'
    je INCREMENTAR_CONTADOR_D
    cmp bl, 'S'
    je INCREMENTAR_CONTADOR_S    
  INCREMENTAR_CONTADOR_P:
    inc tamano_p
    jmp STATS
  INCREMENTAR_CONTADOR_D:
    inc tamano_d
    jmp STATS
  INCREMENTAR_CONTADOR_S:
    inc tamano_s
  STATS:
    call actualizarstats                 ;Actualiza el cuadro de stats
    pop_all
    ret
endp
    
readinitgame proc                   ; lee la entrada ENTER para jugar S - SALIR
    push ax
  LECTURAJUEGO:
    call readkeyboard
    cmp al, CR                      ; verifica el ENTER
    je INICIARJUEGO
    cmp al, 's'
    je SALIRJUEGO
    cmp al, 'S'
    je SALIRJUEGO
    jmp LECTURAJUEGO
  SALIRJUEGO:
    call exit

  INICIARJUEGO:
    pop ax
    ret
endp

game_screen proc                 ;Disena pag principal
    mov ubicando_portaviones, 0
    mov ubicando_destructor, 0
    mov ubicando_submarino, 0
    push_all 
    mov al, 2
    mov PAGCURSOR, al
    call changepage
    ;Disena la matriz de tiros
    mov BL, 3 ; linea inicial
    mov BH,PAGCURSOR
    mov DL,COLUNA_TIRO

    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO1   ;COMIENZA A IMPRIMIR LAS LINEAS DE MATRIZ  
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO2     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO3     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO4     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO6     
    call printstring
    pop DX  
    inc BL  
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO7     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO8     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO9     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO10     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO11     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGJUEGOTIRO15     
    call printstring
    pop DX  
    inc BL
     
    ;MATRIZ LISTA
    
    mov CX,36
    mov DH, 7                           ;La posicion 0.0 de la primera fila tiene la fila 7 y la columna 4
    mov DL,COLUNA_TIRO+3
  DISENAMATRIZTIRO:  
    call posicionacursor
    call DISENACUADRADO    
    cmp DL,14                           ;22 es la ultima posicion de cada linea, si pasa, pasa a la siguiente linea
    je LINEANUEVA
    add DL,2                            ;incrementa columna
  PULOQUADRADO:
    loop DISENAMATRIZTIRO
    jmp FINMATRIZTIRO  ;salta cuando hayas terminado
  LINEANUEVA:
    mov DL,COLUNA_TIRO+3
    inc DH
    jmp PULOQUADRADO
    
  FINMATRIZTIRO:
    ;Matriz de disparo completo, termine de dibujar la pantalla
    mov BL,3 ; Linha inicial
    ;mov DL,COLUNA_STATS 
    
    
    mov DH,BL    
    call posicionacursor 
    push DX
    ;mov DX,OFFSET MSGSTAT2                          
    call printstring
    pop DX  
    inc BL
    
    
    call actualizarstats                       ;ACTUALIZA LOS TIROS
    
    ;Limpar el cuadro de mensajes
    mov BL, 18 ; Linea Inicial
    mov DL,COLUNA_CONFIG
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_LIMPA_MSG                    ;LIMPIA TODO
    call printstring
    pop DX 
    inc BL 
    
    mov DL,COLUNA_CONFIG
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_LIMPA_MSG    
    call printstring
    pop DX  
    inc BL                                          
    
    mov DL,COLUNA_CONFIG
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_LIMPA_MSG    
    call printstring
    pop DX  
    inc BL 
               
    
    mov DL,COLUNA_TIRO
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGINPUT1                    ;MUESTRA LAS ESTADISTICAS
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSGINPUT2     
    call printstring
    pop DX  
    inc BL      
    
    pop_all
    ret
endp
 
start_screen proc                            ;PANTALLA PRINCIPAL
    push_all
    
    mov AH,02h ;posiciona el cursor
    mov DL,CLINICIAL
    mov DH,8
    int 10h 
    mov DX,OFFSET MSGINICIO1     
    mov ah,09h
    int 21h        
    
    mov AH,02h ;posiciona el cursor
    mov DL,CLINICIAL
    mov DH,10
    int 10h 
    mov DX,OFFSET MSGINICIO3     
    mov ah,09h
    int 21h
    
    pop_all
    ret
endp  

mostrar_barcos proc                   ;COMIENZA MOSTRANDO LOS BORDES
    mov ah,02h
    mov dl,32                          ;IMPRIME CARACTERES A-F
    int 21h
    int 21h
    mov dl,'A'
    int 21h
    mov dl,32
    int 21h
    mov dl,'B'
    int 21h
    mov dl,32
    int 21h
    mov dl,'C'
    int 21h
    mov dl,32
    int 21h
    mov dl,'D'
    int 21h
    mov dl,32
    int 21h
    mov dl,'E'
    int 21h
    mov dl,32
    int 21h
    mov dl,'F'
    int 21h
    mov dl,10                        ;SALTO DE LINEA Y RETORNO DE CARRO
    int 21h
    mov dl,13      
    int 21h
    
    mov di,0
    mov si,0
    
    mov bl, '1'
  NUMEROFILA:                        ;BUCLE PARA IMPRIMIR EL NUMERO DE FILA          
    mov dl,bl
    int 21h
    mov cx,6                         ;INICIALIZA CONTADOR DE CELDAS
       
  CELDAS:                            ;imprimE CELDAS
    mov dl,32
    int 21h
    mov dl,matriz_navios_comp[si]     ;MUESTRA EL CONTENIDO EN EL INDICE SI DE LA MATRIZ BARCSO
    int 21h
    inc si
    loop CELDAS                       ;REPETIR HASTA QUE SE IMPRIMA TODO
    mov dl,10
    int 21h
    mov dl,13      
    int 21h
    inc bl          
    inc di      
    cmp di,6                         ;IR AL INICIO SI AUN QUEDAN FILAS
    jl  NUMEROFILA
  ret
endp   

finalscreen proc                    ;DISENA PANTALLA FINAL 
    mov al,3
    call changepage
    mov bh,al
                    
    
    mov AH,02h                      ;posiciona el cursor
    mov DL,COLUNA_FINAL             ;POSICION DEL CURSOR
    mov DH,11                       ;FILA TAMBIEN DEL CURSOR
    int 10h                         ;INTERRUPCION PARA UBICAR CURSOR
    mov DX,OFFSET MSGFINAL1     
    mov ah,09h
    int 21h
    
    mov AH,02h 
    mov DL,COLUNA_FINAL
    mov DH,12
    int 10h 
    mov DX,OFFSET MSGFINAL2     
    mov ah,09h
    int 21h
    
    mov AH,02h                      ;MUESTRA LOS MENSAJES DE PANTALLA FINAL
    mov DL,COLUNA_FINAL
    mov DH,13
    int 10h 
    mov DX,OFFSET MSGFINAL3     
    mov ah,09h
    int 21h
             
    mov ah,02h                     ;MUESTRA LA MATRIZ ORIGINAL Y LAS UBICACIONES
    mov dx,10
    int 21h
    mov dx,13
    int 21h
    call mostrar_barcos           
    ret
    
    ret
endp        

start proc                          ;PROCEDIMIENTO INIDICAL
    call definemode                  ;DEFINIMOS MODO DE VIDEO
    call start_screen                ; llama al proc para escribir la pantalla de bienvenida y elegir si jugar o salir

  
  JUGARDENUEVO:
	xor AX, AX                 
	mov DI, OFFSET matriz_navios_comp    
	mov cx, 50                 
	rep stosw                        ;REPETIR HASTA Q 100 PALABRAS SE INICIALICEN CON 0
    call configboardcomputer        ; llamar a proc para preparar la placa de la computadora
    call game_screen                ;COMIENZA A LLAMARSE OTROS METODOS PARA INICIAR
GAMESTART:
    call yourturn                     ;GENERA TURNO DE USUARIO
    cmp tiros, 18                     ;LIMITE DE TIROS
    je USUPERDIO
       
    cmp acertos,11 ;5+3+3 = 11       ;11 aciertos gana    
    je USERGANO
    jmp GAMESTART
    
    
USERGANO:                            ;SI GANA SE MUESTRA PANTALLA DE victoria
    call victorymsg
    jmp FINALSCREEN2
   
USUPERDIO:                           ;SI PIERDE LE LLEVA A LA PANTALLA DE PERDEDOR Y LE MUESTRA LA
    call defeatmsg
    jmp FINALSCREEN2 
FINALSCREEN2:
    call finalscreen
    jmp LECTURAFINAL
    
PAGFINAL:                            ;PANTALLA FINAL
    call finalscreen
LECTURAFINAL:                        ;MUESTRA OPCIONES DE ESA PANTALLA
    call readkeyboard
    cmp al, 'j'
    je JUGARDENUEVO  
    cmp al, 'J'
    je M_JUGAR
    cmp al, 's'
    je SALIRJUEGO2
    cmp al, 'S'
    je S_SALIR
    jmp LECTURAFINAL
      
   M_JUGAR:                          ;REPLAY
    jmp JUGARDENUEVO
    
   S_SALIR:                          ;EXIT DE LA APP
    jmp SALIRJUEGO2 
   

    
    
  SALIRJUEGO2:                      ;CERRAR
    call exit

ret
endp
      
exit proc                           ; SALIR DEL JUEGI 'S'
    mov ax, 41h
    int 21h ;DOS interrupts.
ret
endp 

inicio:
    mov ax,@data                    ; ax apunta al segmento de datos
    mov ds,ax                       ; copia para ds
    mov es,ax                       ; copia para es tambem

    call start                       
end inicio