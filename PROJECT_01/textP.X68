*-----------------------------------------------------------
* Title      : The Heist
* Written by : Damon Kelly
* Student ID : C00307057
* Date       : 25/02/2025
* Description: A text-based heist strategy game. Manage cash,
*              crew, gear and heat to pull off increasingly
*              dangerous heists. Lose if heat hits 100 or
*              crew hits 0.
* Known Bugs : If enter is hit when no number is entered it
*              will break.
*              After a bank heist heat randomly went to zero.
*-----------------------------------------------------------
        ORG     $1000                       ; Set program start address to $1000

*-----------------------------------------------------------
* Section: Game Constants
*-----------------------------------------------------------
MAX_HEAT        EQU     100                 ; Police raid threshold
GEAR_COST       EQU     100                 ; Cost to upgrade gear
CREW_COST       EQU     150                 ; Cost to hire a crew member
BRIBE_COST      EQU     200                 ; Cost to bribe police

START_CASH      EQU     500                 ; Cash at game start
START_CREW      EQU     2                   ; Crew size at game start
START_GEAR      EQU     1                   ; Gear level at game start (1-5)
START_HEAT      EQU     0                   ; Heat level at game start

*-----------------------------------------------------------
* Section: Heist Target Constants
*-----------------------------------------------------------
SHOP_REWARD     EQU     200                 ; Cash reward for corner shop job
SHOP_HEAT_GAIN  EQU     15                  ; Heat added after corner shop job
SHOP_MIN_GEAR   EQU     1                   ; Min gear level for corner shop

JEWEL_REWARD    EQU     350                 ; Cash reward for jewellery store job
JEWEL_HEAT_GAIN EQU     30                  ; Heat added after jewellery store job
JEWEL_MIN_GEAR  EQU     2                   ; Min gear level for jewellery store

BANK_REWARD     EQU     700                 ; Cash reward for bank vault job
BANK_HEAT_GAIN  EQU     50                  ; Heat added after bank vault job
BANK_MIN_GEAR   EQU     4                   ; Min gear level for bank vault

*-----------------------------------------------------------
* Program Entry Point
*-----------------------------------------------------------
START:
    MOVE.W  #START_CASH,    CASH            ; Set starting cash
    MOVE.W  #START_CREW,    CREW            ; Set starting crew count
    MOVE.W  #START_GEAR,    GEAR            ; Set starting gear level
    MOVE.W  #START_HEAT,    HEAT            ; Set starting heat to zero
    MOVE.W  #0,             REP             ; Set starting reputation to zero
    MOVE.W  #0,             WANTED          ; No wanted status at start
    MOVE.W  #0,             HEISTS_DONE     ; No heists completed at start
    MOVE.W  #1,             CYCLE           ; Start on cycle 1
    MOVE.W  #0,             HEAT_BONUS      ; No heat bonus at start
    BSR     SHOW_WELCOME                    ; Call show welcome screen
    BRA     GAME_LOOP                       ; Jump into the main game loop

*-----------------------------------------------------------
* Subroutine : GAME_LOOP
* Description: Runs every turn - checks loss first and then shows stats
*              and menu
*-----------------------------------------------------------
GAME_LOOP:
    BSR     NEW_LINE                        ; Call print a blank line
    BSR     CHECK_IF_DEAD                   ; Call check loss BEFORE stats (crew could be 0)
    BSR     SHOW_STATS                      ; Call show all current resource values
    BSR     SHOW_MENU                       ; Call show menu and handle player choice
    BRA     GAME_LOOP                       ; Loop back to start of turn

*-----------------------------------------------------------
* Subroutine : SHOW_WELCOME
* Description: Prints the title screen and waits for input
*-----------------------------------------------------------
SHOW_WELCOME:
    BSR     NEW_LINE                        ; Call print a blank line
    LEA     WELCOME_MSG,    A1              ; Load address of welcome text into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the welcome message
    BSR     WAIT_KEY                        ; Call wait for player to press enter
    RTS                                     ; Return to caller

