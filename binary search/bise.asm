; PROGRAM :: ASSEMBLY LANGUAGE PROGRAM TO SEARCH A KEY ELEMENT IN A
;            LIST OF 'n' NUMBER USING THE BINARY SEARCH ALGORITHM

.MODEL SMALL

; MACRO TO DISPLAY THE MESSAGE....
DISPLAY MACRO MSG
        LEA DX, MSG
        MOV AH, 09H
        INT 21H
ENDM

.DATA
LIST DB 01H, 03H, 04H, 07H, 09H
NUMBER EQU ($-LIST)    ; number=5
KEY DB 08H             
MSG1 DB 0DH, 0AH, "ELEMENT FOUND IN THE LIST...$"
MSG2 DB 0DH, 0AH, "SEARCH FAILED !! ELEMENT NOT FOUND IN THE LIST $"

.CODE
START : MOV AX, @DATA  ;initi of memory
        MOV DS, AX



        MOV CH, NUMBER-1   ; HIGH VALUE...   CH=04
        MOV CL, 00H        ; LOW VALUE...


AGAIN:  MOV SI, OFFSET LIST
        XOR AX, AX          ; AX=00
        CMP CL, CH          ; 00  WITH 05
        JE NEXT
        JNC FAILED

NEXT:   MOV AL, CL           ;AL==00
        ADD AL, CH           ; AL=AL+CH   00+04=04
        SHR AL, 01H          ; AL=0100  0010  ;DIVIDE BY 2  MID ELEMENT POSITION

        MOV BL, AL           ;AL=02=BL
        XOR AH, AH           ; CLEAR AH
        MOV BP, AX           ;BP=0000
        MOV AL, DS:[BP][SI]  ; AL==[BP+SI]==[0000+0000] =01
        CMP AL, KEY             ; COMPARE KEY AND A[i]        
        JE SUCCESS              ; IF EQUAL, DISPLAY SUCCESS MESSAGE
        JC INCLOW


        MOV CH, BL              ; IF KEY>A[i]  SHIFT HIGH
        DEC CH
        JMP AGAIN
INCLOW: MOV CL, BL              ; IF KEY<A[i]  SHIFT LOW
        INC CL
        JMP AGAIN



SUCCESS:mov al,key


        add al,30h ;AL=05+30====35--ASCII VAL OF 5



        mov dl,al  ; DL=35  ASCII VAL OF 5
        mov ah,02h        ; 02=FV FOR DISPLAYING INTEGER VALUE
        int 21h           ; INT 21H     05 IS DISPLAYED





        DISPLAY MSG1  ; SEARCH IS SUCCESSFUL
        jmp final     ; MOV AH,4CH  INT 21H

 failed:mov al,key
        add al,30h


        mov dl,al
        mov ah,02h
        int 21h
               
        DISPLAY MSG2            ; JOB OVER. TERMINATE....


FINAL : mov ah,01h        ; GETCH()
        int 21h

        MOV AH, 4CH
        INT 21H
END START


