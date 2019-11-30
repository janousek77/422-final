*-----------------------------------------------------------
* Title      : IO
* Written by : Team Schmos
* Date       :
* Description: This is the file for handling IO
*-----------------------------------------------------------
    ORG    $1000
START:                  
            LEA         STARTADDMESS,A1 *take starting address
            JSR         PSTRING 
            MOVE.B      #2,D0
            TRAP        #15

            JSR         CHECKVALUES
            MOVE.L      A1,BEGIN
            CLR.L       D4

            LEA         ENDADDMESS,A1   *take starting address
            JSR         PSTRING 
            MOVE.B      #2,D0
            TRAP        #15

            JSR         CHECKVALUES
            MOVE.L      A1,LAST
            MOVE.L      BEGIN,A5
            MOVE.L      LAST,A6

ADDLOOP:                                *loops through address and passes word data into D7
            CMP.L       A5,A6
            BLE         DONE
            JSR         CLEAR_REGS
            
            LEA         DISP_NL,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.L      A5,D1           *take starting address
            MOVE.W      (A5),A4
            MOVE.B      #15,D0
            MOVE.B      #16,D2
            TRAP        #15
    
            LEA         DISP_TAB,A1
            JSR         PSTRING 
    
            MOVE.W      (A5)+,D7
            JSR         OPCODE          *Handles all of the first word logic
            JSR         CLEARVARS
            JMP         ADDLOOP

CLEAR_REGS  CLR.L         D0
            CLR.L         D1
            CLR.L         D2
            CLR.L         D3
            CLR.L         D4
            CLR.L         D5
            CLR.L         D6
            CLR.L         D7
            RTS
DONE
    SIMHALT


CHECKVALUES                            *not less than 1 or greater than 8
            CMP.L       #1,D1          *if the address length is less than 1, error
            BLT         ERRADD2

            CMP.L       #8,D1          *if the address length is greater than 8, error
            BGT         ERRADD2
            JSR         CONVERTLOOP

            MOVEA.L     D4,A1
            LSR.B       #1,D4          *check to see if the address is even
            BCS         INVALID
            RTS


INVALID
            LEA         ERRADD,A1      *take starting address
            MOVE.B      #14,D0
            TRAP        #15
            JMP         START

CONVERTLOOP
            CMP         #0,D1           *IS LOOP DONE?
            BEQ         CONVDONE
            MOVE.B      (A1)+,D2        *COPY BYTE AND INCREMENT REGISTER
            JSR         CONVERT         *CONVERT TO HEX
            LSL.L       #4,D4           *MAKE ROOM FOR NEXT BYTE
            ADD.B       D2,D4
            SUBQ.B      #1,D1           *DECREMENT COUNTER
            JMP         CONVERTLOOP

CONVERT
            CMP.B       #$39,D2         *compare 39 ASCII #9
            BGT         LETTER          *if greater than it is a letter
            SUB.B       #$30,D2         *Subtract 30 for HEX number
            RTS

LETTER      SUB.B       #$37,D2         *Subtract 37 for HEX letter
            RTS

CONVDONE    MOVE.L      D4,D5
            RTS


*-----------------------------------------------------------
* Title      : Opcodes
* Written by : Team Schmos
* Date       :
* Description: This is the file for handling OPCODES
*-----------------------------------------------------------
stack       EQU         $A000

OPCODE      LEA         stack,SP        *Load the SP
            LEA         jmp_table,A0    *Index into the table
*            CLR.L       D0              *Zero it
            
            *For bits 12 -> 15
            MOVE.W      D7,D0           *We'll play with it here
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

            *jump table section takes bits 12->15 and jumps to appropriate subroutine            
            CLR         D0
            CLR         D1            
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
            JSR         PSTRING 
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
            JSR         PSTRING 
            CMP.B       #1,SIX_EIGT      *checking if bits 6-8 equal one if yes its a movea
            BEQ         MOVEAB
            BRA         SIZEB

MOVEAB      LEA         DISP_MOVE_A,A1
            JSR         PSTRING 
            RTS
 
