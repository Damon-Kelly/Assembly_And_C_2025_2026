*-----------------------------------------------------------
* Title      : practical_03_part1
* Written by : Damon Kelly
* Date       : 26/01/2026
* Description: Use address registers
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA $4000, A1   ; loads memory address 4000 into A1
    MOVE.B #100, (A1)   ; moves decimal 100 to A1 which goes to $4000

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
