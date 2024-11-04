.MODEL SMALL
.STACK 100h

.DATA
POSX DW 80; X position
    POSY DW 90; Y position
    MOUSEX DW 0
    MOUSEY DW 0

    BUTTON_X1 DW 0
    BUTTON_Y1 DW 0
    BUTTON_X2 DW 0
    BUTTON_Y2 DW 0

    INPUT_X1 DW 0
    INPUT_Y1 DW 0
    INPUT_X2 DW 0
    INPUT_Y2 DW 0

    SQUARE_POSX DW 0
    SQUARE_POSY DW 0
    BRUSH_COLOR DB 00H; Color del lápiz (empieza en negro)
    SQUARE_COLOR DB 00H; Color del lápiz (empieza en negro)
    CHAR_BUFFER DB 0

    MIN_X DW 70
    MAX_X DW 470
    MIN_Y DW 80
    MAX_Y DW 315

    CLEAN_MSG DB 'LIMPIAR [q]', '$'
    EXPORT_MSG DB 'EXPORTAR [w]', '$'
    IMPORT_MSG DB 'IMPORTAR [e]', '$'
    IMG_MSG DB 'IMAGEN  [r]', '$'
    COLORS_MSG DB 'COLORES', '$'
    COLOR1_MSG DB '[1]>', '$'
    COLOR2_MSG DB '[2]>', '$'
    COLOR3_MSG DB '[3]>', '$'
    COLOR4_MSG DB '[4]>', '$'
    COLOR5_MSG DB '[5]>', '$'
    COLOR6_MSG DB '[6]>', '$'
    COLOR7_MSG DB '[7]>', '$'
    COLOR8_MSG DB '[8]>', '$'
    COLOR9_MSG DB '[9]>', '$'
    COLOR0_MSG DB '[0]>', '$'
    
    FILENAME DB 'test.txt', 0; Nombre base del archivo (cambiará según el input)
    FILEPATH DB 20 DUP(0); Buffer para almacenar FILENAME con la extensión .txt
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
        MOV AL, BRUSH_COLOR
        MOV BH, 00
        MOV CX, X
        MOV DX, Y
        INT 10H
    ENDM

    TEXT_POS MACRO X, Y
        MOV AH, 02H
        MOV BH, 00
        MOV DH, X
        MOV DL, Y
        INT 10H
    ENDM

    PRINT_TEXT MACRO MSG, X, Y
        TEXT_POS X, Y
        LEA DX, MSG
        MOV AH, 9H
        INT 21H
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
    CALL DRAW_AREA_BORDER
    CALL SET_BUTTON_COORDINATES
    CALL SET_INPUT_COORDINATES
    CALL DRAW_COLOR_SQUARES
    CALL PRINT_ALL_MSG
    ;CALL DRAW_EXPORT_LETTERS
    CALL DETECT_KEY_EVENT

    MOV AX, 4C00H
    INT 21H
MAIN ENDP

DRAW_AREA_BORDER PROC
    MOV BRUSH_COLOR, 00H; Color negro para el borde

    ; Línea superior de (69, 79) a (471, 79)
    MOV CX, 69
TOP_BORDER_AR:
    PAINT_PIXEL CX, 79
    INC CX
    CMP CX, 471
    JBE TOP_BORDER_AR

    ; Línea derecha de (471, 79) a (471, 316)
    MOV DX, 79
RIGHT_BORDER_AR:
    PAINT_PIXEL 471, DX
    INC DX
    CMP DX, 316
    JBE RIGHT_BORDER_AR

    ; Línea inferior de (69, 316) a (471, 316)
    MOV CX, 69
BOTTOM_BORDER_AR:
    PAINT_PIXEL CX, 316
    INC CX
    CMP CX, 471
    JBE BOTTOM_BORDER_AR

    ; Línea izquierda de (69, 79) a (69, 316)
    MOV DX, 79
LEFT_BORDER_AR:
    PAINT_PIXEL 69, DX
    INC DX
    CMP DX, 316
    JBE LEFT_BORDER_AR

    RET
DRAW_AREA_BORDER ENDP