* Handles MOVEA.L, MOVE.L
code0010
            LEA         DISP_MOVE,A1
            JSR         PSTRING 
            CMP.B       #1,SIX_EIGT
            BEQ         MOVEAL
            BRA         MOVEL

MOVEAL      LEA         DISP_MOVE_A,A1
            JSR         PSTRING 

MOVEL       LEA         DISP_SIZE_L,A1
            JSR         PSTRING 
            RTS


* Handles MOVEA.W, MOVE.W
code0011
            LEA         DISP_MOVE,A1
            JSR         PSTRING 
            CMP.B       #1,SIX_EIGT
            BEQ         MOVEAW
            BRA         MOVEW

MOVEAW      LEA         DISP_MOVE_A,A1
            JSR         PSTRING 

MOVEW       LEA         DISP_SIZE_W,A1
            JSR         PSTRING 
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
            JSR         PSTRING 
            JMP         LEAEA

ISMOVEM
            LEA         DISP_MOVEM, A1
            JSR         PSTRING 
            MOVE.B      SIX_EIGT,D2
            LSR.B       #1,D2
            BCS         MLONG
            JSR         SIZEW
MMCON       JSR         PRINTSPACE
            JSR         MOVEMEA
MLONG       JSR         SIZEL
            JMP         MMCON

ISNOT
            LEA         DISP_NOT, A1
            JSR         PSTRING 
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         PRINTSPACE
            JSR         EA
            JMP         ADDLOOP
ISJSR
            LEA         DISP_JSR, A1
            JSR         PSTRING 
            JSR         PRINTSPACE
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            JMP         ADDLOOP
ISNOP
            LEA         DISP_NOP, A1
            JSR         PSTRING 
            JMP         ADDLOOP
ISRTS
            LEA         DISP_RTS, A1
            JSR         PSTRING 
            JMP         ADDLOOP

* Handles ADDQ
code0101
            LEA         DISP_ADDQ,A1
            MOVE.B      #14,D0
            TRAP        #15

            MOVE.B      SIX_EIGT,D0
            LSR.B       #1,D0                *If first bit is one its word. Second a long
            BCS         QW
            LSR.B       #1,D0
            BCS         QL               
            BRA         QB                   *IF NONE OF THESE WE DEFAULT TO ADDQ.B
            
QW          JSR         SIZEW
            JMP         QEA
QL          JSR         SIZEL               
            JMP         QEA
QB          JSR         SIZEB  
            JMP         QEA                   

* Handles Bcc operations
code0110
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
            JSR         PSTRING 
            RTS

ISBRA
            LEA         DISP_BRA,A1
            JSR         PSTRING 
            JMP         BCC

ISLE
            LEA         DISP_BLE,A1
            JSR         PSTRING 
            JMP         BSIZE

ISGT
            LEA         DISP_BGT,A1
            JSR         PSTRING 
            JMP         BSIZE

ISEQ
            LEA         DISP_BEQ,A1
            JSR         PSTRING 

            
BSIZE       CMP.B       #$00,D7
            BEQ         BCCW                      
            CMP.B       #$FF,D7
            BEQ         BCCL      

BCCB        JSR         SIZEB  
            JMP         BCC                  
BCCW        JSR         SIZEW
            JMP         BCC
BCCL        JSR         SIZEL               
            JMP         BCC

    
* Handles MOVEQ
code0111
            LEA         DISP_MOVEQ, A1
            JSR         PSTRING 
            JMP         MQEA

* Handles OR, DIV operations
code1000
            CLR         D0
            LEA         DISP_OR, A1
            JSR         PSTRING

            MOVE.B      SIX_EIGT,D2
            LSR.B       #1,D2               *If first bit is one its word. Second a long
            BCS         JUMPW
            LSR.B       #1,D2
            BCS         JUMPL
            BRA         JUMPB                *DEFAULT TO BYTE
       
* Handles SUB
code1001
            LEA         DISP_SUB,A1
            JSR         PSTRING

            MOVE.B      SIX_EIGT,D0
            LSR.B       #1,D0                *If first bit is one its word. Second a long
            BCS         JUMPW      
            LSR.B       #1,D0
            BCS         JUMPL      
            BRA         JUMPB      
          

