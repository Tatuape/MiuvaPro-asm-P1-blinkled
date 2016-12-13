; ***********************************************************
;   INTESC electronics & embedded
;
;   Curso básico de microcontroladores en ensamblador	    
;
;   Práctica 1: Hacer parpadear un led
;   Objetivo: Hacer parpadear un led cada segundo
;
;   Fecha: 05/Jun/16
;   Creado por: Daniel Hernández Rodríguez
; ************************************************************

LIST    P = 18F87J50	;PIC a utilizar
INCLUDE <P18F87J50.INC>

;************************************************************
;Configuración de fusibles
CONFIG  FOSC = HS   
CONFIG  DEBUG = OFF
CONFIG  XINST = OFF

;***********************************************************
;Código

CBLOCK  0x000
    Ret1	;Variables para los retardos de 1 segundo
    Ret2
    Ret3
ENDC
    
;Código
ORG 0x0000	;Vector de reset
    goto INICIO
;Inicio del programa principal

INICIO    
    movlw   0x00
    movwf   TRISJ   ;Configura PUERTO E como salida
 
BUCLE

; Calculo de los valores de las variables para el retardo de aproximadamente
; 1 segundo
;
; fosc = 8MHz 
; Ciclo Reloj = 1/fosc = 1/8M = 125ns
; Ciclo Instruccion = 4*Ciclo Reloj = 500ns
; La funcion DECFSZ tarda 3 ciclos en ejecutarse
; Retardo 15ms
; Tiempo = Ret1*Ret2*Ret3*(3*500ns) 
; Tiempo = Ret1*Ret2*Ret3*(1.5us)
; Ret1 = 255
; Ret2 = 255
; Ret3 = 11
; Tiempo = (255*255*11)(1.5us) = 1.0729 seg

;Retardo de un segundo para encender el LED
Retardo1sON
    movlw   D'255'    ;Cargamos los valores de los retardos a las constantes
    movwf   Ret1    ;correspondientes
    movlw   D'255'
    movwf   Ret2
    movlw   D'11'
    movwf   Ret3
Ret1sON
    decfsz  Ret1, F ;Decrementa el valor de Ret1 y salta si es igual a 0
    bra	    Ret1sON ;Saltamos a Ret1sON
    decfsz  Ret2, F ;Decremente el valor de Ret2 y salta si es igual a 0
    bra	    Ret1sON ;Saltamos a Ret1sON
    decfsz  Ret3, F ;Decremente el valor de Ret3 y salta si es igual a 0
    bra	    Ret1sON ;Saltamos a Ret1sON
    movlw   0xFF   
    movwf   PORTJ	;Encendemos el led ubicado en E0
    
;Mismo retardo pero ahora para esperar antes de apagar el LED
Retardo1sOFF
    movlw   .255
    movwf   Ret1
    movlw   .255
    movwf   Ret2
    movlw   .11
    movwf   Ret3
Ret1sOFF
    decfsz  Ret1, F
    bra	    Ret1sOFF
    decfsz  Ret2, F
    bra	    Ret1sOFF
    decfsz  Ret3, F
    bra	    Ret1sOFF
    movlw   0x00
    movwf   PORTJ   ;Apaga el LED
    
    goto    BUCLE   ;Regresa al INICIO

    END             ;Fin de Programa