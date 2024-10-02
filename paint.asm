.MODEL SMALL
.STACK 100h

.DATA
    TXT DB "Hello", 13, 10, "$"; Byte variable, text
    TXTUP DB "Up", 13, 10, "$"
    TXTDOWN DB "Down", 13, 10, "$"
    TXTLEFT DB "Left", 13, 10, "$"
    TXTRIGHT DB "Right", 13, 10, "$"
    POSX DW 30; X position
    POSY DW 30; Y position
    BRUSH_COLOR DB 00H; Color del lápiz (empieza en negro)

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
    CALL DETECT_KEY_EVENT

    MOV AX, 4C00H
    INT 21H
MAIN ENDP

DETECT_KEY_EVENT PROC
READ_KEYBOARD:
    MOV AH, 00h; Leer tecla presionada
    INT 16h; Llamada a la interrupción del teclado

    CMP AL, 00h; Verificar si la tecla es extendida (flechas)
    JE MOVE_BRUSH_EVENT; Si es una tecla extendida, mover pincel

    CALL CHANGE_COLOR_EVENT; Si no es extendida, cambiar color
    CALL CLEAN_EVENT

    JMP READ_KEYBOARD; Seguir leyendo teclas
    RET
DETECT_KEY_EVENT ENDP

MOVE_BRUSH_EVENT PROC
    CMP AH, 48h; Flecha hacia arriba
    JE UP

    CMP AH, 50h; Flecha hacia abajo
    JE DOWN

    CMP AH, 4Bh; Flecha hacia la izquierda
    JE LEFT

    CMP AH, 4Dh; Flecha hacia la derecha
    JE RIGHT

    JMP DETECT_KEY_EVENT; Si no es ninguna flecha, volver a leer el teclado

UP:
    ADD POSY, -1
    PAINT_PIXEL POSX, POSY
    JMP DETECT_KEY_EVENT

LEFT:
    ADD POSX, -1
    PAINT_PIXEL POSX, POSY
    JMP DETECT_KEY_EVENT

DOWN:
    ADD POSY, 1
    PAINT_PIXEL POSX, POSY
    JMP DETECT_KEY_EVENT

RIGHT:
    ADD POSX, 1
    PAINT_PIXEL POSX, POSY
    JMP DETECT_KEY_EVENT
MOVE_BRUSH_EVENT ENDP

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

CLEAN_EVENT PROC
    CMP AL, 6Ch; Verificar si la tecla presionada es 'l'
    JE CLEAN; Si es 'l', limpiar la pantalla
    RET
CLEAN_EVENT ENDP

CLEAN PROC
    MOV AX, 0700h 
    MOV BH, 0Fh; Primer dígito es el color de fondo / segundo dígito es el color del texto
    MOV CX, 0h
    MOV DX, 1F4fh
    INT 10h
    RET
CLEAN ENDP

END MAIN
