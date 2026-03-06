*-----------------------------------------------------------
* Title      : practical_06_part1
* Written by : Damon Kelly
* Date       : 02/03/2026
* Description: test trap task
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    ; Move Trap Task to D0
    MOVE.B  #2, D0
    ; Interupt and Trap Task
    Trap    #15
    
    LEA     MESSAGE, A1
    MOVE.B  #13, D0
    TRAP    #15

    SIMHALT             ; halt simulator


MESSAGE:    DC.B    'Trap Task Test', 0

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