*-----------------------------------------------------------
* Subroutine : SHOW_STATS
* Description: Prints all current resource levels grouped
*              into money, crew and heat sections
*-----------------------------------------------------------
SHOW_STATS:
    BSR     CALC_LOAD                       ; Call recalculate load before displaying it
    BSR     NEW_LINE                        ; Call print a blank line

    LEA     HUD_HEADER,     A1              ; Load address of status header into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the header
    BSR     NEW_LINE                        ; Print a blank line

    ; Money section
    LEA     HUD_MONEY,      A1              ; Load address of money section label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the money section header
    BSR     NEW_LINE                        ; Move to next line

    LEA     CASH_MSG,       A1              ; Load address of cash label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the cash label
    MOVE.W  CASH,           D1              ; Load current cash into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print the cash value
    BSR     NEW_LINE                        ; Move to next line

    LEA     LOAD_MSG,       A1              ; Load address of load label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the load label
    MOVE.W  LOAD,           D1              ; Load current load value into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print the load value
    BSR     NEW_LINE                        ; Move to next line
    BSR     NEW_LINE                        ; Print a blank line between sections

    ; Crew section
    LEA     HUD_CREW,       A1              ; Load address of crew section label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the crew section header
    BSR     NEW_LINE                        ; Move to next line

    LEA     CREW_MSG,       A1              ; Load address of crew label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the crew label
    MOVE.W  CREW,           D1              ; Load current crew count into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print the crew count
    BSR     NEW_LINE                        ; Move to next line

    LEA     GEAR_MSG,       A1              ; Load address of gear label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the gear label
    MOVE.W  GEAR,           D1              ; Load current gear level into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print the gear level
    BSR     NEW_LINE                        ; Move to next line
    BSR     NEW_LINE                        ; Print a blank line between sections

    ; Heat section
    LEA     HUD_HEAT,       A1              ; Load address of heat section label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the heat section header
    BSR     NEW_LINE                        ; Move to next line

    LEA     HEAT_MSG,       A1              ; Load address of heat label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the heat label
    MOVE.W  HEAT,           D1              ; Load current heat into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print the heat value
    BSR     NEW_LINE                        ; Move to next line

    LEA     WANTED_MSG,     A1              ; Load address of wanted label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the wanted label
    MOVE.W  WANTED,         D1              ; Load wanted flag into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print 0 for clear or 1 for wanted
    BSR     NEW_LINE                        ; Move to next line

    LEA     CYCLE_MSG,      A1              ; Load address of cycle label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the cycle label
    MOVE.W  CYCLE,          D1              ; Load current cycle number into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print the cycle number
    BSR     NEW_LINE                        ; Move to next line

    LEA     DIVIDER,        A1              ; Load address of divider into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the divider
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return to caller
*-----------------------------------------------------------
* Subroutine : CHECK_IF_DEAD
* Description: Checks both lose conditions - heat at max
*              or crew wiped out
*-----------------------------------------------------------
CHECK_IF_DEAD:
    MOVE.W  HEAT,           D1              ; Load current heat into D1
    CMP.W   #MAX_HEAT,      D1              ; Compare heat against max allowed (100)
    BGE     LOSE_HEAT                       ; Branch if heat is 100 or over

    MOVE.W  CREW,           D1              ; Load current crew count into D1
    CMP.W   #0,             D1              ; Compare crew against zero
    BLE     LOSE_CREW                       ; Branch if crew is zero or less
    RTS                                     ; Both checks passed, return safely

LOSE_HEAT:
    BSR     NEW_LINE                        ; Call print a blank line
    LEA     LOSE_HEAT_MSG,  A1              ; Load address of heat lose message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the police raid message
    BRA     GAME_OVER                       ; Jump to game over screen

LOSE_CREW:
    BSR     NEW_LINE                        ; Call print a blank line
    LEA     LOSE_CREW_MSG,  A1              ; Load address of crew lose message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the crew wiped message
    BRA     GAME_OVER                       ; Jump to game over screen

*-----------------------------------------------------------
* Subroutine : GAME_OVER
* Description: Shows game over screen with final score,
*              then offers replay or quit
*-----------------------------------------------------------
GAME_OVER:
    BSR     NEW_LINE                        ; Call print a blank line
    LEA     GAME_OVER_MSG,  A1              ; Load address of game over banner into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the game over banner
    BSR     NEW_LINE                        ; Call print a blank line

    LEA     FINAL_REP_MSG,  A1              ; Load address of final score label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the final score label
    MOVE.W  REP,            D1              ; Load final reputation score into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print the final reputation score
    BSR     NEW_LINE                        ; Move to next line
    BSR     NEW_LINE                        ; Print an extra blank line

    LEA     REPLAY_MSG,     A1              ; Load address of replay prompt into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the replay question
    MOVE.B  #4,             D0              ; Set trap task 4 to read a number
    TRAP    #15                             ; Read player choice into D1

    CMP.W   #1,             D1              ; Did the player enter 1 to replay?
    BEQ     RESTART                         ; Branch to restart if yes
    SIMHALT                                 ; Halt and end program if not 1

RESTART:
    MOVE.W  #START_CASH,    CASH            ; Reset cash to starting value
    MOVE.W  #START_CREW,    CREW            ; Reset crew to starting value
    MOVE.W  #START_GEAR,    GEAR            ; Reset gear to starting value
    MOVE.W  #START_HEAT,    HEAT            ; Reset heat to starting value
    MOVE.W  #0,             REP             ; Reset reputation to zero
    BRA     GAME_LOOP                       ; Jump back into the game loop

*-----------------------------------------------------------
* Subroutine : SHOW_MENU
* Description: Prints the main action menu and reads a
*              validated choice between 0 and 5
*-----------------------------------------------------------
SHOW_MENU:
    BSR     NEW_LINE                        ; Call print a blank line
    LEA     MENU_MSG,       A1              ; Load address of main menu text into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the menu options

    MOVE.B  #4,             D0              ; Set trap task 4 to read a number
    TRAP    #15                             ; Read player choice into D1

    CMP.W   #0,             D1              ; Is choice below 0?
    BLT     MENU_INVALID                    ; Branch if too low to be valid
    CMP.W   #5,             D1              ; Is choice above 5?
    BGT     MENU_INVALID                    ; Branch if too high to be valid

    CMP.W   #0,             D1              ; Did player choose 0 (quit)?
    BEQ     MENU_QUIT                       ; Branch to quit
    CMP.W   #1,             D1              ; Did player choose 1 (heist)?
    BEQ     MENU_HEIST                      ; Branch to heist menu
    CMP.W   #2,             D1              ; Did player choose 2 (gear)?
    BEQ     MENU_GEAR                       ; Branch to buy gear
    CMP.W   #3,             D1              ; Did player choose 3 (crew)?
    BEQ     MENU_CREW                       ; Branch to hire crew
    CMP.W   #4,             D1              ; Did player choose 4 (bribe)?
    BEQ     MENU_BRIBE                      ; Branch to bribe police
    CMP.W   #5,             D1              ; Did player choose 5 (lay low)?
    BEQ     MENU_LAYLOW                     ; Branch to lay low

