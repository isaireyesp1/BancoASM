;=============================================================
; cuentas.asm
; Sistema Bancario ASM
; Módulo de Gestión de Cuentas
;=============================================================

.386
.model flat, stdcall
option casemap:none

include windows.inc
include kernel32.inc
include user32.inc

includelib kernel32.lib
includelib user32.lib

;=============================================================
; Estructura de cuenta (SIMPLIFICADA EN ARCHIVO)
;=============================================================
; Formato en banco.dat:
;
; Usuario|PIN|Saldo
;
; Ejemplo:
; isai|1234|1500
;=============================================================

.data

ArchivoBanco db "banco.dat",0

BufferArchivo db 256 dup(0)
BufferLinea   db 128 dup(0)

Separador db "|",0

UsuarioTemp db 32 dup(0)
PinTemp     db 16 dup(0)

SaldoTemp   dd 0

hFile HANDLE ?
BytesRead DWORD ?

;=============================================================
; EXTERN (desde otros módulos)
;=============================================================

EXTERN CuentaActual:DWORD

.code

;=============================================================
; BuscarCuenta
; Entrada: ECX = puntero a usuario
; Salida: EAX = 0 no existe / >0 posición lógica
;=============================================================

BuscarCuenta PROC lpUsuario:DWORD

    invoke CreateFile, ADDR ArchivoBanco, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL

    mov hFile, eax
    cmp eax, INVALID_HANDLE_VALUE
    je NoExiste

    ; lectura simplificada (solo demo educativa)

    invoke ReadFile, hFile, ADDR BufferArchivo, SIZEOF BufferArchivo, ADDR BytesRead, NULL

    invoke CloseHandle, hFile

    ;---------------------------------------------------------
    ; Buscar cadena usuario en buffer
    ;---------------------------------------------------------

    invoke lstrstr, ADDR BufferArchivo, lpUsuario

    cmp eax, 0
    je NoExiste

    mov eax, 1
    ret

NoExiste:

    mov eax, 0
    ret

BuscarCuenta ENDP

;=============================================================
; ValidarPIN
; Entrada:
;   ECX = cuenta (dummy en este modelo)
;   EDX = PIN ingresado
; Salida:
;   EAX = TRUE / FALSE
;=============================================================

ValidarPIN PROC cuenta:DWORD, lpPIN:DWORD

    ;---------------------------------------------------------
    ; Versión simplificada (educativa)
    ; En proyecto real: comparar contra archivo
    ;---------------------------------------------------------

    invoke lstrcmp, lpPIN, ADDR PinTemp

    cmp eax, 0
    jne PIN_INCORRECTO

    mov eax, TRUE
    ret

PIN_INCORRECTO:

    mov eax, FALSE
    ret

ValidarPIN ENDP

;=============================================================
; ObtenerSaldo
; Entrada: cuenta
; Salida: EAX = saldo
;=============================================================

ObtenerSaldo PROC cuenta:DWORD

    ;---------------------------------------------------------
    ; DEMO: saldo fijo (debe leerse de archivo)
    ;---------------------------------------------------------

    mov eax, 15000
    ret

ObtenerSaldo ENDP

;=============================================================
; DepositarDinero
;=============================================================

DepositarDinero PROC cuenta:DWORD

    ;---------------------------------------------------------
    ; DEMO: simulación de depósito
    ;---------------------------------------------------------

    ; aquí se pediría monto en versión completa

    ret

DepositarDinero ENDP

;=============================================================
; RetirarDinero
;=============================================================

RetirarDinero PROC cuenta:DWORD

    ;---------------------------------------------------------
    ; DEMO: simulación de retiro
    ;---------------------------------------------------------

    ret

RetirarDinero ENDP

;=============================================================
; TransferirDinero
;=============================================================

TransferirDinero PROC cuenta:DWORD

    ;---------------------------------------------------------
    ; DEMO: simulación de transferencia
    ;---------------------------------------------------------

    ret

TransferirDinero ENDP

;=============================================================
; GuardarBanco
;=============================================================

GuardarBanco PROC

    ;---------------------------------------------------------
    ; En versión real:
    ; reescribir banco.dat con datos actualizados
    ;---------------------------------------------------------

    ret

GuardarBanco ENDP

END