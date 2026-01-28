*-----------------------------------------------------------
* Title      : practical_03_part4
* Written by : Damon Kelly
* Date       : 26/01/2026
* Description: Use address registers
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    LEA HEALTH, A3   ; loads HEALTH variable into A3    
    SUB.B   #10, (A3)   ; subtracts 10 from the first byte in the variable
    MOVE.B  (A3), $2000
    
    LEA BOSSHEALTH, A4  ; loads BOSSHEALTH into A4
    SUB.B   #100, (A4)  ; subtracts 100 from bosshealth in A4
    MOVE.W  (A4), $2010
    
    LEA PLAYERX,    A1  ; loads players x position into A1
    ADD.W   #1, (A1)    ; add 1 to playerx in A1
    MOVE.L  (A1), $2008
    
    LEA PLAYERY,    A2  ; loads playery into A2
    MOVE.B  (A2), $2020
    LEA BOSSX,  A5  ; loads bossx into A5
    MOVE.W  (A5), $2030
    LEA BOSSY,  A6  ; loads bossy into A6
    MOVE.B  (A6), $2040
    LEA COINS,  A6  ; loads coins into A7 overriding bossy
    MOVE.B  (A6), $2050
    LEA BOSSCOINS,  A0  ; loads bosscoins into A0
    MOVE.L  (A0), $2060
    LEA BOSSDAMAGE, A1  ; loads bossdamage into A1 overriding the playerx that was there
    MOVE.B  (A1), $2070
    LEA PLAYERDAMAGE,   A2  ; loads bossdamage into A2 overriding playery
    MOVE.L  (A2), $2080
    LEA PLAYERPOINTS,   A3  ; loads playerpoints into A3 overriding health
    MOVE.L  (A3), $2090
    LEA BOSSCYCLE,  A4  loads bosscycle into A4 overriding bosshealth
    MOVE.W  (A4), $2100
    
    SIMHALT             ; halt simulator

; Declaring the variables
HEALTH  dc.b $64
BOSSHEALTH  dc.b    $FF
BOSSX   dc.b    $0
BOSSY   dc.b    $0
PLAYERX dc.b    $0
PLAYERY dc.b    $0
COINS  dc.b $0
BOSSCOINS  dc.b    $A6
BOSSDAMAGE  dc.b    $A
PLAYERDAMAGE    dc.b    $4
PLAYERPOINTS    dc.b    $0
BOSSCYCLE   dc.b    $1

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~