SET_BUTTON_COORDINATES PROC
    ; Configuración del botón de limpiar (Clean)
    MOV BUTTON_X1, 370
    MOV BUTTON_Y1, 45
    MOV BUTTON_X2, 471
    MOV BUTTON_Y2, 66
    CALL DRAW_BUTTON_BORDER

    ; Configuración del botón de exportar (Export)
    MOV BUTTON_X1, 69
    MOV BUTTON_Y1, 397
    MOV BUTTON_X2, 170
    MOV BUTTON_Y2, 418
    CALL DRAW_BUTTON_BORDER

    ; Configuración del botón de importar (Import)
    MOV BUTTON_X1, 181
    MOV BUTTON_Y1, 397
    MOV BUTTON_X2, 282
    MOV BUTTON_Y2, 418
    CALL DRAW_BUTTON_BORDER

    ; Configuración del botón de imagen (Image)
    MOV BUTTON_X1, 370
    MOV BUTTON_Y1, 397
    MOV BUTTON_X2, 471
    MOV BUTTON_Y2, 418
    CALL DRAW_BUTTON_BORDER

    ; Configuración del panel de colores (Colors)
    MOV BUTTON_X1, 491
    MOV BUTTON_Y1, 45
    MOV BUTTON_X2, 580
    MOV BUTTON_Y2, 420
    CALL DRAW_BUTTON_BORDER

    RET
SET_BUTTON_COORDINATES ENDP

DRAW_BUTTON_BORDER PROC
    MOV BRUSH_COLOR, 00H; Color negro para el borde

    ; Línea superior de (BUTTON_X1, BUTTON_Y1) a (BUTTON_X2, BUTTON_Y1)
    MOV CX, BUTTON_X1
TOP_BORDER_BTN:
    PAINT_PIXEL CX, BUTTON_Y1
    INC CX
    CMP CX, BUTTON_X2
    JBE TOP_BORDER_BTN

    ; Línea derecha de (BUTTON_X2, BUTTON_Y1) a (BUTTON_X2, BUTTON_Y2)
    MOV DX, BUTTON_Y1
RIGHT_BORDER_BTN:
    PAINT_PIXEL BUTTON_X2, DX
    INC DX
    CMP DX, BUTTON_Y2
    JBE RIGHT_BORDER_BTN

    ; Línea inferior de (BUTTON_X1, BUTTON_Y2) a (BUTTON_X2, BUTTON_Y2)
    MOV CX, BUTTON_X1
BOTTOM_BORDER_BTN:
    PAINT_PIXEL CX, BUTTON_Y2
    INC CX
    CMP CX, BUTTON_X2
    JBE BOTTOM_BORDER_BTN

    ; Línea izquierda de (BUTTON_X1, BUTTON_Y1) a (BUTTON_X1, BUTTON_Y2)
    MOV DX, BUTTON_Y1
LEFT_BORDER_BTN:
    PAINT_PIXEL BUTTON_X1, DX
    INC DX
    CMP DX, BUTTON_Y2
    JBE LEFT_BORDER_BTN

    RET
DRAW_BUTTON_BORDER ENDP

; Procedimiento para configurar las coordenadas de cada entrada y llamar a DRAW_INPUT_BORDER
SET_INPUT_COORDINATES PROC
    ; Configuración para el borde de la entrada de nombre de texto (TXT Name)
    MOV INPUT_X1, 285
    MOV INPUT_Y1, 340
    MOV INPUT_X2, 471
    MOV INPUT_Y2, 370
    CALL DRAW_INPUT_BORDER

    RET
SET_INPUT_COORDINATES ENDP

DRAW_INPUT_BORDER PROC
    MOV BRUSH_COLOR, 00H  ; Color negro para el borde

    ; Línea superior de (INPUT_X1, INPUT_Y1) a (INPUT_X2, INPUT_Y1)
    MOV CX, INPUT_X1
TOP_BORDER_INP:
    PAINT_PIXEL CX, INPUT_Y1
    INC CX
    CMP CX, INPUT_X2
    JBE TOP_BORDER_INP

    ; Línea derecha de (INPUT_X2, INPUT_Y1) a (INPUT_X2, INPUT_Y2)
    MOV DX, INPUT_Y1
RIGHT_BORDER_INP:
    PAINT_PIXEL INPUT_X2, DX
    INC DX
    CMP DX, INPUT_Y2
    JBE RIGHT_BORDER_INP

    ; Línea inferior de (INPUT_X1, INPUT_Y2) a (INPUT_X2, INPUT_Y2)
    MOV CX, INPUT_X1
BOTTOM_BORDER_INP:
    PAINT_PIXEL CX, INPUT_Y2
    INC CX
    CMP CX, INPUT_X2
    JBE BOTTOM_BORDER_INP

    ; Línea izquierda de (INPUT_X1, INPUT_Y1) a (INPUT_X1, INPUT_Y2)
    MOV DX, INPUT_Y1
