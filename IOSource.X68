*-----------------------------------------------------------
* Title      : IO
* Written by : Team Schmos
* Date       :
* Description: This is the file for handling IO
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program
    LEA     STARTADDMESS, A1      *take starting address
    MOVE.B  #14, D0
    TRAP    #15

    MOVE.B  #2, D0
    TRAP    #15

    JSR     CHECKVALUES
    MOVE.L  A1, BEGIN
    CLR.L   D4

    LEA     ENDADDMESS, A1      *take starting address
    MOVE.B  #14, D0
    TRAP    #15

    MOVE.B  #2, D0
    TRAP    #15

    JSR     CHECKVALUES
    MOVE.L  A1, LAST

    MOVE.L  BEGIN, A5
    MOVE.L  LAST, A6

ADDLOOP: *loops through address and passes word data into D7
    CMP.L   A5,A6
    BLE     DONE


    LEA     DISP_NL,A1
    MOVE.B  #14,D0
    TRAP    #15
    MOVE.L  A5, D1        *take starting address
    MOVE.B  #15, D0
    MOVE.B  #16, D2
    TRAP    #15
    
    LEA     DISP_TAB,A1
    MOVE.B  #14, D0
    TRAP    #15
    
    MOVE.W  (A5)+, D7
    JSR     OPCODE              *Handles all of the first word logic
    

    JMP     ADDLOOP

DONE
    SIMHALT


CHECKVALUES *not less than 1 or greater than 8

    CMP.L     #1, D1          *if the address length is less than 1, error
    BLT     ERRADD2

    CMP.L     #8, D1          *if the address length is greater than 8, error
    BGT     ERRADD2

    JSR     CONVERTLOOP

    MOVEA.L D4, A1
    LSR.B   #1, D4          *check to see if the address is even
    BCS     INVALID
    RTS


INVALID
    LEA     ERRADD, A1          *take starting address
    MOVE.B  #14, D0
    TRAP    #15
    JMP     START

CONVERTLOOP

            CMP         #0,D1           ; IS LOOP DONE?
            BEQ         CONVDONE
            MOVE.B      (A1)+,D2        ; COPY BYTE AND INCREMENT REGISTER
            JSR         CONVERT         ; CONVERT TO HEX
            LSL.L       #4,D4           ; MAKE ROOM FOR NEXT BYTE
            ADD.B       D2,D4
            SUBQ.B      #1,D1           ; DECREMENT COUNTER
            JMP         CONVERTLOOP


CONVERT
            CMP.B       #$39,D2         ; compare 39 ASCII #9
            BGT         LETTER          ; if greater than it is a letter
            SUB.B       #$30,D2         ; Subtract 30 for HEX number
            RTS

LETTER      SUB.B       #$37,D2         ; Subtract 37 for HEX letter
            RTS

CONVDONE    MOVE.L      D4,D5
            RTS


*-----------------------------------------------------------
* Title      : Opcodes
* Written by : Team Schmos
* Date       :
* Description: This is the file for handling OPCODES
*-----------------------------------------------------------
stack       EQU      $A000

