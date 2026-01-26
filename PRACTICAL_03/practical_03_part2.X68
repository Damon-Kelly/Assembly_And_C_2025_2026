*-----------------------------------------------------------
* Title      : practical_03_part2
* Written by : Damon Kelly
* Date       : 26/01/2026
* Description: Use address registers
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA $4000, A2   ; loads memory address 4000 into A2
    MOVE.B #100, (A2)   ; moves decimal 100 to A2 which goes to $4000
    SUB.B   #10, (A2)   ; subtracts 10 from the first byte in $4000

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
