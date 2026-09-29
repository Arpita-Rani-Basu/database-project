.MODEL SMALL
.STACK 100H

.DATA 
MSG_TITLE DB 0DH,0AH
              DB '=================================',0DH,0AH
              DB '       EMPLOYEE SALARY CALCULATOR',0DH,0AH
              DB '=================================',0DH,0AH,'$'


 MSG_BASIC DB 0DH,0AH,'Enter Basic Salary: $'
    MSG_ALLOW DB 0DH,0AH,'Enter Allowance: $'
    MSG_BONUS DB 0DH,0AH,'Enter Bonus: $'
    MSG_DEDUCT DB 0DH,0AH,'Enter Deduction: $'

    MSG_GROSS DB 0DH,0AH,0DH,0AH
              DB 'Gross Salary : $'

    MSG_NET DB 0DH,0AH
            DB 'Net Salary   : $'

    MSG_BYE DB 0DH,0AH,0DH,0AH
            DB 'Press any key to exit...$'

    BASIC_SALARY DW 0
    ALLOWANCE    DW 0
    BONUS        DW 0
    DEDUCTION    DW 0

    GROSS_SALARY DW 0
    NET_SALARY   DW 0


.CODE

MAIN PROC

    MOV AX, @DATA
    MOV DS, AX

   

    LEA DX, MSG_TITLE
    MOV AH, 09H
    INT 21H

    LEA DX, MSG_BASIC
    MOV AH, 09H
    INT 21H

    CALL READ_NUM
    MOV BASIC_SALARY, AX

    LEA DX, MSG_ALLOW
    MOV AH, 09H
    INT 21H

    CALL READ_NUM
    MOV ALLOWANCE, AX  
    
    LEA DX, MSG_BONUS
    MOV AH, 09H
    INT 21H

    CALL READ_NUM
    MOV BONUS, AX  
    CALL CALCULATE_SALARY 

    LEA DX, MSG_GROSS
    MOV AH, 09H
    INT 21H

    MOV AX, GROSS_SALARY
    CALL PRINT_DECIMAL
    LEA DX, MSG_NET
    MOV AH, 09H
    INT 21H

    MOV AX, NET_SALARY
    CALL PRINT_DECIMAL


    

    LEA DX, MSG_BYE
    MOV AH, 09H
    INT 21H

    MOV AH, 01H
    INT 21H


    MOV AH, 4CH
    INT 21H

MAIN ENDP



READ_NUM PROC

   
    PUSH BX
    PUSH CX
    PUSH DX

    XOR BX, BX

READ_LOOP:

    MOV AH, 01H
    INT 21H

    
    CMP AL, 0DH
    JE READ_DONE

    
    CMP AL, '0'
    JB READ_LOOP

    CMP AL, '9'
    JA READ_LOOP

    
    SUB AL, '0'
    XOR AH, AH

    
    PUSH AX

    
    MOV AX, BX
    MOV CX, 10
    MUL CX
    MOV BX, AX

    
    POP AX

    
    ADD BX, AX

    JMP READ_LOOP


READ_DONE:

    MOV AX, BX

    
    POP DX
    POP CX
    POP BX

    RET

READ_NUM ENDP



CALCULATE_SALARY PROC

  

    MOV AX, BASIC_SALARY

    
    PUSH AX

    MOV AX, ALLOWANCE

   
    PUSH AX

    MOV AX, BONUS

    
    PUSH AX


    

    POP AX
    MOV BX, AX

    
    POP AX
    ADD BX, AX

    
    POP AX
    ADD BX, AX

   
    MOV GROSS_SALARY, BX




    MOV AX, GROSS_SALARY

    PUSH AX

    MOV AX, DEDUCTION

    PUSH AX


    
    POP CX

    
    POP AX

    
    SUB AX, CX

    MOV NET_SALARY, AX

    RET

CALCULATE_SALARY ENDP

PRINT_DECIMAL PROC

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, 10
    XOR CX, CX


    
    CMP AX, 0
    JNE CONVERT

    MOV DL, '0'
    MOV AH, 02H
    INT 21H

    JMP PRINT_DONE


CONVERT:

DIVIDE_LOOP:

    XOR DX, DX

    DIV BX

    
    PUSH DX

    INC CX

    CMP AX, 0
    JNE DIVIDE_LOOP


PRINT_LOOP:

    
    POP DX

    ADD DL, '0'

    MOV AH, 02H
    INT 21H

    LOOP PRINT_LOOP


PRINT_DONE:

    POP DX
    POP CX
    POP BX
    POP AX

    RET

PRINT_DECIMAL ENDP


END MAIN   