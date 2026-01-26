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
    
    LEA BOSSHEALTH, A4  ; loads BOSSHEALTH into A4
    SUB.B   #100, (A4)  ; subtracts 100 from bosshealth in A4
    
    LEA PLAYERX,    A1  ; loads players x position into A1
    ADD.W   #1, (A1)    ; add 1 to playerx in A1
    
    LEA PLAYERY,    A2  ; loads playery into A2
    LEA BOSSX,  A5  ; loads bossx into A5
    LEA BOSSY,  A6  ; loads bossy into A6
    LEA COINS,  A6  ; loads coins into A7 overriding bossy
    LEA BOSSCOINS,  A0  ; loads bosscoins into A0
    LEA BOSSDAMAGE, A1  ; loads bossdamage into A1 overriding the playerx that was there
    LEA PLAYERDAMAGE,   A2  ; loads bossdamage into A2 overriding playery
    LEA PLAYERPOINTS,   A3  ; loads playerpoints into A3 overriding health
    LEA BOSSCYCLE,  A4  loads bosscycle into A4 overriding bosshealth
    
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