LEFT_BORDER_INP:
    PAINT_PIXEL INPUT_X1, DX
    INC DX
    CMP DX, INPUT_Y2
    JBE LEFT_BORDER_INP

    RET
DRAW_INPUT_BORDER ENDP

DRAW_COLOR_SQUARES PROC

    MOV SQUARE_POSX, 540

    MOV SQUARE_POSY, 50
    MOV SQUARE_COLOR, 00H
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 89
    MOV SQUARE_COLOR, 0CH
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 128
    MOV SQUARE_COLOR, 09H
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 162
    MOV SQUARE_COLOR, 0EH
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 201
    MOV SQUARE_COLOR, 0AH
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 240
    MOV SQUARE_COLOR, 05H
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 274
    MOV SQUARE_COLOR, 06H
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 313
    MOV SQUARE_COLOR, 0DH
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 352
    MOV SQUARE_COLOR, 03H
    CALL DRAW_SQUARE

    MOV SQUARE_POSY, 386
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

    MOV BX, 30; Ancho y alto del cuadrado

    DRAW_ROW:
        PUSH CX; Guardar la posición X inicial de la fila
        MOV SI, 30; Número de columnas a dibujar (ancho del cuadrado)

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

PRINT_ALL_MSG PROC
    PRINT_TEXT CLEAN_MSG, 3, 47
    PRINT_TEXT EXPORT_MSG, 25, 9
    PRINT_TEXT IMPORT_MSG, 25, 23
    PRINT_TEXT IMG_MSG, 25, 47
    PRINT_TEXT COLORS_MSG, 2, 62
    PRINT_TEXT COLOR1_MSG, 4, 63
    PRINT_TEXT COLOR2_MSG, 6, 63
    PRINT_TEXT COLOR3_MSG, 8, 63
    PRINT_TEXT COLOR4_MSG, 11, 63
    PRINT_TEXT COLOR5_MSG, 13, 63
    PRINT_TEXT COLOR6_MSG, 15, 63
    PRINT_TEXT COLOR7_MSG, 18, 63
    PRINT_TEXT COLOR8_MSG, 20, 63
    PRINT_TEXT COLOR9_MSG, 22, 63
    PRINT_TEXT COLOR0_MSG, 25, 63
    RET
PRINT_ALL_MSG ENDP

DETECT_KEY_EVENT PROC
READ_KEYBOARD:
    MOV AH, 00h; Leer tecla presionada
    INT 16h; Llamada a la interrupción del teclado

    CMP AL, 00h; Verificar si la tecla es extendida (flechas)
    JE CALL_MOVE_BRUSH_EVENT

    CMP AL, 71h; Comparar con la tecla 'q'
    JE CALL_CLEAR_SCREEN

    CMP AL, 77h; Comparar con la tecla 'w'
    JE CALL_EXPORT_DRAWING

    CMP AL, 65h; Comparar con la tecla 'e'
    JE CALL_IMPORT_DRAWING

    CMP AL, 61h; Comparar con la tecla 'a'
    JE CALL_GET

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

CALL_GET:
    CALL GET_FILENAME
    JMP READ_KEYBOARD

    RET
DETECT_KEY_EVENT ENDP

GET_FILENAME PROC
        MOV CX, 0                        ; Inicializar contador de caracteres leídos
        MOV BX, OFFSET FILENAME          ; Puntero al inicio del buffer del nombre del archivo
        MOV DH, 22                       ; Configurar la fila inicial
        MOV DL, 37                       ; Configurar la columna inicial

    read_loop:
        ; Mover el cursor a la posición deseada
        MOV AH, 02h                      ; Función de BIOS para mover el cursor
        MOV BH, 0                        ; Página de pantalla 0
        INT 10h                          ; Interrupción de video

        MOV AH, 0                        ; Llamar a la BIOS para obtener el carácter
        INT 16h                          ; Interrupción 16h, función 0 - Leer carácter del teclado
        CMP AL, 0Dh                      ; Verificar si se presionó Enter (código ASCII 0Dh)
        JE end_input                     ; Si es Enter, terminar la entrada

        ; Mostrar el carácter en pantalla en modo texto con color blanco sobre fondo negro
        MOV AH, 09h                      ; Función para mostrar con atributo
        MOV BH, 0                        ; Página de pantalla 0
        MOV BL, 0Fh                      ; Atributo: blanco sobre fondo negro
        MOV CX, 1                        ; Número de veces a mostrar el carácter
        INT 10h                          ; Interrupción 10h para salida en video

        ; Guardar el carácter en el buffer
        MOV [BX], AL                     ; Almacenar el carácter en filename
        INC BX                           ; Avanzar a la siguiente posición en el buffer
        INC CX                           ; Incrementar el contador de caracteres

        ; Avanzar la posición en pantalla
        INC DL                           ; Mover la columna para el siguiente carácter
        CMP DL, 79                       ; Limitar la columna a 79 (última columna)
        JBE read_loop                    ; Si no se supera, continuar leyendo caracteres
        MOV DL, 10                       ; Reiniciar columna a startX si se supera el límite
        INC DH                           ; Avanzar a la siguiente fila

        CMP CX, 20                       ; Comparar con el tamaño máximo del buffer
        JB read_loop                     ; Si no se ha alcanzado, repetir el bucle

    end_input:
        MOV BYTE PTR [BX], 0             ; Terminar la cadena con un nulo (0)
        RET
