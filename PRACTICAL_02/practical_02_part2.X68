*-----------------------------------------------------------
* Title      : practical_02_part2
* Written by : Damon Kelly
* Date       : 19/01/2026
* Description: Understand assembly
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L  #%100,  D0  ; moves 32-bit binary 100 into D0
    MOVE.L  #$100,  D1  ; moves hex 100 into D1
    MOVE.L  #100,   D2  ; moves decimal 100 into D2
    
    MOVE.L  D0, $3000   ; moves the value stored in D0 into memory location 3000
    MOVE.L  D1, $3010   ; moves whats in D1 into 3010
    MOVE.L  D2, $3020   ; moves whats in D2 into 3030
    
    MOVE.W  #100, $3020 ; moves 16-bit decimal vslue 100 into 3020
    MOVE.W  #$100, $3010    ; moves hex 100(16-bit) to 3010
    MOVE.W  #%100, $3000    ; moves binary 100 to 3000

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
