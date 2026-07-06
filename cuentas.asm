;=============================================================
; cuentas.asm
; Sistema Bancario ASM
; Módulo de Gestión de Cuentas
; MASM32 + Win32 API
; Parte 1 de 14
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
; Prototipos
;=============================================================

BuscarCuenta      PROTO :DWORD
ValidarPIN        PROTO :DWORD,:DWORD
ObtenerSaldo      PROTO :DWORD
DepositarDinero   PROTO :DWORD,:DWORD
RetirarDinero     PROTO :DWORD,:DWORD
TransferirDinero  PROTO :DWORD,:DWORD,:DWORD
CrearCuenta       PROTO :DWORD,:DWORD,:DWORD
GuardarBanco      PROTO
CargarBanco       PROTO

AbrirArchivo      PROTO
CerrarArchivo     PROTO

CopiarCadena      PROTO :DWORD,:DWORD
CompararCadena    PROTO :DWORD,:DWORD
LongitudCadena    PROTO :DWORD

NumeroACadena     PROTO :DWORD,:DWORD
CadenaANumero     PROTO :DWORD

;=============================================================
; Constantes
;=============================================================

MAX_USUARIO EQU 32
MAX_PIN     EQU 16
MAX_LINEA   EQU 128
MAX_BUFFER  EQU 8192

;=============================================================
; Estructura de Cuenta
;=============================================================

CUENTA STRUCT

    Usuario    db MAX_USUARIO dup(0)
    PIN        db MAX_PIN dup(0)
    Saldo      dd ?

CUENTA ENDS

;=============================================================
; Variables Inicializadas
;=============================================================

.data

ArchivoBanco db "banco.dat",0

Separador db "|",0

CRLF db 13,10,0

CadenaVacia db 0

;=============================================================
; Buffers
;=============================================================

BufferArchivo db MAX_BUFFER dup(0)

BufferLinea db MAX_LINEA dup(0)

BufferUsuario db MAX_USUARIO dup(0)

BufferPIN db MAX_PIN dup(0)

BufferNumero db 32 dup(0)

;=============================================================
; Variables Globales
;=============================================================

CuentaActual CUENTA <>

IndiceCuenta DWORD 0

SaldoTemporal DWORD 0

BytesLeidos DWORD 0

BytesEscritos DWORD 0

PosicionActual DWORD 0

TamArchivo DWORD 0

hArchivo HANDLE ?

;=============================================================
; Variables sin inicializar
;=============================================================

.data?

CuentaDestino CUENTA ?

CuentaOrigen CUENTA ?

;=============================================================
; Código
;=============================================================

.code

