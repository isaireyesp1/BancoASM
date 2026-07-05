;=============================================================
; menu.asm
; Sistema Bancario ASM
; Módulo del Menú Principal
; Autor: Isai Reyes Peña
;=============================================================

.386
.model flat, stdcall
option casemap:none

;=============================================================
; Librerías
;=============================================================

include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc

includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib

include recursos.inc

;=============================================================
; Funciones externas
;=============================================================

EXTERN ObtenerSaldo:PROC
EXTERN DepositarDinero:PROC
EXTERN RetirarDinero:PROC
EXTERN TransferirDinero:PROC
EXTERN MostrarHistorial:PROC
EXTERN GuardarBanco:PROC

;=============================================================
; Variables Inicializadas
;=============================================================

.data

TituloMenu db "Sistema Bancario",0

MsgCerrar db "¿Desea cerrar la sesión?",0

TituloCerrar db "Cerrar Sesión",0

TextoSaldo db "Saldo Actual: $",0

FormatoSaldo db "%u",0

CadenaVacia db 0

;=============================================================
; Variables No Inicializadas
;=============================================================

.data?

hMenu HWND ?

SaldoActual DWORD ?

BufferSaldo db 32 dup(?)

CuentaActual DWORD ?

.code


;=============================================================
; Procedimiento principal del menú
;=============================================================

MenuProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

    ;---------------------------------------------------------
    ; Guardar handle de la ventana
    ;---------------------------------------------------------

    mov eax, hWnd
    mov hMenu, eax

    ;---------------------------------------------------------
    ; Evaluar mensaje
    ;---------------------------------------------------------

    mov eax, uMsg

    .IF eax == WM_INITDIALOG

        ;---------------------------------------------
        ; Inicializar ventana del menú
        ;---------------------------------------------

        invoke SetWindowText, hWnd, ADDR TituloMenu

        ; Aquí se actualizará el saldo en Parte 3

        mov eax, TRUE
        ret

    .ELSEIF eax == WM_COMMAND

        ;---------------------------------------------
        ; Obtener ID del botón presionado
        ;---------------------------------------------

        mov eax, wParam
        and eax, 0FFFFh

        ;=================================================
        ; CONSULTAR SALDO
        ;=================================================

        .IF eax == IDC_CONSULTAR

            ; Se implementa en Parte 4

        ;=================================================
        ; DEPOSITAR
        ;=================================================

        .ELSEIF eax == IDC_DEPOSITAR

            ; Se implementa en Parte 5

        ;=================================================
        ; RETIRAR
        ;=================================================

        .ELSEIF eax == IDC_RETIRAR

            ; Se implementa en Parte 6

        ;=================================================
        ; TRANSFERIR
        ;=================================================

        .ELSEIF eax == IDC_TRANSFERIR

            ; Se implementa en Parte 7

        ;=================================================
        ; HISTORIAL
        ;=================================================

        .ELSEIF eax == IDC_HISTORIAL

            ; Se implementa en Parte 8

        ;=================================================
        ; CERRAR SESIÓN
        ;=================================================

        .ELSEIF eax == IDC_CERRARSESION

            invoke MessageBox, hWnd, ADDR MsgCerrar, ADDR TituloCerrar, MB_YESNO or MB_ICONQUESTION

            cmp eax, IDYES
            jne FinMenu

            invoke EndDialog, hWnd, 0

        .ENDIF

        mov eax, TRUE
        ret

    .ELSEIF eax == WM_CLOSE

        ;---------------------------------------------
        ; Cerrar ventana desde la X
        ;---------------------------------------------

        invoke MessageBox, hWnd, ADDR MsgCerrar, ADDR TituloCerrar, MB_YESNO or MB_ICONQUESTION

        cmp eax, IDYES
        jne CancelarCierre

        invoke EndDialog, hWnd, 0
        jmp FinMenu

CancelarCierre:

        mov eax, TRUE
        ret

    .ENDIF

    ;---------------------------------------------------------
    ; Mensaje no procesado
    ;---------------------------------------------------------

    mov eax, FALSE
    ret

FinMenu:

    mov eax, TRUE
    ret

MenuProc ENDP