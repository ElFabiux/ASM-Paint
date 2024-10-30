.MODEL SMALL
.STACK 100h

.DATA
    POSX DW 80; X position
    POSY DW 90; Y position
    SQUARE_POSX DW 0
    SQUARE_POSY DW 0
    BRUSH_COLOR DB 00H; Color del lápiz (empieza en negro)
    SQUARE_COLOR DB 00H; Color del lápiz (empieza en negro)
    CHAR_BUFFER DB 0

    MIN_X DW 70
    MAX_X DW 470
    MIN_Y DW 80
    MAX_Y DW 315

    FILENAME DB 'drawing.txt', 0
    HEX_OUTPUT DB 0

    POSITION MACRO X, Y
        MOV AH, 02h
        MOV BH, 0
        MOV DH, X
        MOV DL, Y
        INT 10h
    ENDM

    PAINT_PIXEL MACRO X, Y
        MOV AH, 0CH
        MOV AL, BRUSH_COLOR; Usa el color actual del lápiz
        MOV BH, 00
        MOV CX, X
        MOV DX, Y
        INT 10H
    ENDM

    COL DW 50
    FIL DW 50
    TEXTPOS DW 38

.CODE
MAIN PROC FAR
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 00
    MOV AL, 12H
    INT 10H

    CALL CLEAN
    CALL DRAW_BORDER
    CALL DRAW_COLOR_SQUARES
    CALL DETECT_KEY_EVENT

    MOV AX, 4C00H
    INT 21H
MAIN ENDP

DRAW_BORDER PROC
    MOV BRUSH_COLOR, 00H   ; Color negro para el borde

    ; Línea superior de (69, 79) a (471, 79)
    MOV CX, 69
TOP_BORDER:
    PAINT_PIXEL CX, 79
    INC CX
    CMP CX, 471
    JBE TOP_BORDER

    ; Línea derecha de (471, 79) a (471, 316)
    MOV DX, 79
RIGHT_BORDER:
    PAINT_PIXEL 471, DX
    INC DX
    CMP DX, 316
    JBE RIGHT_BORDER

    ; Línea inferior de (69, 316) a (471, 316)
    MOV CX, 69
BOTTOM_BORDER:
    PAINT_PIXEL CX, 316
    INC CX
    CMP CX, 471
    JBE BOTTOM_BORDER

    ; Línea izquierda de (69, 79) a (69, 316)
    MOV DX, 79
LEFT_BORDER:
    PAINT_PIXEL 69, DX
    INC DX
    CMP DX, 316
    JBE LEFT_BORDER

    RET
DRAW_BORDER ENDP

DRAW_COLOR_SQUARES PROC

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 10
    MOV SQUARE_COLOR, 00H
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 35
    MOV SQUARE_COLOR, 0CH
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 60
    MOV SQUARE_COLOR, 09H
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 85
    MOV SQUARE_COLOR, 0EH
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 110
    MOV SQUARE_COLOR, 0AH
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 135
    MOV SQUARE_COLOR, 05H
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 160
    MOV SQUARE_COLOR, 06H
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 185
    MOV SQUARE_COLOR, 0DH
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 210
    MOV SQUARE_COLOR, 03H
    CALL DRAW_SQUARE

    MOV SQUARE_POSX, 610
    MOV SQUARE_POSY, 235
    MOV SQUARE_COLOR, 08H
    CALL DRAW_SQUARE

    RET
DRAW_COLOR_SQUARES ENDP

DRAW_SQUARE PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, SQUARE_POSX; Cargar la posición X del cuadrado
    MOV DX, SQUARE_POSY; Cargar la posición Y del cuadrado

    MOV BX, 20; Ancho y alto del cuadrado

    DRAW_ROW:
        PUSH CX; Guardar la posición X inicial de la fila
        MOV SI, 20; Número de columnas a dibujar (ancho del cuadrado)

    DRAW_PIXEL:
        MOV AH, 0CH; Función de interrupción para dibujar píxel (modo gráfico)
        MOV AL, SQUARE_COLOR; Establecer el color (rojo 0CH)
        INT 10H; Llamar a la interrupción de video

        INC CX; Avanzar al siguiente píxel en la fila
        DEC SI; Decrementar el contador de columnas
        JNZ DRAW_PIXEL; Continuar dibujando la fila

        POP CX; Restaurar la posición X inicial de la fila
        INC DX; Mover a la siguiente fila
        DEC BX; Decrementar el número de filas restantes
        JNZ DRAW_ROW; Continuar dibujando filas

    POP DX
    POP CX
    POP BX
    POP AX
    RET
DRAW_SQUARE ENDP

