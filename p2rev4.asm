;*************************************************************
; P2 REV 4
;*************************************************************
#include "p16f887.inc"

; VAMOS A MUESTREAR EN AN0, AN1, AN2, AN3 (RA0, RA1, RA2, RA3)
; SI EL VALOR DE MUESTREO ES .10, ENVIAMOS .11 PARA QUE NO LEA UN ENTER


; CONFIG1
; __config 0xFCD4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
 
GPR_VAR     UDATA
DELAY1              RES 1       ;
TEMPORAL            RES 1       ;
W_TEMP              RES 1
STATUS_TEMP         RES 1

RES_VECT    CODE    0x0000      ; processor reset vector
    GOTO    START               ; go to beginning of program

;*******************************************************************************
ISR       CODE    0x0004           ; interrupt vector location
PUSH:
    MOVWF W_TEMP
    SWAPF STATUS,W
    MOVWF STATUS_TEMP
ISR:

POP:
    SWAPF STATUS_TEMP,W
    MOVWF STATUS
    SWAPF W_TEMP,F
    SWAPF W_TEMP,W
    RETFIE
;*******************************************************************************
;-------------------------------PRINCIPAL---------------------------------------
MAIN_PROG CODE                      ; let linker place main program

START
    CALL    CONFIG_OSCILATOR    ; configurar el oscilador a 8MHZ
    CALL    CONFIG_IO           ; (RA0-RA3) COMO ENTRADA ANALOGICA
    CALL    CONFIG_ADC          ; fosc/32, adc on, justificado a la izquierda, Vref interno (0-5V)
    CALL    CONFIG_UART         ; 9600 DE BAUD RATE
    BANKSEL PORTA

    
LOOP

    CALL    CANAL0 
    CALL    MUESTREARYENVIAR    ; SE ENVIA EL PRIMER DATO

    CALL    CANAL1
    CALL    MUESTREARYENVIAR    ; SE ENVIA EL SEGUNDO DATO

    CALL    CANAL2
    CALL    MUESTREARYENVIAR    ; SE ENVIA EL TERCER DATO

    CALL    CANAL3
    CALL    MUESTREARYENVIAR    ; SE ENVIA EL CUARTO DATO
    
    MOVLW   .10                 ; CARACTER DE FIN DE LINEA
    CALL    ENVIARW

;CHECK_RCIF:                     ; RECIBE EN RX Y ACTUALIZA SERVO
;    BTFSS   PIR1, RCIF
;    GOTO    FINALLOOP
;    MOVF    RCREG, W
;    MOVWF   TEMPORAL
;    ;MOVWF   PORTD
;    CALL ACTUALIZARSERVO

;FINALLOOP:
    GOTO    LOOP                          

;------------------------------SUBRUTINAS---------------------------------------
DELAY_500US
    MOVLW   .250            ; 1US 
    MOVWF   DELAY1      
    DECFSZ  DELAY1          ; DECREMENTA CONT1
    GOTO    $-1             ; IR A LA POSICION DEL PC - 1
    RETURN
;----------------------------CONFIGURACIONES----------------------------------    
CONFIG_IO
    BANKSEL TRISA
    CLRF    TRISA
    CLRF    TRISB
    CLRF    TRISC
    CLRF    TRISD
    CLRF    TRISE
    BSF     TRISA, RA0      ; RA0 COMO ENTRADA
    BSF     TRISA, RA1      ; RA1 COMO ENTRADA
    BSF     TRISA, RA2      ; RA2 COMO ENTRADA
    BSF     TRISA, RA3      ; RA3 COMO ENTRADA
    BANKSEL ANSEL
    CLRF    ANSEL
    CLRF    ANSELH
    BSF     ANSEL, ANS0     ; ANS0 COMO ENTRADA ANALÓGICA
    BSF     ANSEL, ANS1     ; ANS0 COMO ENTRADA ANALÓGICA
    BSF     ANSEL, ANS2     ; ANS0 COMO ENTRADA ANALÓGICA
    BSF     ANSEL, ANS3     ; ANS0 COMO ENTRADA ANALÓGICA
    BANKSEL PORTA
    CLRF    PORTA
    CLRF    PORTB
    CLRF    PORTC
    CLRF    PORTD
    RETURN

