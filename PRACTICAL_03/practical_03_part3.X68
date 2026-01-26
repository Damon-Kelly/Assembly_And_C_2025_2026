*-----------------------------------------------------------
* Title      : practical_03_part3
* Written by : Damon Kelly
* Date       : 26/01/2026
* Description: Use address registers
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA HEALTH, A3   ; loads HEALTH variable into A3    
    SUB.B   #10, (A3)   ; subtracts 10 from the first byte in the variable

    SIMHALT             ; halt simulator

HEALTH  dc.b $64

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