MENU_INVALID:
    LEA     INVALID_MSG,    A1              ; Load address of invalid input message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the error message
    BSR     SHOW_MENU                       ; Call show menu again on bad input
    RTS                                     ; Return after valid input handled

MENU_QUIT:
    SIMHALT                                 ; Halt and end the program

MENU_HEIST:
    BSR     PICK_TARGET                     ; Call target selection menu
    RTS                                     ; Return after heist handled

MENU_GEAR:
    BSR     BUY_GEAR                        ; Call buy gear subroutine
    RTS                                     ; Return after purchase handled

MENU_CREW:
    BSR     HIRE_UP                         ; Call hire crew subroutine
    RTS                                     ; Return after hire handled

MENU_BRIBE:
    BSR     PAY_BRIBE                       ; Call pay bribe subroutine
    RTS                                     ; Return after bribe handled

MENU_LAYLOW:
    BSR     LAY_LOW                         ; Call lay low subroutine
    RTS                                     ; Return after lay low handled

*-----------------------------------------------------------
* Subroutine : PICK_TARGET
* Description: Shows three heist targets and reads a
*              validated choice between 1 and 3
*-----------------------------------------------------------
PICK_TARGET:
    BSR     NEW_LINE                        ; Call print a blank line
    LEA     HEIST_MENU_MSG, A1              ; Load address of target selection text into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the target menu

    MOVE.B  #4,             D0              ; Set trap task 4 to read a number
    TRAP    #15                             ; Read player choice into D1

    CMP.W   #1,             D1              ; Is choice below 1?
    BLT     HEIST_INVALID                   ; Branch if too low to be valid
    CMP.W   #3,             D1              ; Is choice above 3?
    BGT     HEIST_INVALID                   ; Branch if too high to be valid

    CMP.W   #1,             D1              ; Did player choose 1 (shop)?
    BEQ     DO_SHOP                         ; Branch to corner shop setup
    CMP.W   #2,             D1              ; Did player choose 2 (jewellery)?
    BEQ     DO_JEWEL                        ; Branch to jewellery store setup
    CMP.W   #3,             D1              ; Did player choose 3 (bank)?
    BEQ     DO_BANK                         ; Branch to bank vault setup

HEIST_INVALID:
    LEA     INVALID_MSG,    A1              ; Load address of invalid input message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the error message
    BSR     PICK_TARGET                     ; Call pick target again on bad input
    RTS                                     ; Return after valid input handled

DO_SHOP:
    MOVE.W  #SHOP_REWARD,       HEIST_REWARD    ; Store shop reward for this run
    MOVE.W  #SHOP_HEAT_GAIN,    HEIST_HEAT      ; Store shop heat cost for this run
    MOVE.W  #SHOP_MIN_GEAR,     HEIST_MIN_GEAR  ; Store shop gear requirement
    LEA     SHOP_MSG,           A1              ; Load address of shop flavour text into A1
    MOVE.B  #14,                D0              ; Set trap task 14 to print string
    TRAP    #15                                 ; Print the target description
    BSR     RUN_HEIST                           ; Call execute the heist
    RTS                                         ; Return after heist done

DO_JEWEL:
    MOVE.W  #JEWEL_REWARD,      HEIST_REWARD    ; Store jewellery reward for this run
    MOVE.W  #JEWEL_HEAT_GAIN,   HEIST_HEAT      ; Store jewellery heat cost for this run
    MOVE.W  #JEWEL_MIN_GEAR,    HEIST_MIN_GEAR  ; Store jewellery gear requirement
    LEA     JEWEL_MSG,          A1              ; Load address of jewellery flavour text into A1
    MOVE.B  #14,                D0              ; Set trap task 14 to print string
    TRAP    #15                                 ; Print the target description
    BSR     RUN_HEIST                           ; Call execute the heist
    RTS                                         ; Return after heist done

DO_BANK:
    MOVE.W  #BANK_REWARD,       HEIST_REWARD    ; Store bank reward for this run
    MOVE.W  #BANK_HEAT_GAIN,    HEIST_HEAT      ; Store bank heat cost for this run
    MOVE.W  #BANK_MIN_GEAR,     HEIST_MIN_GEAR  ; Store bank gear requirement
    LEA     BANK_MSG,           A1              ; Load address of bank flavour text into A1
    MOVE.B  #14,                D0              ; Set trap task 14 to print string
    TRAP    #15                                 ; Print the target description
    BSR     RUN_HEIST                           ; Call execute the heist
    RTS                                         ; Return after heist done