* Unassigned
code1010
            JSR         PRINTDATA


* Unassigned
code1011
            JSR         PRINTDATA

* Handles AND
code1100

            CLR         D0
            LEA         DISP_AND,A1
            JSR         PSTRING

            MOVE.B      SIX_EIGT,D2
            LSR.B       #1,D2               *If first bit is one its word. Second a long
            BCS         JUMPW
            LSR.B       #1,D2
            BCS         JUMPL
            BRA         JUMPB

* Handles ADD, ADDA
code1101
            MOVE.B      SIX_EIGT, D2
            CMP.B       #7,D2
            BEQ         ISADDA
            CMP.B       #3,D2
            BEQ         ISADDA

            CLR         D0
            LEA         DISP_ADD,A1
            JSR         PSTRING 

            LSR.B       #1,D2               *If first bit is one its word. Second a long
            BCS         JUMPW       
            LSR.B       #1,D2
            BCS         JUMPL
            BRA         JUMPB
 
*FOR ADD: If the opmode is < 4 then it is add EA,reg. If opmode >= 4 reg(num),EA

ISADDA      LEA         DISP_ADDA,A1
            JSR         PSTRING 
            CMP         #3,D2
            BEQ         ADDAW

            LEA         DISP_SIZE_L,A1
            JSR         PSTRING 
            JMP         ADDAEA     

ADDAW       LEA         DISP_SIZE_W,A1
            JSR         PSTRING 
            JMP         ADDAEA

*A* Handles shift operations
code1110    
            MOVE.B      SIX_EIGT,D2
            LSL.B       #7,D2
            BCS         CHECKNXTBIT
            BRA         ISREGSHIFT

CHECKNXTBIT 
            LSL.B       #1,D2
            BCS         ISMEMSHIFT
            BRA         ISREGSHIFT

ISMEMSHIFT  MOVE.B      NINE_ELE,D2
            MOVE.B      #1,MEMORREG         *IF MEMORY SHIFT SET MEMORREG TO 1
            CMP         #0,D2
            BEQ         ISASHIFT    
            CMP         #1,D2
            BEQ         ISLSHIFT    
            BRA         ISROT  

ISREGSHIFT  MOVE.B      TREE_FIV,D2
            MOVE.B      #0,MEMORREG         *IF MEMORY SHIFT SET MEMORREG TO 0
            LSR.B       #1,D2
            BCC         ISASHIFT
            LSR.B       #1,D2
            BCC         ISLSHIFT
            BRA         ISROT
            
ISLSHIFT    *CHECK DIRECTION AND DISPLAY
            MOVE.B      SIX_EIGT,D2
            LSL.B       #6,D2
            BCS         ISLSL

            *DISPLAY RIGHT SHIFT
            LEA         DISP_LSR,A1
            JSR         PSTRING 
            JSR         CHECKMEMORREG
            JMP         REGORNUM

ISLSL       LEA         DISP_LSL,A1
            JSR         PSTRING 
            JSR         CHECKMEMORREG
            JMP         REGORNUM

            *CHECKING DIRECTION AND SIZE
ISASHIFT    MOVE.B      SIX_EIGT,D2
            LSL.B       #6,D2
            BCS         ISASL

            LEA         DISP_ASR,A1        *IF NOT ASL. ASR
            JSR         PSTRING 
            JSR         CHECKMEMORREG
            JMP         REGORNUM

ISASL       LEA         DISP_ASL,A1
            JSR         PSTRING 
            JSR         CHECKMEMORREG
            JMP         REGORNUM

ISROT       MOVE.B      SIX_EIGT,D2
            LSL.B       #6,D2
            BCS         ISROL 

            *DISPLAY ROR
            LEA         DISP_ROR,A1
            JSR         PSTRING 
            JSR         CHECKMEMORREG
            JMP         REGORNUM

ISROL       LEA         DISP_ROL,A1
            JSR         PSTRING 
            JSR         CHECKMEMORREG
            JMP         REGORNUM
            