OPCODE      LEA         stack,SP        *Load the SP
            LEA         jmp_table,A0    *Index into the table
            CLR.L       D0              *Zero it
            
            *For bits 12 -> 15
            MOVE.W      D7,D0     *We'll play with it here
            MOVE.B      #12,D1          *Shift 12 bits to the right
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,TWEL_FIF

            *For bits 9 -> 11
            CLR.L       D0              *Zero it
            MOVE.W      D7,D0           *We'll play with it here
            MOVE.B      #4,D1           *Shift 12 bits to the right
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #13,D1          *Shift 12 bits to the right
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,NINE_ELE

            *For bits 9 -> 12
            CLR.L       D0              *Zero it
            MOVE.W      D7,D0           *We'll play with it here
            MOVE.B      #4,D1           *Shift 12 bits to the right
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #12,D1          *Shift 12 bits to the right
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,CONDITION

            *For bits 6 -> 8
            CLR.L       D0              *Zero it
            MOVE.W      D7,D0           *We'll play with it here
            MOVE.B      #7,D1           *Shift 12 bits to the right
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #13,D1          *Shift 12 bits to the right
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,SIX_EIGT

            *For bits 3 -> 5
            CLR.L       D0              *Zero it
            MOVE.W      D7,D0           *We'll play with it here
            MOVE.B      #10,D1          *Shift 12 bits to the right
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #13,D1          *Shift 12 bits to the right
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,TREE_FIV

            *For bits 0 -> 2
            CLR.L       D0              *Zero it
            MOVE.W      D7,D0           *We'll play with it here
            MOVE.B      #13,D1          *Shift 12 bits to the right
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #13,D1          *Shift 12 bits to the right
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,ZERO_TWO

            *jump table section takes bits 12->15 and jumps to appropriate subroutine            CLR         D0
            MOVE.B      TWEL_FIF,D0
            MULU        #6,D0          *Form offset
            JSR         0(A0,D0)       *Jump indirect with index
            
           * Loading the mode bits into D2, registers into D3
            JSR         PRINTSPACE
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            
            * Currently loading the mode into D2, registers into D3 NEED TO ADD CHECK BEFORE JUMPING TO EA
            LEA         DISP_COMMA,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.B      SIX_EIGT,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA
            JMP         ADDLOOP
            
*This jump table will jump to a subroutine with the matching first 4 bits in the opcode of the read instruction.

jmp_table   JMP         code0000       *for jumping to a specific instruction
            JMP         code0001
            JMP         code0010
            JMP         code0011
            JMP         code0100
            JMP         code0101
            JMP         code0110
            JMP         code0111
            JMP         code1000
            JMP         code1001
            JMP         code1010
            JMP         code1011
            JMP         code1100
            JMP         code1101
            JMP         code1110
            JMP         code1111

code0000

* Handles MOVEA.B, MOVE.B
code0001
            LEA         DISP_MOVE,A1
            MOVE.B      #1, D0
            TRAP        #15
            CMP.B       #1,SIX_EIGT      *checking if bits 6-8 equal one if yes its a movea
            BEQ         MOVEAB
            BRA         SIZEB

MOVEAB      LEA         DISP_MOVE_A,A1
            TRAP        #15
            RTS
 
* Handles MOVEA.L, MOVE.L
code0010
            LEA         DISP_MOVE,A1
            MOVE.B      #1, D0
            TRAP        #15
            CMP.B       #1,SIX_EIGT
            BEQ         MOVEAL
            BRA         MOVEL

MOVEAL      LEA         DISP_MOVE_A,A1
            TRAP        #15

MOVEL       LEA         DISP_SIZE_L,A1
            TRAP        #15
            RTS


* Handles MOVEA.W, MOVE.W
code0011
            LEA         DISP_MOVE,A1
            MOVE.B      #1, D0
            TRAP        #15
            CMP.B       #1,SIX_EIGT
            BEQ         MOVEAW
            BRA         MOVEW

MOVEAW      LEA         DISP_MOVE_A,A1
            TRAP        #15

MOVEW       LEA         DISP_SIZE_W,A1
            TRAP        #15
            RTS

code0100
            MOVE.B      #1,D0

            MOVE.B      CONDITION,D3
            LSR.B       #1,D3
            BCS         ISLEA           *JUMPS TO LEA OPCODE

            LSR.B       #1,D3
            BCC         ISMOVEM         *JUMPS TO MOVEM OPCODE

            LSL.B       #7,D3
            BCC         ISNOT           *JUMPS TO NOT OPCODE

            MOVE.B      SIX_EIGT,D3
            LSR.B       #2, D3
            BCS         ISJSR           *JUMPS TO JSR OPCODE

            MOVE.B      ZERO_TWO,D3
            CMP.B       #1,D3
            BEQ         ISNOP           *JUMPS TO NOP OPCODE

            BRA         ISRTS           *DEFAULTS TO RTS

ISLEA
            LEA         DISP_LEA, A1
            TRAP        #15
            
            JSR         PRINTSPACE
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            LEA         DISP_COMMA,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.B      #1,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA
            JMP         ADDLOOP
            RTS