GET_FILENAME ENDP


CLEAR_SCREEN PROC
    MOV AX, 0600h
    MOV BH, 0Fh; Color de fondo (blanco)
    MOV CX, 0000h; Esquina superior izquierda
    MOV DX, 184Fh; Esquina inferior derecha (pantalla completa)
    INT 10h; Interrupcion de video
    CALL CLEAN
    CALL DRAW_AREA_BORDER
    CALL SET_BUTTON_COORDINATES
    CALL SET_INPUT_COORDINATES
    CALL DRAW_COLOR_SQUARES
    CALL PRINT_ALL_MSG
    ;CALL DRAW_EXPORT_LETTERS
    CALL DRAW_COLOR_SQUARES
    RET
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

    RET; Si no es ninguna flecha, volver a leer el teclado

CALL_UP:
    CALL MOVE_UP
    RET

CALL_DOWN:
    CALL MOVE_DOWN
    RET

CALL_LEFT:
    CALL MOVE_LEFT
    RET

CALL_RIGHT:
    CALL MOVE_RIGHT
    RET
MOVE_BRUSH_EVENT ENDP

; Procedimiento principal para importar el dibujo
IMPORT_DRAWING PROC
    CALL CHECK_FILEPATH; Verificar si FILEPATH está vacío
    JE NO_FILEPATH                    ; Si está vacío, no hacer nada

    CALL OPEN_FILE_READ_MODE; Intentar abrir el archivo en modo lectura
    JC FILE_ERROR_I; Si hay error, saltar a FILE_ERROR_I

    CALL READ_PIXELS_FROM_FILE; Leer los datos del archivo y procesarlos
    CALL CLOSE_FILE_I; Cerrar el archivo después de leer

    JMP DETECT_KEY_EVENT; Volver al ciclo principal

NO_FILEPATH:
    RET; No hacer nada si FILEPATH está vacío

FILE_ERROR_I:
    RET
IMPORT_DRAWING ENDP

; Verifica si FILEPATH está vacío
CHECK_FILEPATH PROC
    MOV AL, FILENAME
    CMP AL, 0
    RET
CHECK_FILEPATH ENDP

; Abre el archivo especificado en FILEPATH en modo lectura
OPEN_FILE_READ_MODE PROC
    MOV AH, 3Dh; Función para abrir archivo
    MOV AL, 0; Modo de lectura
    LEA DX, FILENAME; Dirección de FILEPATH
    INT 21h; Interrupción para abrir el archivo
    MOV BX, AX; Guardar el manejador de archivo en BX
    RET
OPEN_FILE_READ_MODE ENDP

; Lee los datos de los píxeles desde el archivo y los dibuja
READ_PIXELS_FROM_FILE PROC
    ; Establecer posición inicial de dibujo
    MOV SI, MIN_Y; POSY inicial (esquina superior izquierda)
    MOV DI, MIN_X; POSX inicial (esquina superior izquierda)

READ_NEXT_BYTE:
    MOV AH, 3Fh; Función para leer del archivo
    MOV CX, 1; Leer 1 byte
    LEA DX, CHAR_BUFFER; Dirección de CHAR_BUFFER
    INT 21h; Interrupción para leer el byte
    JC CLOSE_FILE_I; Si hay error, cierra el archivo
    OR AX, AX; Si AX es 0, es EOF
    JZ CLOSE_FILE_I

    ; Procesar el carácter leído en CHAR_BUFFER
    MOV AL, CHAR_BUFFER
    CMP AL, '@'; Fin de fila
    JE NEW_ROW; Saltar a la nueva fila si es '@'
    CMP AL, '%'; Fin de la matriz
    JE END_IMPORT; Finalizar si se encuentra '%'

    CALL CHAR_TO_COLOR; Convertir el carácter a color en BRUSH_COLOR
    CALL DRAW_PIXEL_IF_VALID; Dibujar píxel si está dentro de los límites

    ; Avanzar al siguiente píxel en la fila
    INC DI
    JMP READ_NEXT_BYTE