DETECT_KEY_EVENT PROC
READ_KEYBOARD:
    MOV AH, 00h; Leer tecla presionada
    INT 16h; Llamada a la interrupción del teclado

    CMP AL, 00h; Verificar si la tecla es extendida (flechas)
    JE CALL_MOVE_BRUSH_EVENT

    CMP AL, 6Ch; Comparar con la tecla 'l'
    JE CALL_CLEAR_SCREEN

    CMP AL, 65h; Comparar con la tecla 'e'
    JE CALL_EXPORT_DRAWING

    CMP AL, 69h; Comparar con la tecla 'i'
    JE CALL_IMPORT_DRAWING

    ; Llamar a los eventos de cambio de color y mouse
    CALL CHANGE_COLOR_EVENT
    CALL MOUSE_CLICK_EVENT

    JMP READ_KEYBOARD; Seguir leyendo teclas

CALL_MOVE_BRUSH_EVENT:
    CALL MOVE_BRUSH_EVENT
    JMP READ_KEYBOARD

CALL_CLEAR_SCREEN:
    CALL CLEAR_SCREEN
    JMP READ_KEYBOARD

CALL_EXPORT_DRAWING:
    CALL EXPORT_DRAWING
    JMP READ_KEYBOARD

CALL_IMPORT_DRAWING:
    CALL IMPORT_DRAWING
    JMP READ_KEYBOARD

    RET
DETECT_KEY_EVENT ENDP

CLEAR_SCREEN PROC
    MOV AX, 0600h
    MOV BH, 0Fh; Color de fondo (blanco)
    MOV CX, 0000h; Esquina superior izquierda
    MOV DX, 184Fh; Esquina inferior derecha (pantalla completa)
    INT 10h; Interrupcion de video
    CALL CLEAN
    CALL DRAW_BORDER
    CALL DRAW_COLOR_SQUARES
    JMP DETECT_KEY_EVENT
CLEAR_SCREEN ENDP

MOVE_BRUSH_EVENT PROC
    CMP AH, 48h; Flecha hacia arriba
    JE CALL_UP

    CMP AH, 50h; Flecha hacia abajo
    JE CALL_DOWN

    CMP AH, 4Bh; Flecha hacia la izquierda
    JE CALL_LEFT

    CMP AH, 4Dh; Flecha hacia la derecha
    JE CALL_RIGHT

    JMP DETECT_KEY_EVENT; Si no es ninguna flecha, volver a leer el teclado

CALL_UP:
    CALL MOVE_UP
    JMP DETECT_KEY_EVENT

CALL_DOWN:
    CALL MOVE_DOWN
    JMP DETECT_KEY_EVENT

CALL_LEFT:
    CALL MOVE_LEFT
    JMP DETECT_KEY_EVENT

CALL_RIGHT:
    CALL MOVE_RIGHT
    JMP DETECT_KEY_EVENT
MOVE_BRUSH_EVENT ENDP

IMPORT_DRAWING PROC
    MOV AH, 3Dh             ; Función DOS para abrir archivo
    MOV AL, 0               ; Modo de solo lectura
    LEA DX, FILENAME        ; Nombre del archivo a leer
    INT 21h                 ; Interrupción DOS para abrir el archivo
    MOV BX, AX              ; Manejador de archivo en BX

    ; Inicializar posición de dibujo
    MOV SI, MIN_Y           ; Comenzar en la posición Y inicial
    MOV DI, MIN_X           ; Comenzar en la posición X inicial

READ_PIXEL:
    ; Leer un carácter del archivo
    MOV AH, 3Fh             ; Función DOS para leer archivo
    MOV CX, 1               ; Leer 1 byte
    LEA DX, CHAR_BUFFER     ; Buffer para guardar el carácter leído
    INT 21h                 ; Interrupción DOS para leer

    ; Comprobar fin del archivo (si retorna 0 bytes)
    CMP AX, 0
    JE END_READ

    ; Comprobar si el carácter es '%'
    CMP CHAR_BUFFER, 25h   
    JE END_READ             ; Si es '%', fin del dibujo

    ; Comprobar si el carácter es '@'
    CMP CHAR_BUFFER, 40h
    JE NEW_ROW              ; Si es '@', ir a la siguiente fila

    ; Convertir el carácter leído en un valor de color
    MOV AL, CHAR_BUFFER
    CALL CHAR_TO_COLOR      ; Convierte el carácter en color y lo coloca en BRUSH_COLOR

    ; Pintar el píxel con el color determinado
    MOV AH, 0Ch             ; Función para dibujar píxel
    MOV AL, BRUSH_COLOR     ; Color actual del pincel
    MOV CX, DI              ; Coordenada X (columna)
    MOV DX, SI              ; Coordenada Y (fila)
    INT 10h                 ; Llamada a la interrupción para dibujar el píxel

    ; Avanzar al siguiente píxel en la fila
    INC DI
    CMP DI, MAX_X
    JBE READ_PIXEL          ; Continuar en la fila si no se excede el límite

