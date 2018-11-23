;*************************************************************
; P2 REV 7
;*************************************************************
#include "p16f887.inc"

; VAMOS A MUESTREAR EN AN0, AN1, AN2, AN3 (RA0, RA1, RA2, RA3)
; SI EL VALOR DE MUESTREO ES .10, ENVIAMOS .11 PARA QUE NO LEA UN ENTER
; VAMOS A HACER LOS 4 PWMS CON TMR0 E INTERRUPCIONES
; VAMOS A USAR OPT1: N = 217, PRESCALRER DE 2; OPT2: N = 236, P = 4
; OPT1

; CONFIG1
; __config 0xFCD4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

;*******************************************************************************
; DEFINICION DE CONSTANTES
;*******************************************************************************
PINSERVO1           EQU 0
PINSERVO2           EQU 1
PINSERVO3           EQU 2
PINSERVO4           EQU 3
;*******************************************************************************
 
GPR_VAR     UDATA
DELAY1              RES 1       ;
TEMPORAL            RES 1       ;
W_TEMP              RES 1
STATUS_TEMP         RES 1
CONT                RES 1
LIM1                RES 1       ; LIMS SON PARA MANEJAR LOS PWMS
LIM2                RES 1
LIM3                RES 1
LIM4                RES 1
MUESTRA1            RES 1
MUESTRA2            RES 1
MUESTRA3            RES 1
MUESTRA4            RES 1
CONT1               RES 1

;*******************************************************************************
; MACROS
;*******************************************************************************

; ESTE MACROS PERMITE QUE SE EJECUTE LO QUE ESTA INMEDIATAMENTE LUEGO DEL MACRO SI LIMITETENT ES MENOR QUE LA FRONTERA
SIESMENOR MACRO FRONTERA, LIMITETENT
    MOVLW FRONTERA
    SUBWF LIMITETENT, W
    BTFSS STATUS, C
ENDM

; ESTE MACROS PERMITE QUE SE EJECUTE LO QUE ESTA INMEDIATAMENTE LUEGO DEL MACRO SI LIMITETENT ES MAYOR QUE LA FRONTERA
SIESMAYOR MACRO FRONTERA1, LIMITETENT1 
    MOVF  LIMITETENT1, W
    SUBLW FRONTERA1 
    BTFSS STATUS, C
ENDM


RES_VECT    CODE    0x0000      ; processor reset vector
    GOTO    START               ; go to beginning of program

;*******************************************************************************
ISR       CODE    0x0004           ; interrupt vector location
PUSH:
    MOVWF W_TEMP
    SWAPF STATUS,W
    MOVWF STATUS_TEMP
ISR:
    BTFSS INTCON, T0IF
    GOTO POP

    BCF INTCON, T0IF       ; BORRAMOS LA BANDERA DE OVERFLOW DE TIMER0
    MOVLW .238
    MOVWF TMR0             ; MOVEMOS EL N NECESARIO

    INCF  CONT, F

    BTFSC STATUS, Z
    CALL  PERIODO

    MOVF  LIM1, W
    SUBWF CONT, W
    BTFSC STATUS, Z
    BCF   PORTC, PINSERVO1

    MOVF  LIM2, W
    SUBWF CONT, W
    BTFSC STATUS, Z
    BCF   PORTC, PINSERVO2

    MOVF  LIM3, W
    SUBWF CONT, W
    BTFSC STATUS, Z
    BCF   PORTC, PINSERVO3

    MOVF  LIM4, W
    SUBWF CONT, W
    BTFSC STATUS, Z
    BCF   PORTC, PINSERVO4

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
    CALL    INITTMR0            ; 
    CALL    CONFIG_INTS         ; HABILITAMOS LAS INTERRUPCIONES DE TMR0

    ; INICIALIZAMOS VARIABLES
    BANKSEL PORTA
    CLRF CONT
    CLRF CONT1
    CLRF LIM1
    CLRF LIM2
    CLRF MUESTRA1
    CLRF MUESTRA2
    CLRF MUESTRA3
    CLRF MUESTRA4
    
    ; ENTRE 15 Y 62 FUNCIONA BIEN
    ; TENEMOS 238 EN TMR0 PRESCALER DE 4
    MOVLW .15
    MOVWF  LIM1
    MOVLW .62
    MOVWF  LIM2
    MOVLW .50
    MOVWF  LIM3
    MOVLW .30
    MOVWF  LIM4