CHECKMEMORREG
            CLR.L       D4
            MOVE.B      MEMORREG,D4
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            CMP         #1,D4
            BEQ         SHIFTEA
            JSR         S_SIZE
            JSR         PRINTSPACE 
            RTS

S_SIZE      MOVE.B      SIX_EIGT,D2
            LSR.B       #1,D2
            BCS         SIZEW
            LSR.B       #1,D2
            BCS         SIZEL
            BRA         SIZEB
            
REGORNUM    *IS THIS A REGISTER OR A NUMBER SHIFT??
            CLR.L       D6
            MOVE.B      TREE_FIV,D6
            CMP         #4,D6
            BLT         NUM
            MOVE.B      #0,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA         
            JMP         SECPART
            
NUM         CLR         D1
            LEA         DISP_HASH,A1
            JSR         PSTRING 
            MOVE.B      NINE_ELE,D1
            MOVE.B      #3,D0
            TRAP        #15      
            JMP         SECPART

            
* Reserved of SIMHALT
code1111
            
PRINTDATA   LEA         DISP_DATA,A1
            JSR         PSTRING
            JSR         PRINTSPACE
            MOVE.W      A4,D1
            JSR         PRINTHEX
            JMP         ADDLOOP
            

JUMPW       JSR         SIZEW   
            JMP         WHICHONE
 
JUMPL       JSR         SIZEL           
            JMP         WHICHONE
 
JUMPB       JSR         SIZEB
            JMP         WHICHONE

SIZEW       LEA         DISP_SIZE_W, A1
            JSR         PSTRING 
            RTS

SIZEL       LEA         DISP_SIZE_L,A1
            JSR         PSTRING 
            RTS

SIZEB       LEA         DISP_SIZE_B,A1
            JSR         PSTRING   
            RTS

PSTRING     MOVE.B      #14,D0
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
            JSR         PSTRING               
            LEA         DISP_OPAREN,A1
            JSR         PSTRING 
            LEA         DISP_MOVE_A,A1
            JSR         PSTRING 
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15  
            LEA         DISP_CPAREN,A1
            JSR         PSTRING 
            RTS
           
DREG        LEA         DISP_D,A1
            JSR         PSTRING 
            
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15
            RTS

ADREG       CLR.L       D1
            LEA         DISP_MOVE_A,A1
            JSR         PSTRING 
            
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15
            RTS

PARADREG    LEA         DISP_OPAREN,A1
            JSR         PSTRING 
            LEA         DISP_MOVE_A,A1
            MOVE.B      #14,D0
            TRAP        #15
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15
            LEA         DISP_CPAREN,A1
            JSR         PSTRING 
            RTS

POSINCR     LEA         DISP_OPAREN,A1
            JSR         PSTRING 
            LEA         DISP_MOVE_A,A1
            TRAP        #15
            MOVE.B      D3,D1
            MOVE.B      #3,D0
            TRAP        #15

            LEA         DISP_CPAREN,A1
            JSR         PSTRING 
            LEA         DISP_PLUS,A1
            TRAP        #15    
            RTS
            
NOTREG      *NOT A DATA REGISTER
            MOVE.B      D3, D2
            CMP         #1, D2
            BEQ         ADDLONG
            CMP         #4,D2
            BEQ         ITSDATA
            * Word direct address
            LEA         DISP_DOLLAR, A1
            JSR         PSTRING   
            MOVE.W      (A5)+,A4
            MOVE.W      A4,D1        
            JSR         PRINTHEX
            RTS
            
            * long direct address
ADDLONG     LEA         DISP_DOLLAR, A1
            JSR         PSTRING    
            MOVE.L      (A5)+,A4
            MOVE.L      A4,D1  
            JSR         PRINTHEX
            RTS
            
ITSDATA     MOVE.B      SIX_EIGT,D1
            LSR.B       #2,D1
            BCS         LONGDATA

WORDATA     LEA         DISP_HASH, A1
            JSR         PSTRING  
            LEA         DISP_DOLLAR, A1
            JSR         PSTRING    
            MOVE.W      (A5)+,A4
            MOVE.W      A4,D1  
            JSR         PRINTHEX
            RTS
            
