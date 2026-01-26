*-----------------------------------------------------------
* Title      : practical_03_part5
* Written by : Damon Kelly
* Date       : 26/01/2026
* Description: Use array
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVEA.L #ACHIEVEMENT_POINTS, A1 ; loads array location into A1
    MOVE.L  #0, D0  ; Makes D0 00000000 making sure it's blank
    
    MOVE.L  (A1)+,  D2  ; puts the first value in the array into D2
    ADD.L   D2, D0  ; Adds the value in D2 to whatevers in D0
    
    MOVE.L  (A1)+,  D2  ; puts the second value in the array into D2
    ADD.L   D2, D0  ; Adds the value in D2 to whatevers in D0
    
    MOVE.L  (A1)+,  D2  ; puts the third value in the array into D2
    ADD.L   D2, D0  ; Adds the value in D2 to whatevers in D0
    
    MOVE.L  (A1)+,  D2  ; puts the fourth value in the array into D2
    ADD.L   D2, D0  ; Adds the value in D2 to whatevers in D0
    
    MOVE.L  (A1)+,  D2  ; puts the fifth value in the array into D2
    ADD.L   D2, D0  ; Adds the value in D2 to whatevers in D0
    
    SIMHALT             ; halt simulator

ACHIEVEMENT_POINTS: DC.L    5, 10, 15, 20, 30

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
