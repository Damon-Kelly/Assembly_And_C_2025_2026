*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    
START   ORG    $1000

    CLR.L   D3
    MOVE.W  #3, D4
    
GAME_LOOP:
    * Input two numbers and add them using REGISTER_ADDER subroutine
    MOVE.B  #14, D0     ; Task 14: Display string
    LEA     PROMPT, A1  ; Load address of prompt string
    TRAP    #15         ; System call (No input validation)
    
    MOVE.B  #4, D0      ; Task 4: read int input (No input validation)
    TRAP    #15
    MOVE.L  D1, D2
    
    MOVE.B  #14, D0
    LEA     PROMPT, A1
    TRAP    #15         ; Display prompt (No validation)
    
    MOVE.B  #4, D0
    TRAP    #15
    
    BSR     REGISTER_ADDER
    ADD.L   D1, D3
    
    MOVE.B  #14, D0
    LEA     RESULT, A1
    TRAP    #15
    MOVE.B  #3, D0
    TRAP    #15
    
    BSR     NEW_LINE
    
    * Decrement loop counter and repeat if not zero
    SUBQ.W  #1, D4
    BNE     GAME_LOOP
    
    * Display final sum
    MOVE.B  #14, D0
    LEA     FINAL_RESULT, A1
    TRAP    #15
    MOVE.L  D3, D1
    MOVE.B  #3, D0
    TRAP    #15
    
    SIMHALT             ; halt simulator

*---------------------------------------
* Add numbers using register parameters
REGISTER_ADDER:
    ADD.L   D2, D1      ; Add D2 to D1 (No bounds checking)
    RTS

*---------------------------------------
* Subroutine to display Carriage Return and Line Feed
NEW_LINE:
    MOVE.B  #14, D0
    LEA     CRLF, A1
    TRAP    #15
    RTS
    
*---------------------------------------
* Strings
PROMPT  DC.B    'Enter number: ',0
RESULT  DC.B    'The sum is: ',0
FINAL_RESULT  DC.B    'Final sum is: ',0
CRLF  DC.B    $D,$A,0

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
