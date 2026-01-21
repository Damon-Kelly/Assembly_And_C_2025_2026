*-----------------------------------------------------------
* Title      : practical_02_part1
* Written by : Damon Kelly
* Date       : 19/01/2026
* Description: Use basic memory concepts
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L  #%100,  D0  ; move binary 100 into D0, .L is 32 bits
    MOVE.L  #$100,  D1  ; moves hex 100 into D1
    MOVE.L  #100,   D2  ; move decimal 100 into D2
    
    MOVE.L  D0, $3000   ; moves the value stored in D0 into memory location 3000
    MOVE.L  D1, $3010   ; moves whats in D1 into 3010
    MOVE.L  D2, $3020   ; moves whats in D2 into 3030

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
