;*************************************************************
; P2 REV 1
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
 
 
GPR_VAR	    UDATA
DELAY1	            RES	1       ;
TEMPORAL            RES 1

RES_VECT    CODE    0x0000		; processor reset vector
    GOTO    START				; go to beginning of program

;*******************************************************************************
;ISR       CODE    0x0004           ; interrupt vector location
;     RETFIE
;*******************************************************************************
;-------------------------------PRINCIPAL---------------------------------------
MAIN_PROG CODE                      ; let linker place main program

START
    CALL    CONFIG_OSCILATOR	; configurar el oscilador a 1MHZ
    CALL    CONFIG_IO			; (RA0-RA3) COMO ENTRADA ANALOGICA
    CALL    CONFIG_ADC			; fosc/8, adc on, justificado a la izquierda, Vref interno (0-5V)
    CALL    CONFIG_UART         ; 9600 DE BAUD RATE
    CALL    CONFIG_PWM          ; USAMOS CCP1 Y CCP2
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
    MOVLW   .250		    ; 1US 
    MOVWF   DELAY1	    
    DECFSZ  DELAY1		    ; DECREMENTA CONT1
    GOTO    $-1			    ; IR A LA POSICION DEL PC - 1
    RETURN
;----------------------------CONFIGURACIONES----------------------------------    
CONFIG_IO
    BANKSEL TRISA
    CLRF    TRISA
    CLRF    TRISB
    CLRF    TRISC
    CLRF    TRISD
    CLRF    TRISE
    BSF	    TRISA, RA0		; RA0 COMO ENTRADA
    BSF     TRISA, RA1      ; RA1 COMO ENTRADA
    BSF     TRISA, RA2      ; RA2 COMO ENTRADA
    BSF     TRISA, RA3      ; RA3 COMO ENTRADA
    BANKSEL ANSEL
    CLRF    ANSEL
    CLRF    ANSELH
    BSF	    ANSEL, ANS0		; ANS0 COMO ENTRADA ANALÓGICA
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
    ; ESTAMOS A 1MHZ, NECESITAMOS FOSC/2, MUESTREAMOS A 2 MICROSEGUNDOS DE PERIODO 
    BCF ADCON0, ADCS1
    BCF ADCON0, ADCS0		; FOSC/8 RELOJ TAD
    
    BANKSEL TRISA
    BCF ADCON1, ADFM		; JUSTIFICACIÓN A LA IZQUIERDA
    BCF ADCON1, VCFG1		; VSS COMO REFERENCIA VREF-
    BCF ADCON1, VCFG0		; VDD COMO REFERENCIA VREF+
    BANKSEL PORTA
    BSF ADCON0, ADON		; ENCIENDO EL MÓDULO ADC
    RETURN

CONFIG_OSCILATOR
    BANKSEL TRISA
    BSF OSCCON, IRCF2
    BCF OSCCON, IRCF1
    BCF OSCCON, IRCF0		; FRECUENCIA DE 1MHZ
    RETURN

CONFIG_UART

    BANKSEL TXSTA
    BCF TXSTA, SYNC         ; ASINCRÓNO
    BSF TXSTA, BRGH         ; LOW SPEED

    BANKSEL BAUDCTL
    BSF BAUDCTL, BRG16      ; 16 BITS BAURD RATE GENERATOR

    BANKSEL SPBRG           ; MOVEMOS EL N ADECUADO A SPBRG PARA BAUDRATE DE 9600
    MOVLW .25
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

CONFIG_PWM
    BANKSEL TRISC
    BSF     TRISC, RC2      ; ESTABLEZCO RC2 / CCP1 COMO ENTRADA

    MOVLW   .155
    MOVWF   PR2             ; PERIODO DE 10MS
    
    BANKSEL PORTA
    BSF     CCP1CON, CCP1M3
    BSF     CCP1CON, CCP1M2
    BCF     CCP1CON, CCP1M1
    BCF     CCP1CON, CCP1M0 ; MODO PWM EN CCP1, ACTIVE HIGH
    
    ; QUEREMOS QUE EMPIECE EN 0 GRADOS

    ; ESTE NUMERO ES 105
    MOVLW   B'00101001'
    MOVWF   CCPR1L              ; MSB   DEL DUTY CICLE
    BSF     CCP1CON, DC1B1      
    BCF     CCP1CON, DC1B0      ; LSB del duty cicle
    
    BCF     PIR1, TMR2IF
    
    BSF     T2CON, T2CKPS1
    BSF     T2CON, T2CKPS0      ; PRESCALER 1:16
    
    BSF     T2CON, TMR2ON       ; HABILITAMOS EL TMR2
    BTFSS   PIR1, TMR2IF
    GOTO    $-1
    BCF     PIR1, TMR2IF
    
    BANKSEL TRISC
    BCF     TRISC, RC2          ; RC2 / CCP1 SALIDA PWM

    RETURN

ACTUALIZARSERVO
    CLRF  CCPR1L
    BCF   CCP1CON, DC1B1
    BCF   CCP1CON, DC1B0        ; TODO EN CERO
                                ; ACTUALIZAMOS EL VALOR PARA EL PWM
    BTFSC TEMPORAL, 0
    BSF   CCP1CON, DC1B0

    BTFSC TEMPORAL, 1
    BSF   CCP1CON, DC1B1

    BTFSC TEMPORAL, 2
    BSF   CCPR1L, 0

    BTFSC TEMPORAL, 3
    BSF   CCPR1L, 1

    BTFSC TEMPORAL, 4
    BSF   CCPR1L, 2

    BTFSC TEMPORAL, 5
    BSF   CCPR1L, 3

    BTFSC TEMPORAL, 6
    BSF   CCPR1L, 4

    BTFSC TEMPORAL, 7
    BSF   CCPR1L, 5

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