*-----------------------------------------------------------
* Subroutine : RUN_HEIST
* Description: Checks gear, rolls for success or failure.
*              Low crew = 60% success, high crew = 80%.
*              Auto-fail if gear is below target minimum.
*-----------------------------------------------------------
RUN_HEIST:
    BSR     NEW_LINE                        ; Call print a blank line
    LEA     EXECUTING_MSG,  A1              ; Load address of executing message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the executing message

    MOVE.W  GEAR,           D1              ; Load current gear level into D1
    MOVE.W  HEIST_MIN_GEAR, D2              ; Load minimum gear required into D2
    CMP.W   D2,             D1              ; Compare current gear against minimum
    BGE     GEAR_OK                         ; Branch if gear meets the requirement

    LEA     LOW_GEAR_MSG,   A1              ; Load address of gear too low message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the gear too low message
    BSR     HEIST_BUST                      ; Call fail handler
    RTS                                     ; Return after fail handled

GEAR_OK:
    BSR     CALC_LOAD                       ; Recalculate load to make sure it is current

    ; Set base success threshold from crew size
    MOVE.W  CREW,           D3              ; Load crew count into D3
    CMP.W   #3,             D3              ; Is crew 3 or more (high crew)?
    BGE     SET_HIGH_BASE                   ; Branch to set 80% base threshold
    MOVE.W  #60,            D3              ; Low crew: base threshold is 60%
    BRA     APPLY_LOAD_PEN                  ; Jump to apply load penalty

SET_HIGH_BASE:
    MOVE.W  #80,            D3              ; High crew: base threshold is 80%

APPLY_LOAD_PEN:
    ; Reduce threshold based on load per crew member
    MOVE.W  LOAD,           D2              ; Load current load value into D2
    CMP.W   #300,           D2              ; Is load 300 or more (heavy)?
    BGE     HEAVY_PEN                       ; Branch for heavy penalty
    CMP.W   #150,           D2              ; Is load 150 or more (moderate)?
    BGE     MOD_PEN                         ; Branch for moderate penalty
    BRA     DO_ROLL                         ; Under 150 is light, no penalty

HEAVY_PEN:
    SUB.W   #20,            D3              ; Heavy load: subtract 20% from threshold
    BRA     DO_ROLL                         ; Jump to roll

MOD_PEN:
    SUB.W   #10,            D3              ; Moderate load: subtract 10% from threshold

DO_ROLL:
    BSR     ROLL_DICE                       ; Call get random number 1-100 into D1
    CMP.W   D3,             D1              ; Compare roll against adjusted threshold
    BLE     HEIST_WIN                       ; Roll within threshold = success
    BRA     HEIST_BUST                      ; Roll over threshold = fail

HIGH_CREW:
    CMP.W   #80,            D0              ; High crew: succeed if roll is 80 or under
    BLE     HEIST_WIN                       ; Branch to success
    BRA     HEIST_BUST                      ; Otherwise branch to fail

*-----------------------------------------------------------
* Subroutine : HEIST_WIN
* Description: Handles successful heist, applies heat bonus
*              from endless mode and wanted status, warns
*              player if cycle bonus is active, then checks
*              if 3 heists done for a new cycle
*-----------------------------------------------------------
HEIST_WIN:
    BSR     NEW_LINE                        ; Call print a blank line
    LEA     SUCCESS_MSG,    A1              ; Load address of success message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the success message
    BSR     NEW_LINE                        ; Print a blank line

    MOVE.W  CASH,           D1              ; Load current cash into D1
    ADD.W   HEIST_REWARD,   D1              ; Add the heist reward to cash
    MOVE.W  D1,             CASH            ; Store the updated cash value

    MOVE.W  HEAT,           D1              ; Load current heat into D1
    ADD.W   HEIST_HEAT,     D1              ; Add base heat from this heist
    ADD.W   HEAT_BONUS,     D1              ; Add endless mode cycle heat bonus

    ; Warn player if cycle heat bonus is active
    MOVE.W  HEAT_BONUS,     D2              ; Load heat bonus into D2
    CMP.W   #0,             D2              ; Is there any cycle bonus active?
    BEQ     SKIP_BONUS_MSG                  ; Branch if no bonus, skip message
    LEA     HEAT_BONUS_MSG, A1              ; Load address of cycle heat warning into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the cycle heat warning
    BSR     WAIT_KEY                        ; Wait for user to press enter
    BSR     NEW_LINE                        ; Move to next line
SKIP_BONUS_MSG:

    ; Apply wanted heat penalty if active then clear it
    MOVE.W  WANTED,         D2              ; Load wanted flag into D2
    CMP.W   #1,             D2              ; Is wanted flag set?
    BNE     SKIP_WANTED                     ; Branch if not wanted
    ADD.W   #15,            D1              ; Add wanted heat penalty of 15
    MOVE.W  #0,             WANTED          ; Clear wanted flag after applying penalty
SKIP_WANTED:
    MOVE.W  D1,             HEAT            ; Store the final heat value

    ADD.W   #10,            REP             ; Add 10 reputation points for success

    LEA     REWARD_MSG,     A1              ; Load address of reward label into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the reward label
    MOVE.W  HEIST_REWARD,   D1              ; Load the reward amount into D1
    MOVE.B  #3,             D0              ; Set trap task 3 to print number
    TRAP    #15                             ; Print the reward amount
    BSR     NEW_LINE                        ; Move to next line

    ; Increment heist counter and check for new cycle
    ADD.W   #1,             HEISTS_DONE     ; Count this successful heist
    MOVE.W  HEISTS_DONE,    D1              ; Load heist count into D1
    CMP.W   #3,             D1              ; Have 3 heists been completed?
    BLT     SKIP_CYCLE                      ; Branch if not yet at 3

    ; New cycle reached
    MOVE.W  #0,             HEISTS_DONE     ; Reset heist counter for new cycle
    ADD.W   #1,             CYCLE           ; Increment cycle number
    ADD.W   #15,            HEAT_BONUS      ; Increase heat bonus by 15 for new cycle
    LEA     CYCLE_UP_MSG,   A1              ; Load address of cycle up message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the new cycle message
    BSR     NEW_LINE                        ; Move to next line