LOOP

    CALL    CANAL0 
    CALL    MUESTREARYENVIAR    ; SE ENVIA EL PRIMER DATO
    MOVWF   MUESTRA1

    CALL    CANAL1
    CALL    MUESTREARYENVIAR    ; SE ENVIA EL SEGUNDO DATO
    MOVWF   MUESTRA2

    CALL    CANAL2
    CALL    MUESTREARYENVIAR    ; SE ENVIA EL TERCER DATO
    MOVWF   MUESTRA3

    CALL    CANAL3
    CALL    MUESTREARYENVIAR    ; SE ENVIA EL CUARTO DATO
    MOVWF   MUESTRA4
    
    MOVLW   .10                 ; CARACTER DE FIN DE LINEA
    CALL    ENVIARW

    CALL    MANEJO1
    CALL    MANEJO2
    CALL    MANEJO3
    CALL    MANEJO4

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

INITTMR0
    BSF STATUS, RP0
    BCF STATUS, RP1         ; CAMBIAMOS AL BANCO 1
    
    BCF OPTION_REG, T0CS    ; RELOJ INTERNO
    BCF OPTION_REG, PSA     ; ASIGNAMOS PRESCALER A TMR0
    
    BCF OPTION_REG, PS2
    BCF OPTION_REG, PS1
    BSF OPTION_REG, PS0     ; PRESCALER DE 4
    
    BCF STATUS, RP0
    BCF STATUS, RP1         ; CAMBIAMOS AL BANCO 0
    
    MOVLW .238              ; OFFSET NECESARIO PARA TIMER
    MOVWF TMR0              ; CARGAMOS EL N CALCULADO
    
    RETURN

CONFIG_INTS
    BANKSEL INTCON
    BCF INTCON, T0IF       ; BORRAMOS BANDERA DE INTERRUPCIÓN TIMER0
    BSF INTCON, GIE        ; HABILITO LAS INTERRUPCIONES GLOBALES
    BSF INTCON, T0IE       ; HABILITO LA INTERRUPCIÓN DEL TMR0
    RETURN

PERIODO
    BSF PORTC, PINSERVO1
    BSF PORTC, PINSERVO2
    BSF PORTC, PINSERVO3
    BSF PORTC, PINSERVO4
    RETURN

;----------------------------MANEJOS----------------------------------    

MANEJO1
    SIESMAYOR .240, MUESTRA1
    CALL INCSERVO1

    SIESMENOR .15,  MUESTRA1
    CALL DECSERVO1
    RETURN

INCSERVO1
    SIESMENOR .62, LIM1
    INCF LIM1, F
    RETURN

DECSERVO1
    SIESMAYOR .15, LIM1
    DECF LIM1, F
    RETURN

MANEJO2
    SIESMAYOR .240, MUESTRA2
    CALL INCSERVO2

    SIESMENOR .15,  MUESTRA2
    CALL DECSERVO2
    RETURN

INCSERVO2
    SIESMENOR .62, LIM2
    INCF LIM2, F
    RETURN

DECSERVO2
    SIESMAYOR .15, LIM2
    DECF LIM2, F
    RETURN


MANEJO3
    SIESMAYOR .240, MUESTRA3
    CALL INCSERVO3

    SIESMENOR .15,  MUESTRA3
    CALL DECSERVO3
    RETURN

INCSERVO3
    SIESMENOR .62, LIM3
    INCF LIM3, F
    RETURN

DECSERVO3
    SIESMAYOR .15, LIM3
    DECF LIM3, F
    RETURN

MANEJO4
    SIESMAYOR .240, MUESTRA4
    CALL INCSERVO4

    SIESMENOR .15,  MUESTRA4
    CALL DECSERVO4
    RETURN

INCSERVO4
    SIESMENOR .62, LIM4
    INCF LIM4, F
    RETURN

DECSERVO4
    SIESMAYOR .15, LIM4
    DECF LIM4, F
    RETURN

;-----------------------FINAL----------------------------------
    END
