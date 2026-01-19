*-----------------------------------------------------------
* Title      : practical_02_part4
* Written by : Damon Kelly
* Date       : 19/01/2026
* Description: Complete scecifications
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L  #$1234ABCD, $3000
    MOVE.W  #%11111010101,   D0
    MOVE.B  #27, $3010
    
    MOVE.W  D0,  $3020
    MOVE.B  $3020,  D1
    MOVE.W  D1, D3
    
    MOVE.L  #$FFFF,   $3030
    MOVE.W  #$EE,   $3030
    MOVE.B  #$DD,   $3030

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