SKIP_CYCLE:
    BSR     ROLL_EVENT                      ; Call trigger a random post-heist event
    BSR     WAIT_KEY                        ; Wait for player to read result before continuing
    RTS                                     ; Return after all win logic done

*-----------------------------------------------------------
* Subroutine : HEIST_BUST
* Description: Handles a failed heist - checks if heavy load
*              caused the failure and shows relevant message,
*              loses a crew member and adds heat
*-----------------------------------------------------------
HEIST_BUST:
    BSR     NEW_LINE                        ; Call print a blank line

    ; Pick fail message based on whether load was heavy
    MOVE.W  LOAD,           D1              ; Load current load value into D1
    CMP.W   #300,           D1              ; Was load 300 or more (heavy)?
    BGE     BUST_LOAD_MSG                   ; Branch to show load specific message
    LEA     FAIL_MSG,       A1              ; Load address of generic fail message into A1
    BRA     BUST_PRINT                      ; Jump to print

BUST_LOAD_MSG:
    LEA     LOAD_FAIL_MSG,  A1              ; Load address of load fail message into A1

BUST_PRINT:
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print whichever fail message was chosen

    MOVE.W  CREW,           D1              ; Load current crew count into D1
    SUB.W   #1,             D1              ; Lose one crew member
    MOVE.W  D1,             CREW            ; Store updated crew count
    MOVE.W  #1,             WANTED          ; Set wanted flag, police have your description

    MOVE.W  HEAT,           D1              ; Load current heat into D1
    ADD.W   HEIST_HEAT,     D1              ; Add base heat from the target
    ADD.W   #10,            D1              ; Add extra heat penalty for failing
    MOVE.W  D1,             HEAT            ; Store the updated heat value

    LEA     CREW_LOST_MSG,  A1              ; Load address of crew lost message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the crew lost message
    BSR     NEW_LINE                        ; Move to next line
    
    LEA     NOW_WANTED_MSG, A1              ; Load the message telling user that they are now wanted
    MOVE.B  #14,            D0              ; Set teap task 14 to print string
    TRAP    #15                             ; Print the now wanted message
    
    BSR     WAIT_KEY                        ; Wait for player to read result before continuing
    RTS                                     ; Return after fail logic done

*-----------------------------------------------------------
* Subroutine : ROLL_EVENT
* Description: Rolls a random number to pick one of four
*              post-heist events and applies its effect
*              1-25  = silent alarm  heat +10
*              26-50 = inside man    cash +100
*              51-75 = clean run     no effect
*              76+   = witness       heat +15
*-----------------------------------------------------------
ROLL_EVENT:
    BSR     ROLL_DICE                       ; Call get random number 1-100 into D1

    CMP.W   #25,            D1              ; Is roll 25 or under?
    BLE     EVENT_ALARM                     ; Branch to silent alarm event

    CMP.W   #50,            D1              ; Is roll 26-50?
    BLE     EVENT_INSIDE_MAN                ; Branch to inside man event

    CMP.W   #75,            D1              ; Is roll 51-75?
    BLE     EVENT_CLEAN                     ; Branch to clean getaway event

    BRA     EVENT_WITNESS                   ; Roll 76-100 goes to witness event

EVENT_ALARM:
    LEA     EVENT_ALARM_MSG, A1             ; Load address of alarm event text into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the alarm event message
    ADD.W   #10,            HEAT            ; Raise heat by 10 for the alarm
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after event handled

EVENT_INSIDE_MAN:
    LEA     EVENT_INSIDE_MSG, A1            ; Load address of inside man event text into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the inside man message
    ADD.W   #100,           CASH            ; Add $100 cash bonus from inside man
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after event handled

EVENT_CLEAN:
    LEA     EVENT_CLEAN_MSG, A1             ; Load address of clean run event text into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the clean run message
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after event handled

EVENT_WITNESS:
    LEA     EVENT_WITNESS_MSG, A1           ; Load address of witness event text into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the witness message
    ADD.W   #15,            HEAT            ; Raise heat by 15 for the witness
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after event handled

*-----------------------------------------------------------
* Subroutine : BUY_GEAR
* Description: Spends $100 to raise gear level by 1.
*              Gear is capped at level 5.
*              Checks cash before allowing purchase.
*-----------------------------------------------------------
BUY_GEAR:
    MOVE.W  GEAR,           D1              ; Load current gear level into D1
    CMP.W   #5,             D1              ; Is gear already at max level 5?
    BGE     GEAR_MAXED                      ; Branch if already maxed out

    MOVE.W  CASH,           D1              ; Load current cash into D1
    CMP.W   #GEAR_COST,     D1              ; Is cash enough to cover gear cost?
    BLT     NO_CASH                         ; Branch if not enough cash

    SUB.W   #GEAR_COST,     CASH            ; Deduct gear cost from cash
    ADD.W   #1,             GEAR            ; Increase gear level by 1

    LEA     GEAR_UPGRADE_MSG, A1            ; Load address of gear upgrade message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the upgrade confirmation
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after upgrade handled