ISMOVEM
            LEA         DISP_MOVEM, A1
            TRAP        #15
            RTS
ISNOT
            LEA         DISP_NOT, A1
            TRAP        #15
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         PRINTSPACE
            JSR         EA
            JMP         ADDLOOP
ISJSR
            LEA         DISP_JSR, A1
            TRAP        #15
            RTS
ISNOP
            LEA         DISP_NOP, A1
            TRAP        #15
            JMP         ADDLOOP
ISRTS
            LEA         DISP_RTS, A1
            TRAP        #15
            JMP         ADDLOOP

* Handles ADDQ
code0101
            LEA         DISP_ADDQ,A1
            MOVE.B      #1, D0
            TRAP        #15

            MOVE.B      SIX_EIGT,D0
            LSR.B       #1,D0                *If first bit is one its word. Second a long
            BCS         SIZEW
            LSR.B       #1,D0
            BCS         SIZEL               
            BRA         SIZEB               *IF NONE OF THESE WE DEFAULT TO ADDQ.B

* Handles Bcc operations
code0110
            MOVE.B      #1, D0
            MOVE.B      CONDITION,D2
            CMP         #0,D2
            BEQ         ISBRA
            CMP         #15,D2
            BEQ         ISLE
            CMP         #7,D2
            BEQ         ISEQ
            CMP         #14,D2
            BEQ         ISGT

            LEA         DISP_BLE,A1
            TRAP        #15
            RTS

ISBRA
            LEA         DISP_BRA,A1
            TRAP        #15
            RTS

ISLE
            LEA         DISP_BLE,A1
            TRAP        #15
            RTS

ISGT
            LEA         DISP_BGT,A1
            TRAP        #15
            RTS

ISEQ
            LEA         DISP_BEQ,A1
            TRAP        #15
            RTS

* Handles MOVEQ
code0111
            LEA         DISP_MOVEQ, A1
            MOVE.B      #1, D0
            TRAP        #15
            RTS

* Handles OR, DIV operations
code1000
            MOVE.B      SIX_EIGT, D2
            CMP.B       #3, D2
            BEQ         ISDIV

            CLR         D0
            LEA         DISP_OR, A1
            MOVE.B      #1, D0
            TRAP        #15

            LSR.B       #1, D2               *If first bit is one its word. Second a long
            BCS         JUMPW
            LSR.B       #1, D2
            BCS         JUMPL
            BRA         JUMPB                 *DEFAULT TO BYTE


ISDIV       LEA         DISP_DIVU,A1
            MOVE.B      #1, D0
            TRAP        #15
            LEA         DISP_SIZE_W,A1
            TRAP        #15
            RTS
            
* Handles SUB
code1001
            LEA         DISP_SUB,A1
            MOVE.B      #1, D0
            TRAP        #15

            MOVE.B      SIX_EIGT,D0
            LSR.B       #1,D0                *If first bit is one its word. Second a long
            BCS         JUMPW      
            LSR.B       #1,D0
            BCS         JUMPL      
            BRA         JUMPB      
          

* Unassigned
code1010

* Unassigned
code1011

* Handles AND, MUL
code1100
            MOVE.B      SIX_EIGT, D2
            CMP.B       #7, D2
            BEQ         ISMUL

            CLR         D0
            LEA         DISP_AND, A1
            MOVE.B      #1, D0
            TRAP        #15

            LSR.B       #1, D2               *If first bit is one its word. Second a long
            BCS         JUMPW
            LSR.B       #1, D2
            BCS         JUMPL
            BRA         JUMPB


ISMUL       LEA         DISP_MULS,A1
            MOVE.B      #1, D0
            TRAP        #15
            LEA         DISP_SIZE_W,A1
            TRAP        #15
            RTS

