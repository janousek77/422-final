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
    
    LEA     ENDADDMESS, A1      *take starting address   
    MOVE.B  #14, D0    
    TRAP    #15
    
    MOVE.B  #2, D0         
    TRAP    #15
    
    JSR     CHECKVALUES    
    MOVE.L  A1, LAST
    
    MOVE.L  BEGIN, A5
    MOVE.L  LAST, A6
    
    SIMHALT ;
    
    
CHECKVALUES *not less than 1 or greater than 8 
    
    CMP.L     #1, D1          *if the address length is less than 1, error
    BLT     ERRADD2
    
    CMP.L     #8, D1          *if the address length is greater than 8, error
    BGT     ERRADD2
    
    JSR     CONVERTLOOP
    
    *MOVEA.L A1, A2
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
 
CONVDONE    MOVE.L      D4,d5
            RTS
                
    SIMHALT             ; halt simulator

* Put variables and constants here
STARTADDMESS       DC.B    'Please enter a starting address: ',0
ENDADDMESS         DC.B    'Please enter an ending address: ',0
ERRADD             DC.B    'Not an even address',0
ERRADDLOC          DC.B    'Beginning address must be before ending address',0 
ERRADD2            DC.B    'Has to be greater than 0 and less than 8',0
BEGIN              DS.L    1   *beginning address
LAST               DS.L    1

     
    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