GEAR_MAXED:
    LEA     GEAR_MAX_MSG,   A1              ; Load address of gear max message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print gear already maxed message
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after message printed

*-----------------------------------------------------------
* Subroutine : HIRE_UP
* Description: Spends $150 to add one crew member.
*              Crew is capped at 5 members.
*              Checks cash before allowing hire.
*-----------------------------------------------------------
HIRE_UP:
    MOVE.W  CREW,           D1              ; Load current crew count into D1
    CMP.W   #5,             D1              ; Is crew already at max size 5?
    BGE     CREW_MAXED                      ; Branch if already maxed out

    MOVE.W  CASH,           D1              ; Load current cash into D1
    CMP.W   #CREW_COST,     D1              ; Is cash enough to cover crew cost?
    BLT     NO_CASH                         ; Branch if not enough cash

    SUB.W   #CREW_COST,     CASH            ; Deduct crew cost from cash
    ADD.W   #1,             CREW            ; Add one crew member

    LEA     CREW_HIRED_MSG, A1              ; Load address of crew hired message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the hire confirmation
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after hire handled

CREW_MAXED:
    LEA     CREW_MAX_MSG,   A1              ; Load address of crew max message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print crew already maxed message
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after message printed

*-----------------------------------------------------------
* Subroutine : PAY_BRIBE
* Description: Spends $200 to reduce heat by 20.
*              Heat is clamped so it cannot go below 0.
*              Checks cash before allowing bribe.
*-----------------------------------------------------------
PAY_BRIBE:
    MOVE.W  CASH,           D1              ; Load current cash into D1
    CMP.W   #BRIBE_COST,    D1              ; Is cash enough to cover bribe cost?
    BLT     NO_CASH                         ; Branch if not enough cash

    SUB.W   #BRIBE_COST,    CASH            ; Deduct bribe cost from cash

    MOVE.W  HEAT,           D1              ; Load current heat into D1
    SUB.W   #20,            D1              ; Reduce heat by 20
    CMP.W   #0,             D1              ; Has heat gone below zero?
    BGE     BRIBE_STORE                     ; Branch if heat is still zero or above
    MOVE.W  #0,             D1              ; Clamp heat to zero minimum

BRIBE_STORE:
    MOVE.W  D1,             HEAT            ; Store the updated heat value

    LEA     BRIBE_MSG,      A1              ; Load address of bribe confirmation into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the bribe confirmation
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after bribe handled

*-----------------------------------------------------------
* Subroutine : LAY_LOW
* Description: Sacrifice two crew members to reset heat to 0
*              and clear wanted status. Unavailable if crew
*              is 2 or below as you cannot lose your last crew.
*-----------------------------------------------------------
LAY_LOW:
    MOVE.W  CREW,           D1              ; Load current crew count into D1
    CMP.W   #2,             D1              ; Is crew 2 or less?
    BLE     LAYLOW_NO_CREW                  ; Branch if not enough crew to sacrifice

    SUB.W   #2,             CREW            ; Lose two crew members to lay low
    MOVE.W  #0,             HEAT            ; Reset heat to zero
    MOVE.W  #0,             WANTED          ; Clear wanted status

    LEA     LAYLOW_MSG,     A1              ; Load address of lay low message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the lay low confirmation
    BSR     WAIT_KEY                        ; Wait for user input
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after lay low handled

LAYLOW_NO_CREW:
    LEA     LAYLOW_FAIL_MSG, A1             ; Load address of lay low fail message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the not enough crew message
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return after message printed

*-----------------------------------------------------------
* Subroutine : NO_CASH
* Description: Prints a not enough cash message
*-----------------------------------------------------------
NO_CASH:
    LEA     NO_CASH_MSG,    A1              ; Load address of no cash message into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the no cash message
    BSR     NEW_LINE                        ; Move to next line
    RTS                                     ; Return to caller

*-----------------------------------------------------------
* Subroutine : ROLL_DICE
* Description: Returns a pseudo-random number 1-100 in D1
*              Uses the system random number trap 
*-----------------------------------------------------------
ROLL_DICE:
    MOVE.B  #8,             D0              ; Set trap task 8 to get a random number
    TRAP    #15                             ; System fills D1 with a random value
    AND.L   #$5FFFFF,       D1              ; Mask D1 to limit the raw random range
    DIVU    #100,           D1              ; Divide by 100, remainder lands in upper word
    SWAP    D1                              ; Swap words to bring remainder into lower word
    ADDQ.W  #1,             D1              ; Add 1 to shift range from 0-99 to 1-100
    MOVE.W  D1,             D2              ; Save the result in D2 temporarily
    CLR.L   D1                              ; Clear D1 fully before restoring result
    MOVE.W  D2,             D1              ; Move final 1-100 result back into D1
    RTS                                     ; Return with result in D1

*-----------------------------------------------------------
* Subroutine : CALC_LOAD
* Description: Calculates load per crew member (CASH / CREW)
*              and stores result in LOAD memory variable.
*              Higher load = slower crew = lower success chance.
*              Under 150 = light, 150-299 = moderate, 300+ = heavy
*-----------------------------------------------------------
CALC_LOAD:
    CLR.L   D1                              ; Clear D1 fully before use
    MOVE.W  CASH,           D1              ; Load cash value into lower word of D1
    CLR.L   D2                              ; Clear D2 fully before use
    MOVE.W  CREW,           D2              ; Load crew count into D2
    DIVU    D2,             D1              ; Divide D1 (cash) by D2 (crew)
    AND.L   #$FFFF,         D1              ; Clear remainder in upper word, keep quotient
    MOVE.W  D1,             LOAD            ; Store the load per crew member
    RTS                                     ; Return with LOAD updated

