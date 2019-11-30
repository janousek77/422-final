*****************************
*
* demo_test.X68
*
* Created 12/05/2018
*
* Test program for CSS 422 Disassembler Project Demo
*
*****************************

start		EQU	$00007000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	START
*    BEQ.W       label1
*    RTS
*    NOP
*    RTS
*    ADD.B       D2,D3
*    ADD.B       D3,(A1) 
*    ADD.B       D4,(A1)+ 
*    ADD.B       D5,-(A1) 
*    ADD.B       (A3),D1
*    ADD.B       (A4)+,D1
*    ADD.B       -(A5),D1
*    ADD.W       D6,D2 
*    ADD.W       D7,(A1)
*    ADD.W       D1,(A1)+
*    ADD.W       D0,-(A1)
*    ADD.W       (A1),D1
*    ADD.W       (A2)+,D1
*    ADD.W       -(A3),D1
*    ADD.L       D1,D2 
*    ADD.L       D2,(A1)
*    ADD.L       D3,(A1)+
*    ADD.L       D4,-(A1)
*    ADD.L       (A4),D1
*    ADD.L       (A5)+,D1
*    ADD.L       -(A6),D1
*    ADDA.W      D5,A2
*    ADDA.W      (A0),A2
*    ADDA.W      (A1)+,A2
*    ADDA.W      -(A2),A2
*    ADDA.L      D6,A2 
*    ADDA.L      (A2),A2
*    ADDA.L      (A3)+,A2
*    ADDA.L      -(A4),A2
*    ADDA.W      $12,A2
*    ADDA.W      $1234,A2
*    ADDA.W      $12345678,A2
*    ADDA.W      #$1234,A2
*    ADDA.L      $12,A2
*    ADDA.L      $1234,A2
*    ADDA.L      $12345678,A2
    ADDA.L      #$12345678,A2 
    ADDA.W      #$1234,A2 
    ADDQ.B      #1,D5 
    ADDQ.B      #2,D1
    ADDQ.B      #3,(A4)+
    ADDQ.B      #4,-(A5)
    ADDQ.W      #5,D2 
    ADDQ.W      #6,(A1)
    ADDQ.W      #7,A1
    ADDQ.W      #8,-(A1)
    ADDQ.L      #1,D2 
    ADDQ.L      #2,(A1)
    ADDQ.L      #3,(A1)+
    ADDQ.L      #4,-(A1)
    AND.B       D0,D2
    AND.B       D1,(A1)
    AND.B       D2,(A1)+
    AND.B       D3,-(A1)
    AND.B       (A1),D1
    AND.B       (A2)+,D1
    AND.B       -(A3),D1
    AND.W       D4,D2
    AND.W       D5,(A1)
    AND.W       D6,(A1)+
    AND.W       D0,-(A1)
    AND.W       (A0),D1
    AND.W       (A1)+,D1
    AND.W       -(A2),D1
    AND.L       D1,D2
    AND.L       D2,(A1)
    AND.L       D3,(A1)+
    AND.L       D4,-(A1)
    AND.L       (A3),D1
    AND.L       (A4)+,D1
    AND.L       -(A5),D1
    AND.B       D1,$12
    AND.B       D1,$1234
    AND.B       D1,$12345678
    AND.B       $12,D1
    AND.B       $1234,D1
    AND.B       $12345678,D1
    AND.B       #$12,D1
    AND.W       D1,$12
    AND.W       D1,$1234
    AND.W       D1,$12345678
    AND.W       $12,D1
    AND.W       $1234,D1
    AND.W       $12345678,D1
    AND.W       #$1234,D1
    AND.L       D1,$12
    AND.L       D1,$1234
    AND.L       D1,$12345678
    AND.L       $12,D1
    AND.L       $1234,D1
    AND.L       $12345678,D1
    AND.L       #$12345678,D1 
    ASR.B       D5,D2 
    ASR.W       D6,D2
    ASR.W       (A0) 
    ASR.W       (A1)+ 
    ASR.W       -(A2) 
    ASR.L       D1,D2
    ASL.B       D2,D3
    ASL.W       D3,D2
    ASL.W       (A3)
    ASL.W       (A4)+
    ASL.W       -(A5)
    ASL.L       D1,D2
    ASL.B       #1,D3
    ASR.B       #1,D4 
    LEA         (A0),A1
    LEA         (A1),A2
    LEA         (A2),A3
    LEA         (A3),A4
    LEA         (A4),A5
    LEA         (A5),A6
    LSL.B       D4,D2
    LSL.W       D5,D2
    LSL.W       (A1) 
    LSL.W       (A2)+ 
    LSL.W       -(A3)
    LSL.L       D1,D2
    LSR.B       D2,D3
    LSR.W       D3,D2
    LSR.W       (A4)
    LSR.W       (A5)+
    LSR.W       -(A6)
    LSR.L       D4,D2
    LSL.B       #1,D3
    LSR.B       #1,D4 
    MOVE.B      D0,D1
    MOVE.B      D1,(A0)
    MOVE.B      D2,(A1)+
    MOVE.B      D3,-(A2) 
    MOVE.B      (A3),D4
    MOVE.B      (A4),(A5)
    MOVE.B      (A5),(A6)+
    MOVE.B      (A6),-(A0) 
    MOVE.B      (A0)+,D5
    MOVE.B      (A1)+,(A2)
    MOVE.B      (A3)+,(A3)+
    MOVE.B      (A4)+,-(A5)
    MOVE.B      -(A6),D0
    MOVE.B      -(A0),(A1)
    MOVE.B      -(A1),(A2)+
    MOVE.B      -(A2),-(A3)
    MOVE.W      D0,D1
    MOVE.W      D1,(A4)
    MOVE.W      D2,(A5)+
    MOVE.W      D3,-(A6)
    MOVE.W      A0,D4
    MOVE.W      A1,(A2)
    MOVE.W      A2,(A3)+
    MOVE.W      A3,-(A4)
    MOVE.W      (A4),D5
    MOVE.W      (A5),(A6)
    MOVE.W      (A0),(A1)+
    MOVE.W      (A1),-(A2)
    MOVE.W      (A2)+,D0
    MOVE.W      (A3)+,(A1)
    MOVE.W      (A4)+,(A1)+
    MOVE.W      (A5)+,-(A1)
    MOVE.W      -(A6),D0
    MOVE.W      -(A1),(A1)
    MOVE.W      -(A2),(A1)+
    MOVE.W      -(A3),-(A1)
    MOVE.L      D0,D1
    MOVE.L      D1,(A0)
    MOVE.L      D2,(A0)+
    MOVE.L      D3,-(A0)
    MOVE.L      A0,D0
    MOVE.L      A1,(A1)
    MOVE.L      A2,(A1)+
    MOVE.L      A3,-(A1)
    MOVE.L      (A4),D0
    MOVE.L      (A5),(A1)
    MOVE.L      (A6),(A1)+
    MOVE.L      (A0),-(A1)
    MOVE.L      (A1)+,D0
    MOVE.L      (A2)+,(A1)
    MOVE.L      (A3)+,(A1)+
    MOVE.L      (A4)+,-(A1)
    MOVE.L      -(A5),D0
    MOVE.L      -(A6),(A1)
    MOVE.L      -(A0),(A1)+
    MOVE.L      -(A1),-(A1)
    MOVEA.W     D0,A0
    MOVEA.W     A2,A0
    MOVEA.W     (A3),A0
    MOVEA.W     (A4)+,A0
    MOVEA.W     -(A5),A0
    MOVEA.L     D1,A0
    MOVEA.L     A6,A0
    MOVEA.L     (A0),A0
    MOVEA.L    (A1)+,A0
    MOVEA.L    -(A2),A0  
    NOT         D1
    NOT         (A1)
    NOT         -(A2)
    NOT         (A3)+
    OR.B        D5,D2    
    OR.B        D6,(A1)
    OR.B        D0,(A1)+
    OR.B        D1,-(A1)
    OR.B        (A6),D1
    OR.B        (A0)+,D1
    OR.B        -(A1),D1
    OR.W        D2,D3
    OR.W        D3,(A1)
    OR.W        D4,(A1)+
    OR.W        D1,-(A1)
    OR.W        (A2),D1
    OR.W        (A3)+,D1
    OR.W        -(A4),D1
    OR.L        D0,D2
    OR.L        D1,(A1)
    OR.L        D2,(A1)+
    OR.L        D3,-(A1)
    OR.L        (A5),D1
    OR.L        (A6)+,D1
    OR.L        -(A0),D1
    ROL.B       D4,D2
    ROL.W       D5,D2
    ROL.W       (A1) 
    ROL.W       (A2)+ 
    ROL.W       -(A3)
    ROL.L       D1,D2
    ROR.B       D2,D3
    ROR.W       D3,D2
    ROR.W       (A4)
    ROR.W       (A5)+
    ROR.W       -(A6)
    ROR.L       D4,D2
    ROL.B       #1,D3
    ROR.B       #1,D4    
    SUB.B       D0,D2
    SUB.B       D1,(A1)
    SUB.B       D2,(A1)+
    SUB.B       D3,-(A1)
    SUB.B       (A5),D1
    SUB.B       (A6)+,D1
    SUB.B       -(A0),D1
    SUB.W       D4,D2
    SUB.W       D5,A1
    SUB.W       D6,(A1)
    SUB.W       D0,(A1)+
    SUB.W       D1,-(A1)
    SUB.W       A1,D1
    SUB.W       (A2),D1
    SUB.W       (A3)+,D1
    SUB.W       -(A4),D1
    SUB.L       D2,D3
    SUB.L       D3,(A1)
    SUB.L       D4,(A1)+
    SUB.L       D5,-(A1)
    SUB.L       A5,D1
    SUB.L       (A6),D1
    SUB.L       (A0)+,D1
    SUB.L       -(A1),D1    
    BGT.B       label1
    BGT.B       label2
    BLE.B       label1
    BLE.B       label2
    BGE.B       label1 *
    BEQ.B       label2
    BEQ.W       label1
    JSR         (A0)
    JSR         $1234
    JSR         $12345678
    JSR         label1
    JSR         label2
    JSR         label3
    NOP
    RTS