CONFIG_ADC
    BANKSEL PORTA
    ; ESTAMOS 8MHZ, NECESITAMOS FOSC/32, MUESTREAMOS A 4 MICROSEGUNDOS DE PERIODO 
    BSF ADCON0, ADCS1
    BCF ADCON0, ADCS0       ; FOSC/32 RELOJ TAD
    
    BANKSEL TRISA
    BCF ADCON1, ADFM        ; JUSTIFICACIÓN A LA IZQUIERDA
    BCF ADCON1, VCFG1       ; VSS COMO REFERENCIA VREF-
    BCF ADCON1, VCFG0       ; VDD COMO REFERENCIA VREF+
    BANKSEL PORTA
    BSF ADCON0, ADON        ; ENCIENDO EL MÓDULO ADC
    RETURN

CONFIG_OSCILATOR
    BANKSEL TRISA
    BSF OSCCON, IRCF2
    BSF OSCCON, IRCF1
    BSF OSCCON, IRCF0      ; FRECUENCIA DE 8MHZ
    RETURN

CONFIG_UART
    BANKSEL TXSTA
    BCF TXSTA, SYNC         ; ASINCRÓNO
    BCF TXSTA, BRGH         ; LOW SPEED

    BANKSEL BAUDCTL
    BSF BAUDCTL, BRG16      ; 16 BITS BAURD RATE GENERATOR

    BANKSEL SPBRG           ; MOVEMOS EL N ADECUADO A SPBRG PARA BAUDRATE DE 9600
    MOVLW .51
    MOVWF SPBRG
    CLRF SPBRGH

    BANKSEL RCSTA
    BSF RCSTA, SPEN         ; HABILITAR SERIAL PORT (SYNC YA SE HIZO CERO ANTES)
    BCF RCSTA, RX9          ; SOLO MANEJAREMOS 8BITS DE DATOS
    BSF RCSTA, CREN         ; HABILITAMOS LA RECEPCIÓN
    BANKSEL TXSTA
    BSF TXSTA, TXEN         ; HABILITO LA TRANSMISION (ENVIO)
    
    BCF STATUS, RP0
    BCF STATUS, RP1         ; VUELTA AL BANCO 0
    RETURN


CANAL0
    BCF ADCON0, CHS3
    BCF ADCON0, CHS2
    BCF ADCON0, CHS1
    BCF ADCON0, CHS0            ; SELECCIONAMOS ANS0 PARA MUESTREAR
    RETURN     

CANAL1
    BCF ADCON0, CHS3
    BCF ADCON0, CHS2
    BCF ADCON0, CHS1
    BSF ADCON0, CHS0            ; SELECCIONAMOS ANS1 PARA MUESTREAR
    RETURN

CANAL2
    BCF ADCON0, CHS3
    BCF ADCON0, CHS2
    BSF ADCON0, CHS1
    BCF ADCON0, CHS0            ; SELECCIONAMOS ANS2 PARA MUESTREAR
    RETURN

CANAL3
    BCF ADCON0, CHS3
    BCF ADCON0, CHS2
    BSF ADCON0, CHS1
    BSF ADCON0, CHS0            ; SELECCIONAMOS ANS3 PARA MUESTREAR
    RETURN

MUESTREARYENVIAR
    CALL    DELAY_500US         ; DELAY (SI ES NECESARIO)
    BSF     ADCON0, GO          ; EMPIECE LA CONVERSIÓN
    BTFSC   ADCON0, GO          ; revisa que terminó la conversión
    GOTO    $-1
    BCF     PIR1, ADIF          ; borramos la bandera del adc
    MOVF    ADRESH, W
    SUBLW   .10                 ; VEMOS SI ES 10 PARA NO ENVIARLO
    BTFSC   STATUS, Z           
    MOVLW   .11
    BTFSS   STATUS, Z
    MOVF    ADRESH, W

    CALL    ENVIARW
    RETURN

ENVIARW
    MOVWF   TXREG               ; ENVIAMOS EL VALOR DE LECTURA POR TXREG
    BTFSS   PIR1, TXIF          ; REVISAR SI YA SE ENVIÓ EL NÚMERO, SI YA TERMINO CONTINUA
    GOTO    $-1
    RETURN


;-----------------------FINAL----------------------------------
    END
