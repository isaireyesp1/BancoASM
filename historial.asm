;=============================================================
; historial.asm
; Sistema Bancario ASM
; Módulo de Historial de Movimientos
; MASM32 + Win32 API
;=============================================================


.386
.model flat, stdcall
option casemap:none


;=============================================================
; Librerías
;=============================================================

include windows.inc
include kernel32.inc
include user32.inc

includelib kernel32.lib
includelib user32.lib



;=============================================================
; Funciones externas
;=============================================================

EXTERN ObtenerUsuario:PROC
EXTERN NumeroACadena:PROC



;=============================================================
; Constantes
;=============================================================

MAX_HISTORIAL EQU 256



;=============================================================
; IDs Dialogo
;=============================================================

IDC_LISTA       EQU 3001
IDC_CERRAR      EQU 3002



;=============================================================
; Datos
;=============================================================

.data


ArchivoHistorial db "historial.dat",0


Separador db "|",0

CRLF db 13,10,0


MovimientoDeposito db "DEPOSITO",0

MovimientoRetiro db "RETIRO",0

MovimientoTransferencia db "TRANSFERENCIA",0


BufferHistorial db 512 dup(0)

BufferMonto db 32 dup(0)

BufferUsuario db 32 dup(0)



MsgError db "No se pudo abrir el historial.",0

TituloHistorial db "Historial Bancario",0



;=============================================================
; Variables
;=============================================================

.data?


hArchivo HANDLE ?

BytesLeidos DWORD ?

BytesEscritos DWORD ?

hHistorial HWND ?



;=============================================================
; Código
;=============================================================

.code



;=============================================================
; GuardarMovimiento
;
; Guarda:
; usuario|tipo|monto
;
; Entrada:
; lpTipo  = movimiento
; monto   = cantidad
;=============================================================


GuardarMovimiento PROC lpTipo:DWORD, monto:DWORD



    ;---------------------------------------------------------
    ; Abrir archivo al final
    ;---------------------------------------------------------


    invoke CreateFile,\
            ADDR ArchivoHistorial,\
            GENERIC_WRITE,\
            FILE_SHARE_READ,\
            NULL,\
            OPEN_ALWAYS,\
            FILE_ATTRIBUTE_NORMAL,\
            NULL


    mov hArchivo,eax


    cmp eax,INVALID_HANDLE_VALUE

    je ErrorGuardar



    ;---------------------------------------------------------
    ; Ir al final
    ;---------------------------------------------------------


    invoke SetFilePointer,\
            hArchivo,\
            0,\
            NULL,\
            FILE_END



    ;---------------------------------------------------------
    ; Obtener usuario actual
    ;---------------------------------------------------------


    invoke ObtenerUsuario


    invoke lstrcpy,\
            ADDR BufferHistorial,\
            eax



    invoke lstrcat,\
            ADDR BufferHistorial,\
            ADDR Separador



    invoke lstrcat,\
            ADDR BufferHistorial,\
            lpTipo



    invoke lstrcat,\
            ADDR BufferHistorial,\
            ADDR Separador



    invoke NumeroACadena,\
            monto,\
            ADDR BufferMonto



    invoke lstrcat,\
            ADDR BufferHistorial,\
            ADDR BufferMonto



    invoke lstrcat,\
            ADDR BufferHistorial,\
            ADDR CRLF



    ;---------------------------------------------------------
    ; Escribir registro
    ;---------------------------------------------------------


    invoke lstrlen,\
            ADDR BufferHistorial


    invoke WriteFile,\
            hArchivo,\
            ADDR BufferHistorial,\
            eax,\
            ADDR BytesEscritos,\
            NULL



    invoke CloseHandle,\
            hArchivo


    mov eax,TRUE
    ret



ErrorGuardar:


    mov eax,FALSE
    ret



GuardarMovimiento ENDP





;=============================================================
; MostrarHistorial
; Lee historial.dat
;=============================================================


MostrarHistorial PROC hWnd:HWND



    invoke CreateFile,\
            ADDR ArchivoHistorial,\
            GENERIC_READ,\
            FILE_SHARE_READ,\
            NULL,\
            OPEN_EXISTING,\
            FILE_ATTRIBUTE_NORMAL,\
            NULL



    mov hArchivo,eax



    cmp eax,INVALID_HANDLE_VALUE

    je HistorialError



    invoke ReadFile,\
            hArchivo,\
            ADDR BufferHistorial,\
            SIZEOF BufferHistorial,\
            ADDR BytesLeidos,\
            NULL



    invoke CloseHandle,\
            hArchivo



    invoke SetDlgItemText,\
            hWnd,\
            IDC_LISTA,\
            ADDR BufferHistorial



    mov eax,TRUE
    ret



HistorialError:


    invoke MessageBox,\
            hWnd,\
            ADDR MsgError,\
            ADDR TituloHistorial,\
            MB_OK or MB_ICONERROR



    mov eax,FALSE
    ret


MostrarHistorial ENDP





;=============================================================
; Dialogo Historial
;=============================================================


HistorialProc PROC hWnd:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM


    mov eax,uMsg



    .IF eax==WM_INITDIALOG


        mov hHistorial,hWnd


        invoke MostrarHistorial,\
                hWnd



        mov eax,TRUE
        ret



    .ELSEIF eax==WM_COMMAND



        mov eax,wParam

        and eax,0FFFFh



        .IF eax==IDC_CERRAR


            invoke EndDialog,\
                    hWnd,\
                    TRUE


        .ENDIF



    .ELSEIF eax==WM_CLOSE



        invoke EndDialog,\
                hWnd,\
                FALSE


    .ENDIF



    mov eax,FALSE

    ret


HistorialProc ENDP



END