NEW_ROW:
    ; Avanzar a la siguiente fila
    MOV DI, MIN_X; Reiniciar POSX al inicio de la fila
    INC SI; Mover a la siguiente posición en Y
    JMP READ_NEXT_BYTE

END_IMPORT:
    RET
READ_PIXELS_FROM_FILE ENDP

; Verifica si la posición está dentro de los límites y dibuja el píxel
DRAW_PIXEL_IF_VALID PROC
    ; Verificar si la posición actual DI, SI está dentro de los límites de MIN_X, MAX_X, MIN_Y, MAX_Y
    CMP DI, MIN_X
    JB SKIP_PIXEL
    CMP DI, MAX_X
    JA SKIP_PIXEL
    CMP SI, MIN_Y
    JB SKIP_PIXEL
    CMP SI, MAX_Y
    JA SKIP_PIXEL

    ; Si está dentro de los límites, dibuja el píxel en la posición actual
    PAINT_PIXEL DI, SI

SKIP_PIXEL:
    RET
DRAW_PIXEL_IF_VALID ENDP

; Cierra el archivo usando el manejador en BX
CLOSE_FILE_I PROC
    MOV AH, 3Eh; Función para cerrar archivo
    INT 21h
    RET
CLOSE_FILE_I ENDP

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

; Procedimiento principal para exportar el dibujo
EXPORT_DRAWING PROC
    CALL CHECK_FILENAME; Verificar si FILENAME está vacío
    JE NO_FILENAME; Si está vacío, no hacer nada

    CALL CREATE_FILEPATH; Crear FILEPATH con .txt al final
    CALL OPEN_FILE; Intentar abrir el archivo
    JC FILE_ERROR_E; Si hay error, saltar a FILE_ERROR_E

    CALL WRITE_PIXELS_TO_FILE; Escribir los datos de los píxeles en el archivo
    CALL CLOSE_FILE_E; Cerrar el archivo

    JMP DETECT_KEY_EVENT; Volver al ciclo principal

NO_FILENAME:
    RET; No hacer nada si FILENAME está vacío

FILE_ERROR_E:
    RET
EXPORT_DRAWING ENDP

; Verifica si FILENAME está vacío
CHECK_FILENAME PROC
    MOV AL, FILENAME
    CMP AL, 0
    RET
CHECK_FILENAME ENDP

; Copia FILENAME a FILEPATH y agrega la extensión ".txt"
CREATE_FILEPATH PROC
    LEA SI, FILENAME; Dirección de FILENAME en SI
    LEA DI, FILEPATH; Dirección de FILEPATH en DI

COPY_LOOP:
    MOV AL, [SI]; Cargar el byte de FILENAME
    CMP AL, 0
    JE ADD_EXTENSION; Si llegamos al final, saltar para agregar ".txt"
    MOV [DI], AL; Copiar el byte en FILEPATH
    INC SI
    INC DI
    JMP COPY_LOOP

ADD_EXTENSION:
    MOV BYTE PTR [DI], '.'; Agregar '.'
    INC DI
    MOV BYTE PTR [DI], 't'; Agregar 't'
    INC DI
    MOV BYTE PTR [DI], 'x'; Agregar 'x'
    INC DI
    MOV BYTE PTR [DI], 't'; Agregar 't'
    INC DI
    MOV BYTE PTR [DI], 0; Agregar terminador de cadena
    RET
CREATE_FILEPATH ENDP

; Intenta abrir el archivo especificado en FILEPATH
OPEN_FILE PROC
    MOV AH, 3Ch ; Función para crear archivo
    MOV CX, 0 ; Sin atributos especiales
    LEA DX, FILEPATH; Dirección de FILEPATH
    INT 21h
    MOV BX, AX; Guardar el manejador de archivo en BX
    RET
OPEN_FILE ENDP

; Escribe los datos de los píxeles en el archivo
WRITE_PIXELS_TO_FILE PROC
    MOV SI, MIN_Y; Empezar en la posición Y inicial (fila)
