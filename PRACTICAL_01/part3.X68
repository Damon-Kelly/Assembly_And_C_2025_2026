*-----------------------------------------------------------
* Title      :  Part 3
* Written by :  Damon Kelly
* Date       :  14/01/2026
* Description:  use assembly to display data with trap calls
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.B #$64, D1
    LEA text, A1
    MOVE #14, D0
    TRAP #15
    
    MOVE #3, D0
    TRAP #15

    SIMHALT             ; halt simulator

text:   dc.b 'Data Register: ', 0

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