*-----------------------------------------------------------
* Subroutine : WAIT_KEY
* Description: Prints a prompt and waits for player to
*              press enter before continuing
*-----------------------------------------------------------
WAIT_KEY:
    LEA     ANYKEY_MSG,     A1              ; Load address of press enter prompt into A1
    MOVE.B  #14,            D0              ; Set trap task 14 to print string
    TRAP    #15                             ; Print the press enter prompt
    MOVE.B  #4,             D0              ; Set trap task 4 to read a number
    TRAP    #15                             ; Wait for player to press enter
    RTS                                     ; Return after input received

*-----------------------------------------------------------
* Subroutine : NEW_LINE
* Description: Prints a newline (carriage return + line feed)
*              Saves and restores D0 and A1 via stack
*-----------------------------------------------------------
NEW_LINE:
    MOVEM.L D0/A1,          -(A7)           ; Push D0 and A1 onto stack to save them
    MOVE    #14,            D0              ; Set trap task 14 to print string
    LEA     CRLF,           A1              ; Load address of newline characters into A1
    TRAP    #15                             ; Print the newline
    MOVEM.L (A7)+,          D0/A1           ; Pop D0 and A1 back from stack
    RTS                                     ; Return to caller

*-----------------------------------------------------------
* Section: Message Strings
*-----------------------------------------------------------
CRLF            DC.B    $0D,$0A,0           ; Carriage return and line feed characters

WELCOME_MSG     DC.B    '============================================',$0D,$0A
                DC.B    '              THE HEIST                     ',$0D,$0A
                DC.B    '============================================',$0D,$0A
                DC.B    'You are a thief.',$0D,$0A
                DC.B    'Build your crew and upgrade your gear.',$0D,$0A
                DC.B    'Pull off heists to earn cash and reputation.',$0D,$0A
                DC.B    'Watch your heat - the police are watching.',$0D,$0A
                DC.B    'GAME OVER if heat hits 100 or crew hits 0.',$0D,$0A
                DC.B    '============================================',$0D,$0A,0

MENU_MSG        DC.B    '--- YOUR NEXT MOVE ---',$0D,$0A
                DC.B    $0D,$0A
                DC.B    '  YOUR NEXT MOVE',$0D,$0A
                DC.B    '  1. PLAN A HEIST',$0D,$0A
                DC.B    $0D,$0A
                DC.B    '  SPEND MONEY',$0D,$0A
                DC.B    '  2. UPGRADE GEAR    $100',$0D,$0A
                DC.B    '  3. HIRE CREW       $150',$0D,$0A
                DC.B    '  4. BRIBE POLICE    $200  (-20 HEAT)',$0D,$0A
                DC.B    $0D,$0A
                DC.B    '  DAMAGE CONTROL',$0D,$0A
                DC.B    '  5. LAY LOW         2 CREW  (RESETS HEAT + WANTED)',$0D,$0A
                DC.B    $0D,$0A
                DC.B    '  0. QUIT',$0D,$0A
                DC.B    $0D,$0A
                DC.B    'ENTER CHOICE: ',0

HEIST_MENU_MSG  DC.B    '--- CHOOSE YOUR TARGET ---',$0D,$0A
                DC.B    '1. CORNER SHOP     LOW RISK  REWARD $200  HEAT +15  GEAR 1+',$0D,$0A
                DC.B    '2. JEWELLERY STORE MED RISK  REWARD $350  HEAT +30  GEAR 2+',$0D,$0A
                DC.B    '3. BANK VAULT      HIGH RISK REWARD $700  HEAT +50  GEAR 4+',$0D,$0A
                DC.B    $0D,$0A
                DC.B    'LOAD GUIDE: UNDER 150=LIGHT  150-299=MODERATE  300+=HEAVY',$0D,$0A
                DC.B    $0D,$0A
                DC.B    'ENTER CHOICE: ',0

HUD_HEADER      DC.B    '=== YOUR STATUS ===',0
HUD_MONEY       DC.B    '  MONEY',0                 
HUD_CREW        DC.B    '  YOUR CREW',0             
HUD_HEAT        DC.B    '  HEAT',0                 
CASH_MSG        DC.B    'CASH  : $',0
CREW_MSG        DC.B    'CREW  :  ',0                  
GEAR_MSG        DC.B    'GEAR  :  ',0
HEAT_MSG        DC.B    'HEAT  :  ',0
REP_MSG         DC.B    'REP   :  ',0
DIVIDER         DC.B    '======================',0

SHOP_MSG        DC.B    $0D,$0A        
                DC.B    'TARGET: CORNER SHOP. STAY CALM AND MOVE FAST.'
                DC.B    $0D,$0A ,0
JEWEL_MSG       DC.B    $0D,$0A 
                DC.B    'TARGET: JEWELLERY STORE. LASERS AND GUARDS.'
                DC.B    $0D,$0A ,0