NEXT_ROW:
    MOV DI, MIN_X; Empezar en la posición X inicial (columna)
    MOV BP, 400; Cada fila tiene 400 píxeles

NEXT_PIXEL:
    MOV AH, 0Dh; Función para leer el color del píxel
    MOV CX, DI; Coordenada X en CX
    MOV DX, SI; Coordenada Y en DX
    INT 10h; Llamada a la interrupción para leer el píxel

    MOV CL, AL; Guardar el color en CL para convertirlo
    CALL CONVERT_TO_HEX; Convertir CL a su representación ASCII

    MOV AH, 40h; Función DOS para escribir en archivo
    MOV CX, 1; Escribir 1 byte
    MOV DX, OFFSET HEX_OUTPUT; Dirección del carácter a escribir
    INT 21h

    INC DI
    DEC BP
    JNZ NEXT_PIXEL

    CALL WRITE_NEWLINE; Escribir nueva línea entre filas
    INC SI
    CMP SI, MAX_Y
    JBE NEXT_ROW

    CALL WRITE_END_MARKER; Escribir el marcador de fin
    RET
WRITE_PIXELS_TO_FILE ENDP

; Escribe una nueva línea en el archivo
WRITE_NEWLINE PROC
    MOV HEX_OUTPUT, '@'
    MOV AH, 40h
    MOV CX, 1
    MOV DX, OFFSET HEX_OUTPUT
    INT 21h

    MOV HEX_OUTPUT, 0Ah
    MOV AH, 40h
    MOV CX, 1
    MOV DX, OFFSET HEX_OUTPUT
    INT 21h
    RET
WRITE_NEWLINE ENDP

; Escribe el marcador de fin de archivo '%'
WRITE_END_MARKER PROC
    MOV HEX_OUTPUT, '%'
    MOV AH, 40h
    MOV CX, 1
    MOV DX, OFFSET HEX_OUTPUT
    INT 21h
    RET
WRITE_END_MARKER ENDP

; Cierra el archivo usando el manejador en BX
CLOSE_FILE_E PROC
    MOV AH, 3Eh
    INT 21h
    RET
CLOSE_FILE_E ENDP

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
;........................................................................
DETECT_CLICK_ON_CLEAN_BUTTON PROC

    RET
DETECT_CLICK_ON_CLEAN_BUTTON ENDP

MOUSE_CLICK_EVENT PROC
    ;MOV AX, 0003h; Llama a la interrupción 33h para obtener el estado del mouse
    ;INT 33h; Llama a la interrupción del mouse

    ;TEST BX, 0001h; Verifica si el botón izquierdo está presionado (primer bit de BX)
    ;JZ NO_CLICK; Si no está presionado, salta a NO_CLICK

    ; Guardar la posición X del mouse
    ;MOV POSX, CX; Almacena la posición X en POSX

    ; Guardar la posición Y del mouse
    ;MOV POSY, DX; Almacena la posición Y en POSY

    ; Verifica si el clic está dentro del botón de limpiar
    CALL DETECT_CLICK_ON_CLEAN_BUTTON

    ; Actualiza la posición del pincel
    ;PAINT_PIXEL POSX, POSY ; Dibuja en la nueva posición con el color actual del pincel

;NO_CLICK:
    RET
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

    RET; Seguir leyendo si no es la tecla deseada

CHANGE_BLACK:
    MOV BRUSH_COLOR, 00H; Color del lapiz a negro
    RET

CHANGE_RED:
    MOV BRUSH_COLOR, 0CH; Color del lapiz a rojo
    RET

CHANGE_BLUE:
    MOV BRUSH_COLOR, 09H; Color del lapiz a azul
    RET

CHANGE_YELLOW:
    MOV BRUSH_COLOR, 0EH; Color del lapiz a amarillo
    RET

CHANGE_GREEN:
    MOV BRUSH_COLOR, 0AH; Color del lapiz a verde
    RET

CHANGE_PURPLE:
    MOV BRUSH_COLOR, 05H; Color del lapiz a purpura
    RET

CHANGE_BROWN:
    MOV BRUSH_COLOR, 06H; Color del lapiz a marron
    RET

CHANGE_PINK:
    MOV BRUSH_COLOR, 0DH; Color del lapiz a rosado
    RET

CHANGE_CYAN:
    MOV BRUSH_COLOR, 03H; Color del lapiz a cian
    RET

CHANGE_GRAY:
    MOV BRUSH_COLOR, 08H; Color del lapiz a gris
    RET
CHANGE_COLOR_EVENT ENDP

END MAIN