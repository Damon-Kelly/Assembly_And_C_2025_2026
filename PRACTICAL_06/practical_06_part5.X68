*-----------------------------------------------------------
* Title      : practical_06_part5
* Written by : Damon Kelly
* Date       : 02/03/2026
* Description: test trap task
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L  #HEALTH, -(SP)
    JSR     GAME_LOOP
    BSR     HEADS_UP_DISPLAY
    BRA     END
    
GAME_LOOP:
    MOVEA.L 4(SP), A1
    SUB.B   #10, (A1)
    RTS
    
HEADS_UP_DISPLAY:
    LEA     MESSAGE, A1
    MOVE.B  #14, D0
    TRAP    #15
    MOVE.B  HEALTH, D1
    MOVE.B  #3, D0
    TRAP    #15
    RTS


END

    SIMHALT             ; halt simulator

HEALTH: DC.B    100
MESSAGE:    DC.B    'Health:', 0

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~12~
*~Tab type~1~
*~Tab size~4~