* Handles ADD, ADDA
code1101
            MOVE.B      SIX_EIGT, D2
            CMP.B       #7, D2
            BEQ         ISADDA
            CMP.B       #3, D2
            BEQ         ISADDA

            CLR         D0
            LEA         DISP_ADD, A1
            MOVE.B      #1, D0
            TRAP        #15

            LSR.B       #1, D2               *If first bit is one its word. Second a long
            BCS         JUMPW       
            LSR.B       #1, D2
            BCS         JUMPL
            BRA         JUMPB
 
*FOR ADD: If the opmode is < 4 then it is add EA,reg. If opmode >= 4 reg(num),EA

ISADDA      LEA         DISP_ADDA,A1
            MOVE.B      #1, D0
            TRAP        #15
            CMP         #3, D2
            BEQ         ADDAW

            LEA         DISP_SIZE_L,A1
            TRAP        #15
            
            *ADDA HAS DIFFERENT LOGIC FOR EA SO CALLING FROM HERE INSTEAD OF ADDLOOP
ADDAEA      MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         PRINTSPACE
            JSR         EA
            LEA         DISP_COMMA,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.B      #1,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA
            JMP         ADDLOOP        

ADDAW       LEA         DISP_SIZE_W,A1
            TRAP        #15
            JMP         ADDAEA
 

*A* Handles shift operations
code1110    
            MOVE.B      SIX_EIGT, D2
            LSL.B       #7, D2
            BCS         CHECKNXTBIT
            BRA         ISREGSHIFT

CHECKNXTBIT LSL.B      #1, D2
            BCS        ISMEMSHIFT
            BRA        ISREGSHIFT

ISMEMSHIFT MOVE.B       NINE_ELE, D2
           MOVE.B       #1, MEMORREG        *IF MEMORY SHIFT SET MEMORREG TO 1
           LSR.B        #1, D2
           BCS          ISLSHIFT
           BRA          ISASHIFT

ISREGSHIFT MOVE.B       TREE_FIV,D2
           MOVE.B       #0, MEMORREG        *IF MEMORY SHIFT SET MEMORREG TO 0
           LSR.B        #1, D2
           BCS          ISLSHIFT
           BRA          ISASHIFT

ISLSHIFT    *CHECK DIRECTION AND DISPLAY
            MOVE.B      SIX_EIGT, D2
            LSL.B       #6, D2
            BCS         ISLSL

            *DISPLAY RIGHT SHIFT
            LEA         DISP_LSR,A1
            MOVE.B      #1,D0
            TRAP        #15
            JSR         CHECKMEMORREG
            JMP         REGORNUML

ISLSL       LEA         DISP_LSL,A1
            MOVE.B      #1,D0
            TRAP        #15
            JSR         CHECKMEMORREG
            JMP         REGORNUML

            *CHECKING DIRECTION AND SIZE
ISASHIFT    MOVE.B      SIX_EIGT, D2
            LSL.B       #6, D2
            BCS         ISASL

            LEA         DISP_ASR,A1        *IF NOT ASL. ASR
            MOVE.B      #1,D0
            TRAP        #15
            JSR         CHECKMEMORREG
            JMP         REGORNUM

ISASL       LEA         DISP_ASL,A1
            MOVE.B      #1,D0
            TRAP        #15
            JSR         CHECKMEMORREG
            JMP         REGORNUM

CHECKMEMORREG
            CLR.L       D4
            MOVE.B      MEMORREG, D4
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            CMP         #1, D4
            BEQ         SHIFTEA
            JSR         S_SIZE
            JSR         PRINTSPACE 
            RTS

S_SIZE      LSL.B       #1, D2
            BCS         SIZEL
            LSL.B       #1, D2
            BCS         SIZEW
            BRA         SIZEB
            
REGORNUML    *IS THIS A REGISTER OR A NUMBER SHIFT??
            MOVE.B      TREE_FIV,D6
            CMP         #5,D6
            BLT         NUM
            MOVE.B      #0,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA         
            JMP         SECPART

REGORNUM    *IS THIS A REGISTER OR A NUMBER SHIFT??
            CMP         #4,TREE_FIV
            BLT         NUM
            MOVE.B      #0,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA         
            JMP         SECPART
            
