*-----------------------------------------------------------
* Title      : practical_02_part4
* Written by : Damon Kelly
* Date       : 19/01/2026
* Description: Complete scecifications
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

    MOVE.L  #$1234ABCD, $3000   ; moves 32-bits hex value to memory location 3000
    MOVE.W  #%11111010101,   D0 ; moves 16-bits binary value 11111010101 to D0
    MOVE.B  #27, $3010  ; moves 8 bit decimal value 27 to 3010
    
    MOVE.W  D0,  $3020  ; moves 16 bits from D0 to memory location 3020
    MOVE.B  $3020,  D1  ; moves 8 bits from 3020 to D1
    MOVE.W  D1, D3  ; moves 16 bits from D1 to D3
    
    MOVE.L  #$EEEE,   $3030 ; moves 32 bits hex value EEEE to 3030
    MOVE.W  #$DD,   $3030   ; moves 16 bit hex value DD to 3030
    MOVE.B  #$CC,   $3030   ; moves 8 bits hex value CC to 3030
    
    MOVE.W  #2005,  D2  ; moves 16 bits decimal value 2005 to D2
    MOVE.B  D2, $3040   ; moves 8 bits from D2 to memory location 3040
    MOVE.L  D2, $3040   ; moves 32 bits from D2 to 3040
    
    MOVE.B  #%01,   $3050   ; moves 8 bits binary value 01 to 3050
    MOVE.W  $3050,  A1  ; moves 16 bits from memory 3050 to A1
    MOVE.L  $3050,  A2  ; moves 32 bits from 3050 to A2
    
    MOVE.B  D2, $3060   ; moves 8 bits from D2 to 3060
    MOVE.W  D3, A0  ; moves 16 bits from D3 to A0
    MOVE.L  A0, D4  moves 32 bits from A0 to D4

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
