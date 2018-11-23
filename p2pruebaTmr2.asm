;*************************************************************
; PREUBA TMRS
;*************************************************************
#include "p16f887.inc"

; VAMOS A USAR UN PERIODO DE 10MS PARA EL PWM
; VAMOS A MUESTREAR EN AN0, AN1, AN2, AN3 (RA0, RA1, RA2, RA3)
; SI EL VALOR DE MUESTREO ES .10, ENVIAMOS .11 PARA QUE NO LEA UN ENTER

; CONFIG1
; __config 0xFCD4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 

 ;VAMOS A USAR TMRS = 251, PRES = 2 PERIODO = 40 MICROSEGS REPITIENDO EL LOOP 250 VECES
 
GPR_VAR     UDATA
DELAY1              RES 1       ;
W_TEMP              RES 1       ;
STATUS_TEMP         RES 1 
CONT                RES 1       ; CONT1 Y CONT2 AYUDAN A CONTAR HASTA 625
LIM1                RES 1       ; ESTAS VARIABLES DELIMITAN EL PWM DE LOS SERVOS
LIM2                RES 1


RES_VECT    CODE    0x0000      ; processor reset vector
    GOTO    START               ; go to beginning of program

;*******************************************************************************
ISR       CODE    0x0004           ; interrupt vector location
PUSH:
    MOVWF W_TEMP
    SWAPF STATUS,W
    MOVWF STATUS_TEMP
ISR:
    BTFSC INTCON, T0IF
    CALL INTTMR0
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
    CALL    CONFIG_OSCILATOR    ; configurar el oscilador a 1MHZ
    CALL    CONFIG_IO           ; (RA0-RA3) COMO ENTRADA ANALOGICA
    CALL    INITTMR0            ; PRESCALADOR DE 2,  N = 254
    CALL    CONFIG_INTS         ; HABILITAMOS LAS INTERRUPCIONES DE TMR0
    
    BANKSEL PORTA
    CLRF CONT              
    CLRF LIM1                
    CLRF LIM2      

    ; DE 12 A 60 FUNCIONA BIEN
    MOVLW .16
    MOVWF LIM1       
    
    MOVLW .60
    MOVWF LIM2

LOOP
    NOP
    GOTO    LOOP                          

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

CONFIG_OSCILATOR
    BANKSEL TRISA
    BSF OSCCON, IRCF2
    BSF OSCCON, IRCF1
    BCF OSCCON, IRCF0      ; FRECUENCIA DE 4MHZ
    RETURN

CONFIG_INTS
    BANKSEL INTCON
    BCF INTCON, T0IF       ; BORRAMOS BANDERA DE INTERRUPCIÓN TIMER0

    BSF INTCON, GIE        ; HABILITO LAS INTERRUPCIONES GLOBALES
    BSF INTCON, T0IE       ; HABILITO LA INTERRUPCIÓN DEL TMR0
    ;BSF INTCON, PEIE       ; HABILITO LAS INTERRUPCIONES PERIFERICAS
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
    
    MOVLW .245              ; OFFSET NECESARIO PARA TIMER
    MOVWF TMR0              ; CARGAMOS EL N CALCULADO
    
    RETURN

INTTMR0
    BCF INTCON, T0IF       ; BORRAMOS LA BANDERA DE OVERFLOW DE TIMER0
    MOVLW .245
    MOVWF TMR0             ; MOVEMOS EL N NECESARIO

    INCF CONT, F

    BTFSC STATUS, Z
    CALL PERIODO

    MOVF LIM1, W
    SUBWF CONT, W
    BTFSC STATUS, Z
    BCF PORTC, RC0

    MOVF LIM2, W
    SUBWF CONT, W
    BTFSC STATUS, Z
    BCF PORTC, RC1

    RETURN

PERIODO
    BSF PORTC, RC0
    BSF PORTC, RC1
    CLRF CONT

    RETURN
;-----------------------FINAL----------------------------------
    END