LONGDATA    LEA         DISP_HASH, A1
            JSR         PSTRING  
            LEA         DISP_DOLLAR, A1
            JSR         PSTRING    
            MOVE.L      (A5)+,A4
            MOVE.L      A4,D1  
            JSR         PRINTHEX
            RTS
            
            
PRINTSPACE  LEA         DISP_TAB, A1
            JSR         PSTRING 
            RTS
            
PRINTHEX    MOVE.B      #15,D0
            MOVE.B      #16,D2
            TRAP        #15  
            RTS          

*ADDA HAS DIFFERENT LOGIC FOR EA SO CALLING FROM HERE INSTEAD OF ADDLOOP
ADDAEA      MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         PRINTSPACE
            JSR         EA
            LEA         DISP_COMMA,A1
            JSR         PSTRING 
            MOVE.B      #1,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA
            JMP         ADDLOOP   

*LEA            
LEAEA       JSR         PRINTSPACE
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            LEA         DISP_COMMA,A1
            JSR         PSTRING 
            MOVE.B      #1,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA
            JMP         ADDLOOP

*ADDQ            
QEA         JSR         PRINTSPACE
            LEA         DISP_HASH,A1
            JSR         PSTRING 
            MOVE.B      NINE_ELE,D1 
            CMP         #0,D1
            BEQ         EIGHT
CONTQEA     MOVE.B      #3,D0
            TRAP        #15
            LEA         DISP_COMMA,A1
            JSR         PSTRING 
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            JMP         ADDLOOP
EIGHT       MOVE.B      #8,D1
            JMP         CONTQEA   

*MOVEQ
MQEA        

            JSR         PRINTSPACE
            LEA         DISP_DOLLAR,A1
            JSR         PSTRING            
            LEA         DISP_HASH,A1
            JSR         PSTRING 
            CLR         D0
            CLR         D1
            CLR         D2            
            MOVE.B      D7,D1       
            MOVE.B      #15, D0
            MOVE.B      #16, D2
            TRAP        #15
            LEA         DISP_COMMA,A1
            JSR         PSTRING 
            MOVE.B      #0,D2
            MOVE.B      NINE_ELE,D3
            JSR         EA
            JMP         ADDLOOP         

*ARITHMETIC AND LOGICAL SHIFTS
SECPART     
            LEA         DISP_COMMA,A1
            JSR         PSTRING 
            MOVE.B      #0,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            JMP         ADDLOOP
            
SHIFTEA     JSR         SIZEW
            JSR         PRINTSPACE
            JSR         EA
            JMP         ADDLOOP            

*ANYTHING WITH AN OPCODE            
WHICHONE    JSR         PRINTSPACE
            MOVE.B      SIX_EIGT,D6
            CMP         #4,D6
            BLT         EAFIRST
            
            MOVE        #0,D2               *EA is second in this scenario
            MOVE.B      NINE_ELE,D3
            JSR         EA
            LEA         DISP_COMMA,A1
            JSR         PSTRING 
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            JMP         ADDLOOP           

EAFIRST            
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA            
            LEA         DISP_COMMA,A1
            JSR         PSTRING 
            MOVE        #0,D2               *EA is second in this scenario
            MOVE.B      NINE_ELE,D3
            JSR         EA
            JMP         ADDLOOP
            

BCC         JSR         PRINTSPACE     
            MOVE.W      A5,A3        
            CMP.B       #$00,D7
            BEQ         EVAL1632            *16-bit Displacement
               
            CMP.B       #$FF,D7
            BEQ         EVAL1632            *32-bit Displacement
                                                                       
            JSR         CHECK0TO7           *8-bit Displacement
            CMP.B       $80,D7              *Check if the number is a negative 2's complement byte
            BGE         NOTNEG
            JSR         NEGDIS              *If so, handle it appropriately.
            JSR         BCCPRINT
NOTNEG      MOVE.W      A3,D7
            ADD.W       D2,D7               *Apply displacement to address pointer to get branch location

