*-----------------------------------------------------------
* Title      : Opcodes
* Written by : Team Schmos
* Date       :
* Description: This is the file for handling OPCODES
*-----------------------------------------------------------
stack       EQU      $A000
example     EQU      %1001111000100001  * I made up bits 0 to 11      
 
        ORG     $400

start       LEA         stack,SP        *Load the SP
            LEA         jmp_table,A0    *Index into the table
            CLR.L       D0              *Zero it
            
            MOVE.W      #example,D0     *We'll play with it here
            MOVE.B      #12,D1          *Shift 12 bits to the right  
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,TWEL_FIF
            
            CLR.L       D0              *Zero it            
            MOVE.W      #example,D0     *We'll play with it here
            MOVE.B      #4,D1           *Shift 12 bits to the right  
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #13,D1          *Shift 12 bits to the right  
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,NINE_ELE

            CLR.L       D0              *Zero it            
            MOVE.W      #example,D0     *We'll play with it here
            MOVE.B      #7,D1           *Shift 12 bits to the right  
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #13,D1          *Shift 12 bits to the right  
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,SIX_EIGT
            
            CLR.L       D0              *Zero it
            MOVE.W      #example,D0     *We'll play with it here
            MOVE.B      #10,D1          *Shift 12 bits to the right  
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #13,D1          *Shift 12 bits to the right  
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,TREE_FIV
            
            CLR.L       D0              *Zero it
            MOVE.W      #example,D0     *We'll play with it here
            MOVE.B      #13,D1          *Shift 12 bits to the right  
            LSL.W       D1,D0           *Move the bits
            MOVE.B      #13,D1          *Shift 12 bits to the right  
            LSR.W       D1,D0           *Move the bits
            MOVE.B      D0,ZERO_TWO
            
            CLR         D0
            MOVE.B      TWEL_FIF,D0
            MULU        #6,D0          *Form offset     
            JSR         0(A0,D0)       *Jump indirect with index                    

jmp_table   JSR         code0000       *for jumping to a specific instruction
            JSR         code0001
            JSR         code0010
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
            BRA         MOVEB
            
MOVEAB      LEA         DISP_MOVE_A,A1      
            TRAP        #15

MOVEB       LEA         DISP_SIZE_B,A1
            TRAP        #15
       SIMHALT

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
      SIMHALT
            
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
       SIMHALT
            
code0100       


code0101       
            LEA         DISP_ADDQ,A1
            MOVE.B      #1, D0         
            TRAP        #15
       SIMHALT
            
* Handles Bcc operations
code0110        

* Handles MOVEQ
code0111       
            LEA         DISP_MOVEQ,A1
            MOVE.B      #1, D0         
            TRAP        #15
       SIMHALT
       
* Handles OR, DIV operations         
code1000       

* Handles SUB
code1001      
            LEA         DISP_SUB,A1
            MOVE.B      #1, D0         
            TRAP        #15
            
            MOVE.B SIX_EIGT,D0          
            LSR.B  #1,D0                *If first bit is one its word. Second a long
            BCS    SUBW
            LSR.B  #1,D0
            BCS    SUBL
            BRA    SUBB

SUBW        LEA     DISP_SIZE_W,A1   
            TRAP    #15
       SIMHALT
            
SUBL        LEA     DISP_SIZE_L,A1
            TRAP    #15
       SIMHALT

SUBB        LEA     DISP_SIZE_B,A1
            TRAP    #15
       SIMHALT
       
* Unassigned           
code1010                      

* Unassigned
code1011        

* Handles AND, MUL
code1100       
            LEA         DISP_MULS,A1
            MOVE.B      #1, D0         
            TRAP        #15
* Handles ADD, ADDA
code1101       
* Handles shift operations                
code1110       
* Reserved of SIMHALT
code1111       
  

 



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




* Printed Symbols
*---------------Opcode--Operands------------Comments---------------------------
DISP_OCTOTHORPE DC.B    '#',0
DISP_DOLLAR     DC.B    '$',0
DISP_MINUS      DC.B    '-',0
DISP_PLUS       DC.B    '+',0
DISP_OPAREN     DC.B    '(',0
DISP_CPAREN     DC.B    ')',0
DISP_SPACE      DC.B    ' ',0
DISP_COMMA      DC.B    ',',0
DISP_SLASH      DC.B    '/',0
DISP_SIZE_B     DC.B    '.B',0
DISP_SIZE_L     DC.B    '.L',0
DISP_SIZE_W     DC.B    '.W',0
DISP_MOVE_A     DC.B    'A',0

TABLE_HEXCHAR   DC.B    '0',0
                DC.B    '1',0
                DC.B    '2',0
                DC.B    '3',0
                DC.B    '4',0
                DC.B    '5',0
                DC.B    '6',0
                DC.B    '7',0
                DC.B    '8',0
                DC.B    '9',0
                DC.B    'A',0 
                DC.B    'B',0
                DC.B    'C',0
                DC.B    'D',0
                DC.B    'E',0
                DC.B    'F',0
TWEL_FIF        DC.B    1
NINE_ELE        DC.B    1
SIX_EIGT        DC.B    1
TREE_FIV        DC.B    1
ZERO_TWO        DC.B    1

    END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
