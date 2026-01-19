*-----------------------------------------------------------
* Title      : practical_02_part1
* Written by : Damon Kelly
* Date       : 19/01/2026
* Description: Use basic memory concepts
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L  #%100,  D0
    MOVE.L  #$100,  D1
    MOVE.L  #100,   D2
    
    MOVE.L  D0, $3000
    MOVE.L  D1, $3010
    MOVE.L  D2, $3020

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
