*-----------------------------------------------------------
* Title      : practical_04_part2
* Written by : Damon Kelly
* Date       : 09/02/2026
* Description: Use address registers
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    ; Move Health to Memory Location $3000
    MOVE.B  #100, $3000
    
    ; Move player location into D2
    ; X first byte 0 to 15
    ; Y second byte 0 to 15
    MOVE.B  #$12, D2
    
    ; Move NPC location into D3
    ; X first byte 0 to 15
    ; Y second byte 0 to 15
    MOVE.B  #$22, D3
    
    ; Bitwise AND D2 and D3
    ; Whats new location of player
    AND.B   D2, D3
    
    ; Load Memory Address $3000 into
    ; Address Register A1
    LEA $3000, A1
    
    ; Hit by NPC
    SUB.B   #20, (A1)
    
    ; Pickup Health Found
    ADD.B   #10, (A1)

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
