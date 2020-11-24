; PROGRAM :: SORT A GIVEN SET OF 'N' NUMBERS IN ASCENDING AND DESCENDING
; ORDER USING BUBBLE SORT ALGORITHM

.MODEL SMALL

DISPLAY MACRO MSG          ; DISPLAY-NAME OF MACRO, MACRO -KEYWORD, VARIABLE
        LEA DX, MSG             ; BODY OF MACRO
        MOV AH, 09H
        INT 21H
ENDM                            ; END OF MACRO



.DATA
LIST DB 02H, 01H, 34H, 0F4H, 09H, 05H           ; array declarartion

NUMBER EQU $-LIST       ; $--last address of number,  list-address of first num
                        ; last-first address==number of elements in array
                         ; number equ 06h  symb decl



MSG1 DB 0DH, 0AH, "1 >> SORT IN ASCENDING ORDER$"    ; string===== "  $"
MSG2 DB 0DH, 0AH, "2 >> SORT IN DESCENDING ORDER$"
MSG3 DB 0DH, 0AH, "3 >> EXIT$"                  ; 0A==NEWLINE CRETAION
MSG4 DB 0DH, 0AH, "ENTER YOUR CHOICE  :: $"     ; 0D--NEXT LINE--ENTERKEY
MSG5 DB 0DH, 0AH, "INVALID CHOICE ENTERED...$"
                      ;  ===
.CODE
START : MOV AX, @DATA
        MOV DS, AX


        LEA SI, LIST  ; MOV SI, OFFSET LIST    for (i=0,i<count;i++)

        MOV CH, NUMBER-1  ; CH STORES THE NUMBER OF ELEMENTS IN LIST

        DISPLAY MSG1              ; DISPLAY IS NAME OF MACRO
        DISPLAY MSG2
        DISPLAY MSG3
        DISPLAY MSG4


        MOV AH, 01H         ; 01--FV--READ IP FM KB
        INT 21H

        SUB AL, 30H   ; 1===31 IN ASCII  THAT WILL BE STORED IN AL REGISTER

        CMP AL, 01H             ; INPUT=1? SORT IN ASCENDING ORDER
        JE ASCSORT    ;JZ ASCSORT JUMP IF EQUAL  JUMP TO SPECIFIED LABEL
        CMP AL, 02H             ; INPUT=2? SORT IN DESCENDING ORDER
        JE DESSORT              ; JUMP TO LABEL DESSORT IF EQUAL
        CMP AL, 03H             ; INPUT=3? EXIT
        JE FINAL         ; EXIT FM PGM  MOV AH,4CH INT 21H
        DISPLAY MSG4        ; INVALID CHOICE 
        JMP FINAL


ASCSORT:   MOV BL, 00H ; BL=00


AGAIN:  MOV SI, OFFSET LIST   ;  SI--POINTING TO ARRAY(LIST) ; 1ST ELEMNT
        MOV CL, 00H             ; J VALUE    1----N-1    2--N
        MOV BH, CH    ; NUMBER-1==CH
        SUB BH, BL   ;    5-0          ; N-1-i
NPASS:  CMP CL, BH   ; 1ST > 2ND   00,05
        JNC NEXT             ; BASED ON CF   NUM IS > OR < IS IDENTIFIED 
        MOV AL, [SI]         ; 1ST < 2ND    1ST ELE==AL
        MOV BP, 01H
        CMP AL, DS:[BP][SI] ;  BP==01  SI==00===BP+SI==[01]     1 CMP WITH 2
        JC _NOPE                  ; SORTED IN ASC ORDER  CF== 1<2  02 < 01
        XCHG AL, [SI+1]  ;  AL==1ST   [SI+1]==[01]  02 01===02  02
        XCHG [SI], AL     ;   [01] , 01====  01, 02
_NOPE : INC CL
        INC SI        ; SI WILL POINT NEXT NUMBER
        JMP NPASS

NEXT:   INC BL
        CMP BL, CH              ;01 05
        JC AGAIN
        JMP FINAL                ; EXIT STMT




DESSORT:MOV BL, 00H
AGAIN1: MOV SI, OFFSET LIST
        MOV CL, 00H             ; J VALUE
        MOV BH, CH
        SUB BH, BL              ; N-1-i
NPASS1: CMP CL, BH
        JNC NEXT1
        MOV AL, [SI]
        MOV BP, 01H
        CMP AL, DS: [BP][SI]
        JNC _NOPE1               ; SORTED IN DESC ORDER
        XCHG AL, [SI+1]
        XCHG [SI], AL
_NOPE1: INC CL
        INC SI
        JMP NPASS1
NEXT1:  INC BL
        CMP BL, CH
        JC AGAIN1





FINAL : MOV AH, 4CH
        INT 21H
END START