BCCPRINT    MOVE.L      D7,D1               
            JSR         PRINTHEX            
            JMP         ADDLOOP

NEGDIS      MOVE.B      D7,D2
            MULS        #-1,D2              *Find the absolute value of the negative number
            MOVE.W      A3,D7
            SUB.B       D2,D7               *Apply displacement to address pointer to get branch location
            RTS        

EVAL1632    MOVE.W      (A5)+,D7            *Copy the current instruction pointer location               
            JSR         CHECKNEG 
ADD1632     MOVE.W      A3,D2
            ADD.W       D2,D7                        
            JMP         BCCPRINT
                
CHECKNEG    MOVE.W      D7,D2
            LSL.W       #1,D2
            BCC         ADD1632
            MOVE.W      D7,D2
            MULS        #-1,D2
            MOVE.W      A3,D7
            SUB.W       D2,D7
            JMP         BCCPRINT               
                
CHECK0TO7   MOVE.W      D7,D2               *Reload full opcode for evaluation
            LSL.W       #8,D2               *Truncate up to bit 7
            LSR.W       #8,D2               *Isolate remainder
            RTS

*MOVEM EA SECTION                
MOVEMEA     MOVE.W      (A5)+,D4        *Moves range word from register to D4
            MOVE.B      NINE_ELE,D2     *Bit 10 determines whether its a reg->mem or mem->reg
            LSR.B       #2,D2
            BCS         MEMTOREG        *If the carry flag is set its mem->reg

            *Reg->mem
            MOVE.B      TREE_FIV,D2     *If not it defaults to reg->mem. Check mode for post dec
            CMP         #4,D2
            BEQ         REVMASK         *If mode indicates post dec then we need to print the reversed mask
            JSR         MASK
            LEA         DISP_COMMA,A1         
            JSR         PSTRING
            JSR         CLEAR_REGS 
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            JMP         ADDLOOP                                     
                
MEMTOREG    MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA
            LEA         DISP_COMMA,A1         
            JSR         PSTRING 
            JSR         MASK
            JMP         ADDLOOP      

MASK        CLR.L       D1
            MOVE.B      D4,D5
            MOVE.W      D4,D6
            LSR.W       #8,D6
            CMP         #0,D5
            BEQ         AONLY
            CMP         #0,D6
            BEQ         DONLY
            
            MOVE.W      D4,D2
            MOVE.B      #15,D1
            JSR         LEFTLOOP  
            JSR         MASKEVAL
            JSR         PSLASH
            MOVE.B      #0,D1
            MOVE.W      D4,D2
            JSR         RIGHTLOOP
            JSR         MASKEVAL     
            RTS

DONLY       MOVE.B      #0,D1
            MOVE.B      D5,D2
            JSR         RIGHTLOOP
            JSR         MASKEVAL
            JSR         SORD
            MOVE.W      D5,D2
            MOVE.B      #15,D1
            JSR         LEFTLOOP  
            JSR         MASKEVAL
            RTS            

AONLY       MOVE.B      #8,D1
            MOVE.B      D6,D2
            JSR         RIGHTLOOP
            JSR         MASKEVAL
            JSR         SORD
            MOVE.W      D4,D2
            MOVE.B      #15,D1
            JSR         LEFTLOOP  
            JSR         MASKEVAL            
            RTS

MASKEVAL    CMP         #8,D1
            BGE         MASKADD            
            BLT         MASKREG
            
MASKADD     SUB.B       #8,D1
            LEA         DISP_MOVE_A,A1
            JSR         PSTRING
            MOVE.B      #3,D0
            TRAP        #15
            RTS      
      
MASKREG     LEA         DISP_D,A1
            JSR         PSTRING
            MOVE.B      #3,D0
            TRAP        #15
            RTS            
            
LEFTLOOP    LSL.W       #1,D2
            BCS         RETURN
            SUB.B       #1,D1
            JMP         LEFTLOOP
            
RIGHTLOOP   LSR.W       #1,D2
            BCS         RETURN
            ADD.B       #1,D1
            JMP         RIGHTLOOP
            