NEW_ROW:
    ; Si se encuentra '@', significa el final de la fila
    MOV DI, MIN_X           ; Reiniciar X a la posición inicial de la fila
    INC SI                  ; Avanzar a la siguiente fila (incrementa Y)
    CMP SI, MAX_Y
    JBE READ_PIXEL          ; Continuar si no se excede el límite de filas

END_READ:
    ; Cerrar el archivo
    MOV AH, 3Eh             ; Función DOS para cerrar archivo
    MOV BX, BX              ; Manejador de archivo
    INT 21h
    JMP DETECT_KEY_EVENT
IMPORT_DRAWING ENDP


CHAR_TO_COLOR PROC
    ; Convierte un carácter en el color correspondiente (0-F)
    CMP AL, '0'
    JB INVALID_CHAR
    CMP AL, '9'
    JBE VALID_DIGIT
    CMP AL, 'A'
    JB INVALID_CHAR
    CMP AL, 'F'
    JA INVALID_CHAR

    ; Convertir letra de A a F a valor 10 a 15
    SUB AL, 'A' - 10
    JMP SET_COLOR

VALID_DIGIT:
    ; Convertir dígito de '0' a '9' a su valor numérico
    SUB AL, '0'

SET_COLOR:
    MOV BRUSH_COLOR, AL; Guardar el color en BRUSH_COLOR
    RET

INVALID_CHAR:
    MOV BRUSH_COLOR, 0; Si el carácter es inválido, usar color negro
    RET
CHAR_TO_COLOR ENDP

EXPORT_DRAWING PROC
    MOV AH, 3Ch; Llamada para crear archivo
    MOV CX, 0; Sin atributos especiales
    LEA DX, FILENAME; Nombre del archivo de exportación
    INT 21h
    MOV BX, AX; BX tendrá el manejador de archivo

    MOV SI, MIN_Y; Empezar en la posición Y inicial (fila)
NEXT_ROW:
    MOV DI, MIN_X; Empezar en la posición X inicial (columna)
    MOV BP, 400; Cada fila tiene 400 píxeles

NEXT_PIXEL:
    ; Leer el color del píxel
    MOV AH, 0Dh; Función para leer el color del píxel
    MOV CX, DI; Coordenada X en CX
    MOV DX, SI; Coordenada Y en DX
    INT 10h; Llamada a la interrupción para leer el píxel
    ; AL contiene el color del píxel

    ; Convertir el color del píxel a carácter hexadecimal
    MOV CL, AL; Guardar el color en CL para convertirlo
    CALL CONVERT_TO_HEX; Convertir CL a su representación ASCII

    ; Escribir el carácter en el archivo
    MOV AH, 40h; Función DOS para escribir en archivo
    MOV CX, 1; Escribir 1 byte
    MOV DX, OFFSET HEX_OUTPUT ; Dirección del carácter a escribir
    INT 21h

    ; Avanzar al siguiente píxel en la fila
    INC DI
    DEC BP; Decrementar el contador de píxeles
    JNZ NEXT_PIXEL; Repetir hasta completar 400 píxeles en la fila

    ; Fin de la fila, escribir '@' y salto de línea
    MOV HEX_OUTPUT, '@'; Guardar '@' en HEX_OUTPUT
    MOV AH, 40h; Función DOS para escribir en archivo
    MOV CX, 1
    MOV DX, OFFSET HEX_OUTPUT
    INT 21h

    ; Escribir salto de línea
    MOV HEX_OUTPUT, 0Ah; Carácter de salto de línea
    MOV AH, 40h
    MOV CX, 1
    MOV DX, OFFSET HEX_OUTPUT
    INT 21h

    ; Avanzar a la siguiente fila
    INC SI; Incrementa la fila (posición Y)
    CMP SI, MAX_Y
    JBE NEXT_ROW

    ; Fin de la matriz, escribir '%'
    MOV HEX_OUTPUT, '%'; Guardar '%' en HEX_OUTPUT
    MOV AH, 40h; Función DOS para escribir en archivo
    MOV CX, 1
    MOV DX, OFFSET HEX_OUTPUT
    INT 21h

    ; Cerrar el archivo
    MOV AH, 3Eh; Función DOS para cerrar archivo
    MOV BX, BX; Manejador de archivo
    INT 21h

    JMP DETECT_KEY_EVENT; Regresar al evento de teclado
EXPORT_DRAWING ENDP

CONVERT_TO_HEX PROC
    ; Convierte el valor en CL a su representación hexadecimal en ASCII
    MOV AL, CL
    AND AL, 0Fh
    CMP AL, 9
    JBE HEX_NUM
    ADD AL, 7
HEX_NUM:
    ADD AL, '0'
    MOV HEX_OUTPUT, AL; Guardar el carácter en HEX_OUTPUT
    RET