BANK_MSG        DC.B    $0D,$0A 
                DC.B    'TARGET: BANK VAULT. THE BIG ONE. NO MISTAKES!'
                DC.B    $0D,$0A ,0

WANTED_MSG      DC.B    'WANTED:  ',0
CYCLE_MSG       DC.B    'CYCLE :  ',0
CYCLE_UP_MSG    DC.B    'CYCLE COMPLETE! HEAT INCREASING NEXT CYCLE.',0
HEAT_BONUS_MSG  DC.B    'CYCLE HEAT BONUS APPLIED - POLICE ARE CATCHING ON.'
                DC.B    $0D,$0A ,0
LAYLOW_MSG      DC.B    'YOU GO DARK. HEAT GONE, TWO CREW MEMBERS LEAVE.'
                DC.B    $0D,$0A ,0
LAYLOW_FAIL_MSG DC.B    'CANNOT LAY LOW WITHOUT AT LEAST 3 CREW MEMBERS.',0
LOAD_MSG        DC.B    'LOAD  :  ',0 
NOW_WANTED_MSG  DC.B    'YOU ARE NOW WANTED! HEAT +15 NEXT HEIST.'
                DC.B    $0D,$0A ,0

EXECUTING_MSG   DC.B    'EXECUTING HEIST...'
                DC.B    $0D,$0A ,0
SUCCESS_MSG     DC.B    'SUCCESS! CLEAN GETAWAY!'
                DC.B    $0D,$0A ,0
FAIL_MSG        DC.B    'BUSTED! YOU BARELY ESCAPED!'
                DC.B    $0D,$0A ,0
LOW_GEAR_MSG    DC.B    'YOUR GEAR IS NOT GOOD ENOUGH FOR THIS TARGET!'
                DC.B    $0D,$0A ,0
REWARD_MSG      DC.B    'CASH EARNED: $',0
CREW_LOST_MSG   DC.B    'YOU LOST A CREW MEMBER IN THE CHAOS.'
                DC.B    $0D,$0A ,0

EVENT_ALARM_MSG  DC.B   'EVENT: SILENT ALARM TRIGGERED! HEAT +10',0
EVENT_INSIDE_MSG DC.B   'EVENT: INSIDE MAN TIPS YOU OFF! BONUS $100',0
EVENT_CLEAN_MSG  DC.B   'EVENT: PERFECT EXECUTION. NO WITNESSES.',0
EVENT_WITNESS_MSG DC.B  'EVENT: A WITNESS SPOTTED THE CREW! HEAT +15',0

GEAR_UPGRADE_MSG DC.B   'GEAR UPGRADED. YOUR CREW IS BETTER EQUIPPED.',0
GEAR_MAX_MSG    DC.B    'GEAR IS ALREADY AT MAXIMUM LEVEL (5).',0
CREW_HIRED_MSG  DC.B    'NEW CREW MEMBER RECRUITED.',0
CREW_MAX_MSG    DC.B    'CREW IS ALREADY AT MAXIMUM SIZE (5).',0
BRIBE_MSG       DC.B    'POLICE BRIBED. HEAT REDUCED BY 20.',0
NO_CASH_MSG     DC.B    'NOT ENOUGH CASH FOR THAT.',0
INVALID_MSG     DC.B    'INVALID INPUT. PLEASE TRY AGAIN.',0

LOSE_HEAT_MSG   DC.B    'THE POLICE HAVE RAIDED YOUR HIDEOUT!',$0D,$0A
                DC.B    'EVERYONE IS ARRESTED. GAME OVER.',0
LOSE_CREW_MSG   DC.B    'YOUR ENTIRE CREW HAS BEEN CAUGHT!',$0D,$0A
                DC.B    'OPERATION OVER. GAME OVER.',0
GAME_OVER_MSG   DC.B    '============================================',$0D,$0A
                DC.B    '                GAME OVER                   ',$0D,$0A
                DC.B    '============================================',0
FINAL_REP_MSG   DC.B    'FINAL REPUTATION SCORE: ',0
LOAD_FAIL_MSG   DC.B    'CREW TOO WEIGHED DOWN BY THE HAUL TO ESCAPE!',0
REPLAY_MSG      DC.B    'ENTER 1 TO PLAY AGAIN, 0 TO QUIT: ',0
ANYKEY_MSG      DC.B    'PRESS ENTER TO CONTINUE: ',0

*-----------------------------------------------------------
* Section: Memory Reservations
*-----------------------------------------------------------
CASH            DS.W    1       ; Player cash total
CREW            DS.W    1       ; Number of crew members (0-5)
LOAD            DS.W    1       ; Load per crew member (CASH divided by CREW)
GEAR            DS.W    1       ; Gear level (1-5)
HEAT            DS.W    1       ; Police heat level (0-100)
REP             DS.W    1       ; Reputation score
HEIST_REWARD    DS.W    1       ; Cash reward for the current heist
HEIST_HEAT      DS.W    1       ; Heat gain for the current heist
HEIST_MIN_GEAR  DS.W    1       ; Minimum gear required for the current heist
WANTED          DS.W    1       ; 1 = police have crew description, 0 = clear
HEISTS_DONE     DS.W    1       ; Successful heists completed in current cycle
CYCLE           DS.W    1       ; Current endless mode cycle number
HEAT_BONUS      DS.W    1       ; Extra heat added per heist each cycle

        END     START           ; Mark end of program, begin execution at START


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
