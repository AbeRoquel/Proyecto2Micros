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
 
 
GPR_VAR     UDATA
DELAY1              RES 1       ;
TEMPORAL            RES 1       ;
W_TEMP              RES 1
STATUS_TEMP         RES 1
LIMITE1             RES 1
CONT1               RES 1

RES_VECT    CODE    0x0000      ; processor reset vector
    GOTO    START               ; go to beginning of program

;*******************************************************************************
ISR       CODE    0x0004           ; interrupt vector location
PUSH:
    MOVWF W_TEMP
    SWAPF STATUS,W
    MOVWF STATUS_TEMP
ISR:
    BTFSC PIR1, TMR1IF
    CALL INTTMR1

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
    CALL    CONFIG_TMR1         ; TENEMOS 10MS DE PERIODO EN TMR1
    CALL    CONFIG_INTS         ; HABILITAMOS LAS INTERRUPCIONES DE TMR0 Y TMR1
    
    BANKSEL PORTA
    CLRF    LIMITE1
    CLRF    CONT1

    MOVLW   .60
    MOVWF    LIMITE1
    
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
    BCF OSCCON, IRCF1
    BCF OSCCON, IRCF0       ; FRECUENCIA DE 1MHZ
    RETURN

CONFIG_INTS
    BANKSEL INTCON
    BCF INTCON, T0IF       ; BORRAMOS BANDERA DE INTERRUPCIÓN TIMER0
    BCF PIR1, TMR1IF       ; BORRAMOS LA BANDERA DE OVERFLOW DE TIMER1

    BSF INTCON, GIE        ; HABILITO LAS INTERRUPCIONES GLOBALES
    ;BSF INTCON, T0IE       ; HABILITO LA INTERRUPCIÓN DEL TMR0
    BSF INTCON, PEIE       ; HABILITO LAS INTERRUPCIONES PERIFERICAS
    RETURN

CONFIG_TMR1
    BANKSEL PIE1
    BSF PIE1, TMR1IE       ; HABILITAMOS LAS INTERRUPCIONES DE TIMER1

    BANKSEL T1CON
    MOVLW B'00110001'      ; PRESCALADOR DE TIMER1 (8), RELOJ INTERNO Y ENCEDIDO
                           ; CARGAMOS 65223
    MOVWF T1CON
    MOVLW B'11000111'      ; N NECESARIO EN TMR1L
    MOVWF TMR1L
    MOVLW B'11111110'      ; N NECESARIO EN TMR1H
    MOVWF TMR1H
    RETURN

INITTMR0
    BSF STATUS, RP0
    BCF STATUS, RP1         ; CAMBIAMOS AL BANCO 1
    
    BCF OPTION_REG, T0CS    ; RELOJ INTERNO
    BCF OPTION_REG, PSA     ; ASIGNAMOS PRESCALER A TMR0
    
    BCF OPTION_REG, PS2
    BCF OPTION_REG, PS1
    BCF OPTION_REG, PS0     ; PRESCALER DE 2
    
    BCF STATUS, RP0
    BCF STATUS, RP1         ; CAMBIAMOS AL BANCO 0
    
    MOVLW .254              ; OFFSET NECESARIO PARA TIMER
    MOVWF TMR0              ; CARGAMOS EL N CALCULADO
    
    RETURN

INTTMR1
    BCF PIR1, TMR1IF       ; BORRAMOS LA BANDERA DE OVERFLOW DE TIMER1    
    MOVLW B'11000111'      ; N NECESARIO EN TMR1L
    MOVWF TMR1L
    MOVLW B'11111110'      ; N NECESARIO EN TMR1H
    MOVWF TMR1H

    BSF PORTC, RC0
    CALL ACTIVARTMR0

    RETURN

INTTMR0
    INCF PORTE, 1
    BCF INTCON, T0IF       ; BORRAMOS LA BANDERA DE OVERFLOW DE TIMER0
    MOVLW .254
    MOVWF TMR0             ; MOVEMOS EL N NECESARIO

    INCF CONT1, F          ; INCREMENTAMOS EL CONTADOR
    MOVF LIMITE1, W        ; 
    SUBWF CONT1,  W        
    BTFSC STATUS, Z        ; VEMOS SI LIMITE1 = CONT1
    CALL REINICIAR1 

    RETURN

ACTIVARTMR0
    BSF INTCON, T0IE   
    RETURN

DESACTIVARTMR0
    BCF INTCON, T0IE
    RETURN  

REINICIAR1
    BCF PORTC, RC0
    CLRF CONT1
    CALL DESACTIVARTMR0
    RETURN
;-----------------------FINAL----------------------------------
    END