CONVERT_TO_HEX ENDP

CLEAN PROC
    MOV AX, 0700h 
    MOV BH, 0Fh; Primer dígito es el color de fondo / segundo dígito es el color del texto
    MOV CX, 0h
    MOV DX, 1F4fh
    INT 10h
    RET
CLEAN ENDP

MOUSE_CLICK_EVENT PROC
    MOV AX, 0003h; Llama a la interrupción 33h para obtener el estado del mouse
    INT 33h; Llama a la interrupción del mouse

    TEST BX, 0001h; Verifica si el botón izquierdo está presionado (primer bit de BX)
    JZ NO_CLICK; Si no está presionado, salta a NO_CLICK

    ; Guardar la posición X del mouse
    MOV POSX, CX; Almacena la posición X en POSX

    ; Guardar la posición Y del mouse
    MOV POSY, DX; Almacena la posición Y en POSY

    ; Actualiza la posición del pincel
    PAINT_PIXEL POSX, POSY ; Dibuja en la nueva posición con el color actual del pincel

NO_CLICK:
    JMP DETECT_KEY_EVENT
MOUSE_CLICK_EVENT ENDP

MOVE_UP PROC
    CMP POSY, 80D
    JLE END_UP; Si está en el límite superior, no se mueve
    ADD POSY, -1
    PAINT_PIXEL POSX, POSY
END_UP:
    RET
MOVE_UP ENDP

MOVE_DOWN PROC
    CMP POSY, 315D
    JGE END_DOWN; Si está en el límite inferior, no se mueve
    ADD POSY, 1
    PAINT_PIXEL POSX, POSY
END_DOWN:
    RET
MOVE_DOWN ENDP

MOVE_LEFT PROC
    CMP POSX, 70D
    JLE END_LEFT; Si está en el límite izquierdo, no se mueve
    ADD POSX, -1
    PAINT_PIXEL POSX, POSY
END_LEFT:
    RET
MOVE_LEFT ENDP

MOVE_RIGHT PROC
    CMP POSX, 470D
    JGE END_RIGHT; Si está en el límite derecho, no se mueve
    ADD POSX, 1
    PAINT_PIXEL POSX, POSY
END_RIGHT:
    RET
MOVE_RIGHT ENDP

CHANGE_COLOR_EVENT PROC
    CMP AL, 31h; Numero 1
    JE CHANGE_BLACK

    CMP AL, 32h; Numero 2
    JE CHANGE_RED

    CMP AL, 33h; Numero 3
    JE CHANGE_BLUE

    CMP AL, 34h; Numero 4
    JE CHANGE_YELLOW

    CMP AL, 35h; Numero 5
    JE CHANGE_GREEN

    CMP AL, 36h; Numero 6
    JE CHANGE_PURPLE

    CMP AL, 37h; Numero 7
    JE CHANGE_BROWN

    CMP AL, 38h; Numero 8
    JE CHANGE_PINK

    CMP AL, 39h; Numero 9
    JE CHANGE_CYAN

    CMP AL, 30h; Numero 0
    JE CHANGE_GRAY

    JMP DETECT_KEY_EVENT; Seguir leyendo si no es la tecla deseada

CHANGE_BLACK:
    MOV BRUSH_COLOR, 00H; Color del lapiz a negro
    JMP DETECT_KEY_EVENT

CHANGE_RED:
    MOV BRUSH_COLOR, 0CH; Color del lapiz a rojo
    JMP DETECT_KEY_EVENT

CHANGE_BLUE:
    MOV BRUSH_COLOR, 09H; Color del lapiz a azul
    JMP DETECT_KEY_EVENT

CHANGE_YELLOW:
    MOV BRUSH_COLOR, 0EH; Color del lapiz a amarillo
    JMP DETECT_KEY_EVENT

CHANGE_GREEN:
    MOV BRUSH_COLOR, 0AH; Color del lapiz a verde
    JMP DETECT_KEY_EVENT

CHANGE_PURPLE:
    MOV BRUSH_COLOR, 05H; Color del lapiz a purpura
    JMP DETECT_KEY_EVENT

CHANGE_BROWN:
    MOV BRUSH_COLOR, 06H; Color del lapiz a marron
    JMP DETECT_KEY_EVENT

CHANGE_PINK:
    MOV BRUSH_COLOR, 0DH; Color del lapiz a rosado
    JMP DETECT_KEY_EVENT

CHANGE_CYAN:
    MOV BRUSH_COLOR, 03H; Color del lapiz a cian
    JMP DETECT_KEY_EVENT

CHANGE_GRAY:
    MOV BRUSH_COLOR, 08H; Color del lapiz a gris
    JMP DETECT_KEY_EVENT
CHANGE_COLOR_EVENT ENDP

END MAIN