REVMASK     CLR.L       D1
            MOVE.B      D4,D5
            MOVE.W      D4,D6
            LSR.W       #8,D6
            CMP         #0,D5
            BEQ         RDONLY
            CMP         #0,D6
            BEQ         RAONLY

            MOVE.B      D5,D2
            LSL.W       #8,D2
            MOVE.L      #0,D1            
            JSR         RLEFTLOOP
            JSR         RMASKADD
            JSR         PSLASH
            MOVE.B      D6,D2
            LSL.W       #8,D2                
            MOVE.L      #0,D1            
            JSR         RLEFTLOOP
            JSR         RMASKREG
            
REND        JSR         CLEAR_REGS
            LEA         DISP_COMMA,A1         
            JSR         PSTRING              
            MOVE.B      TREE_FIV,D2
            MOVE.B      ZERO_TWO,D3
            JSR         EA     
            JMP         ADDLOOP

RDONLY      MOVE.B      D6,D2
            LSL.W       #8,D2                
            MOVE.L      #0,D1            
            JSR         RLEFTLOOP
            JSR         RMASKREG
            JSR         RSORD
            MOVE.B      D6,D2
            MOVE.B      #7,D1
            JSR         RRIGHTLOOP
            JSR         RMASKREG
            JMP         REND         

RAONLY      MOVE.B      D5,D2
            LSL.W       #8,D2
            MOVE.L      #0,D1            
            JSR         RLEFTLOOP
            JSR         RMASKADD
            JSR         RSORD
            MOVE.B      D5,D2
            MOVE.B      #7,D1
            JSR         RRIGHTLOOP
            JSR         RMASKADD
            JMP         REND               
           
RLEFTLOOP   LSL.W       #1,D2
            BCS         RETURN
            ADD.B       #1,D1
            JMP         RLEFTLOOP
            
RRIGHTLOOP  LSR.W       #1,D2
            BCS         RETURN
            SUB.B       #1,D1
            JMP         RRIGHTLOOP 
            
RMASKREG    LEA         DISP_D,A1
            JSR         PSTRING
            MOVE.B      #3,D0
            TRAP        #15
            RTS      
      
RMASKADD    LEA         DISP_MOVE_A,A1
            JSR         PSTRING
            MOVE.B      #3,D0
            TRAP        #15
            RTS            
            
RETURN      RTS        
            
SORD        LSR.W       #1,D2
            BCS         PDASH
            BCC         PSLASH

RSORD       LSL.W       #1,D2
            BCS         PDASH
            BCC         PSLASH

PDASH       LEA         DISP_MINUS,A1
            JSR         PSTRING
            RTS

PSLASH      LEA         DISP_SLASH,A1
            JSR         PSTRING
            RTS                                      
                
CLEARVARS   CLR.L       TWEL_FIF
            CLR.L       NINE_ELE
            CLR.L       SIX_EIGT
            CLR.L       TREE_FIV
            CLR.L       ZERO_TWO 
            CLR.L       CONDITION
            CLR.L       MEMORREG
            CLR.L       LONGFLAG
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
DISP_ROR        DC.B    'ROR',0
DISP_ROL        DC.B    'ROL',0
DISP_BEQ        DC.B    'BEQ',0
DISP_BGT        DC.B    'BGT',0
DISP_BLE        DC.B    'BLE',0
DISP_JSR        DC.B    'JSR',0
DISP_RTS        DC.B    'RTS',0
DISP_BRA        DC.B    'BRA',0
DISP_DATA       DC.B    'DATA',0         *REMINDER: Label changed without changing name
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
LONGFLAG        DC.B    1

* IOFILEVARS
STARTADDMESS    DC.B    'Please enter a starting address: ',0
ENDADDMESS      DC.B    'Please enter an ending address: ',0
ERRADD          DC.B    'Not an even address',0
ERRADDLOC       DC.B    'Beginning address must be before ending address',0
ERRADD2         DC.B    'Has to be greater than 0 and less than 8',0
BEGIN           DS.L    1   *beginning address
LAST            DS.L    1

    SIMHALT             ; halt simulator

    END    START        ; last line of source






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