label1
    NOP
    RTS
    LEA         $12,A0
    LEA         $1234,A0
    LEA         $12345678,A0
label2
    MOVEQ       #$0,D0
    MOVEQ       #$12,D1
    MOVEQ       #$FF,D2
label3
    MOVEM.W     A1-A7,$12
    MOVEM.L     D1-D7,$12
    MOVEM.W     A1/D7,$12
    MOVEM.L     A1/D7,$12
    MOVEM.W     A1-A7,$1234
    MOVEM.L     D1-D7,$1234
    MOVEM.W     A1/D7,$1234
    MOVEM.L     A1/D7,$1234
    MOVEM.W     A1-A7,$12345678
    MOVEM.L     D1-D7,$12345678
    MOVEM.W     A1/D7,$12345678
    MOVEM.L     A1/D7,$12345678
    MOVEM.W     $12,A1-A7
    MOVEM.L     $12,D1-D7
    MOVEM.W     $12,A1/D7
    MOVEM.L     $12,A1/D7
    MOVEM.W     $1234,A1-A7
    MOVEM.L     $1234,D1-D7
    MOVEM.W     $1234,A1/D7
    MOVEM.L     $1234,A1/D7
    MOVEM.W     $12345678,A1-A7
    MOVEM.L     $12345678,D1-D7
    MOVEM.W     $12345678,A1/D7
    MOVEM.L     $12345678,A1/D7
    MOVEM.W     A1-A7,(A1)
    MOVEM.L     D1-D7,(A1)
    MOVEM.W     A1/D7,(A1)
    MOVEM.L     A1/D7,(A1)
    MOVEM.W     A1-A7,-(A1) 
    MOVEM.L     D1-D7,-(A2)
    MOVEM.W     A2-A6,-(A3) 
    MOVEM.L     D3-D4,-(A4)
    MOVEM.W     A4-A5,-(A5) 
    MOVEM.L     D5-D6,-(A6)        
    MOVEM.W     (A1)+,A1-A7
    MOVEM.L     (A1)+,D1-D7
    MOVEM.W     (A1)+,A1/D7
    MOVEM.L     (A1)+,A1/D7
    MOVEM.W     (A1),A1-A7
    MOVEM.L     (A1),D1-D7
    MOVEM.W     (A1),A1/D7
    MOVEM.L     (A1),A1/D7
    BGT.B       label4
    LSL.B       #$1,D2
    LSL.W       #$2,D2
    LSL.L       #$3,D2
    LSL.W       $12
    LSL.W       $1234
    LSL.W       $12345678
    ASR.B       #$1,D2
    ASR.W       #$2,D2
    ASR.L       #$3,D2
    ASR.W       $12
    ASR.W       $1234
    ASR.W       $12345678
label4
    BLE.W       START
    BLE.W       label2
    BLE.W       label3
    BEQ.W       label1
    BEQ.W       label3
    BEQ.L       START
    BEQ.L       label1
    BEQ.L       label2
    BEQ.L       label3
    BRA         label1
    BRA         label2
    BRA         label3       
    JSR         label1
    JSR         label2
    JSR         label3


    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