NUM         CLR         D1
            LEA         DISP_HASH,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.B      NINE_ELE,D1
            MOVE.B      #3,D0
            TRAP        #15      
            
SECPART     
            LEA         DISP_COMMA,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.B      #0,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            JMP         ADDLOOP
            
SHIFTEA     JSR         SIZEW
            JSR         PRINTSPACE
            JSR         EA
            JMP         ADDLOOP
            
 

* Reserved of SIMHALT
code1111

JUMPW       JSR         SIZEW   
            JMP         WHICHONE
 
JUMPL       JSR         SIZEL           
            JMP         WHICHONE
 
JUMPB       JSR         SIZEB
            JMP         WHICHONE

WHICHONE    JSR         PRINTSPACE
            MOVE.B      SIX_EIGT,D6
            CMP         #4,D6
            BLT         EAFIRST
      
            MOVE        #0,D2               *EA is second in this scenario
            MOVE.B      NINE_ELE,D3
            JSR         EA
            LEA         DISP_COMMA,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            JMP         ADDLOOP           

EAFIRST            
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA            
            LEA         DISP_COMMA,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE        #0,D2               *EA is second in this scenario
            MOVE.B      NINE_ELE,D3
            JSR         EA
            JMP         ADDLOOP

SIZEW       LEA         DISP_SIZE_W, A1
            MOVE.B      #14,D0
            TRAP        #15
            RTS

SIZEL       LEA         DISP_SIZE_L,A1
            MOVE.B      #14,D0
            TRAP        #15
            RTS

SIZEB       LEA         DISP_SIZE_B,A1
            MOVE.B      #14,D0
            TRAP        #15
            RTS

*-----------------------------------------------------------
* Title      : EA
* Written by : Team Schmos
* Date       :
* Description: EA
*-----------------------------------------------------------

EA *handles effective addressing
    *Mode bits are loaded into D2
    *Register bits are loaded into D3
            CLR.L       D1
            CMP         #7,D2       *CHECK FOR REGISTER OPERAND
            BEQ         NOTREG
            CMP         #0,D2
            BEQ         DREG        *CHECK FOT DATA REGISTER OPERAND
            CMP         #1,D2
            BEQ         ADREG       *CHECK FOR ADDRESS REGISTER OPERAND
            CMP         #2,D2
            BEQ         PARADREG    *CHECK FOR (AN)
            CMP         #3,D2
            BEQ         POSINCR     *CHECK FOR (AN)+

            *OTHERWISE ITS -(AN)
            LEA         DISP_MINUS,A1
            MOVE.B      #14,D0
            TRAP        #15              
            LEA         DISP_OPAREN,A1
            TRAP        #15
            LEA         DISP_MOVE_A,A1
            TRAP        #15
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15  
            LEA         DISP_CPAREN,A1
            MOVE.B      #14,D0
            TRAP        #15  
            RTS
           
DREG        LEA         DISP_D,A1
            MOVE.B      #14,D0
            TRAP        #15
            
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15
            RTS

ADREG       CLR.L       D1
            LEA         DISP_MOVE_A,A1
            MOVE.B      #14,D0
            TRAP        #15
            
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15
            RTS

PARADREG    LEA         DISP_OPAREN,A1
            MOVE.B      #14,D0
            TRAP        #15
            LEA         DISP_MOVE_A,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15
            LEA         DISP_CPAREN,A1
            MOVE.B      #14,D0
            TRAP        #15  
            RTS

POSINCR     LEA         DISP_OPAREN,A1
            MOVE.B      #14,D0
            TRAP        #15
            LEA         DISP_MOVE_A,A1
            TRAP        #15
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15

            LEA         DISP_CPAREN,A1
            MOVE.B      #14,D0
            TRAP        #15 
            LEA         DISP_PLUS,A1
            TRAP        #15    
            RTS
            
NOTREG      *NOT A DATA REGISTER
            MOVE.B      D3, D2
            CMP         #1, D2
            BEQ         ADDLONG
            * Word direct address
            LEA         DISP_DOLLAR, A1
            MOVE.B      #14,D0
            TRAP        #15    
            MOVE.W      (A5)+,A4
            MOVE.W      A4,D1        
            MOVE.B      #15, D0
            MOVE.B      #16, D2
            TRAP        #15
            RTS
            
            * long direct address
