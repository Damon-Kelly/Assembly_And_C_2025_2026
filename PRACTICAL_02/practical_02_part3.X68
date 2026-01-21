*-----------------------------------------------------------
* Title      : practical_02_part3
* Written by : Damon Kelly
* Date       : 19/01/2026
* Description: Debug
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L  #%100,  D0  ; move 32 bit binary 100 into D0
    MOVE.L  #$100,  D1  ; moves 32 bit hev value 100 into D1
    MOVE.L  #100,   D2  ; moves decimal 100 into D2
    
    MOVE.L  D0, $3000   ; moves 32 bits from D0 into memory lecation 3000
    MOVE.L  D1, $3010   ; moves 32 bits from D1 into memory lecation 3010
    MOVE.L  D2, $3020   ; moves 32 bits from D2 into memory lecation 3020
    
    MOVE.W  #100, $3020 ; moves 16 bit decimal value 100 into 3020
    MOVE.W  #$100, $3010    ; moves 16 bit hex value 100 into 3010
    MOVE.W  #%100, $3000    ; moves 16 bit binary value 100 into 3000
    
    MOVE.B  #100,   $3020   ; moves 8 bit decimal value 100 to 3020
    MOVE.B  #$64,   $3010   ; moves 8 bit hex value 64 into 3010
    MOVE.B  #%10001111, $3000   ; moves 8 bits binary value 10001111 to 3000

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