ADDLONG     LEA         DISP_DOLLAR, A1
            MOVE.B      #14,D0
            TRAP        #15    
            MOVE.L      (A5)+,A4
            MOVE.L      A4,D1  
            MOVE.B      #15, D0
            MOVE.B      #16, D2
            TRAP        #15
            RTS
            
PRINTSPACE  LEA         DISP_TAB, A1
            MOVE.B      #14,D0
            TRAP        #15 
            RTS
            
    SIMHALT             ; halt simulator

*---------------Opcode--Operands------------Comments---------------------------
CR              EQU     $0D                 ;Carriage Return
LF              EQU     $0A                 ;Line feed


* Printed Opcodes
*---------------Opcode--Operands------------Comments---------------------------
DISP_NOP        DC.B    'NOP',0
DISP_MOVE       DC.B    'MOVE',0
DISP_MOVEA      DC.B    'MOVEA',0
DISP_MOVEM      DC.B    'MOVEM',0
DISP_MOVEQ      DC.B    'MOVEQ',0
DISP_ADD        DC.B    'ADD',0
DISP_ADDA       DC.B    'ADDA',0
DISP_ADDQ       DC.B    'ADDQ',0
DISP_SUB        DC.B    'SUB',0
DISP_MULS       DC.B    'MULS',0
DISP_DIVU       DC.B    'DIVU',0
DISP_LEA        DC.B    'LEA',0
DISP_AND        DC.B    'AND',0
DISP_OR         DC.B    'OR',0
DISP_NOT        DC.B    'NOT',0
DISP_LSL        DC.B    'LSL',0
DISP_LSR        DC.B    'LSR',0
DISP_ASR        DC.B    'ASR',0
DISP_ASL        DC.B    'ASL',0
DISP_BEQ        DC.B    'BEQ',0
DISP_BGT        DC.B    'BGT',0
DISP_BLE        DC.B    'BLE',0
DISP_JSR        DC.B    'JSR',0
DISP_RTS        DC.B    'RTS',0
DISP_BRA        DC.B    'BRA',0
DISP_INVALID    DC.B    'DATA',0         *REMINDER: Label changed without changing name
DISP_INVALIDEA  DC.B    'BadEA',0
DISP_TAB        DC.B    '       ',0

* Printed Symbols
*---------------Opcode--Operands------------Comments---------------------------
DISP_HASH       DC.B    '#',0
DISP_DOLLAR     DC.B    '$',0
DISP_MINUS      DC.B    '-',0
DISP_PLUS       DC.B    '+',0
DISP_OPAREN     DC.B    '(',0
DISP_CPAREN     DC.B    ')',0
DISP_SPACE      DC.B    ' ',0
DISP_NL         DC.B    '',CR,LF,0
DISP_COMMA      DC.B    ',',0
DISP_SLASH      DC.B    '/',0
DISP_SIZE_B     DC.B    '.B',0
DISP_SIZE_L     DC.B    '.L',0
DISP_SIZE_W     DC.B    '.W',0
DISP_MOVE_A     DC.B    'A',0
DISP_D          DC.B    'D',0

TWEL_FIF        DC.B    1
NINE_ELE        DC.B    1
SIX_EIGT        DC.B    1
TREE_FIV        DC.B    1
ZERO_TWO        DC.B    1
CONDITION       DC.B    1
MEMORREG        DC.B    1

* IOFILEVARS
STARTADDMESS    DC.B    'Please enter a starting address: ',0
ENDADDMESS      DC.B    'Please enter an ending address: ',0
ERRADD          DC.B    'Not an even address',0
ERRADDLOC       DC.B    'Beginning address must be before ending address',0
ERRADD2         DC.B    'Has to be greater than 0 and less than 8',0
BEGIN           DS.L    1   *beginning address
LAST            DS.L    1

    END    START        ; last line of source

    SIMHALT             ; halt simulator

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
