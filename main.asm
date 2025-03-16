;====================================================================
; DEFINITIONS
; EQU (equate): This is used to define a constant without occupying a memory location.
;====================================================================
IO_DECLERATION:
    LCD_PORT EQU P1          ; Assign P1 as LCD data port
    RS  EQU P3.0             ; RS for LCD
    MTR2_EN EQU P3.1         
    EN  EQU P3.2             ; EN  for LCD

    ADC_WR  EQU P3.3         ; Define ADC Write command pin

    MTR1_EN EQU P3.4
    MTR1_IN EQU P3.6
    MTR2_IN EQU P3.5
    BUZZER  EQU P3.7         ; Not Working Yet

    TEMP    EQU 30H
    PSET    EQU 31H
    L_NRML  EQU 32H
    H_NRML  EQU 33H
    TOO_HI  EQU 34H

;====================================================================
; Program initialization and interrupt vector setup
;====================================================================
    ORG 00H                 
    LJMP MAIN                
;====================================================================
; Main program starts here
;====================================================================
MAIN:
    MOV P3, #00H             
    MOV P1, #00H            
    MOV P2, #0FFH            
    MOV P0, #0FFH            

    MOV L_NRML, #28D
    MOV H_NRML, #35D
    MOV TOO_HI, #39D

    ACALL LCD_INIT           
    MOV R0, #80H             ; Force the cursor to the beginning of 1st Line
    ACALL CMND_WRT           
    MOV DPTR, #MSG1          ; Temp.(C):
    ACALL PRNT_STRNG         

MAIN_LOOP:
    MOV R0, #08BH            ; Display Off, Cursor Off
    ACALL CMND_WRT           

    CLR ADC_WR               
    SETB ADC_WR              
RD_ADC:
    MOV A, P2               
    MOV TEMP, A              
    ACALL BIN_2_ASCII        
    ACALL CHECK_TEMP        
    LJMP MAIN_LOOP          

;====================================================================
; Subroutine to check the temperature and set the system status
;====================================================================
CHECK_TEMP:
    MOV A, TEMP
    SUBB A, TOO_HI
    JNC _2HI

    MOV A, TEMP              
    SUBB A, H_NRML           
    JNC _HI                  

    MOV A, TEMP             
    SUBB A, L_NRML          
    JC _LO                 

_NRM:
    JMP TMP_OK               
_2HI:
    JMP TMP_2HI             
_HI:
    JMP TMP_HI               
_LO:
    JMP TMP_LO             

;====================================================================
; Subroutines for different temperature statuses
;====================================================================
TMP_OK:
    SETB MTR1_EN             
    CLR MTR2_EN              
    SETB BUZZER              
    MOV DPTR, #STR_NR          ; NORMAL
    ACALL PRNT_STAT          
    RET                      

TMP_HI:
    SETB MTR1_EN             
    CLR MTR2_EN              
    MOV DPTR, #STR_HI        ; HIGH
    ACALL PRNT_STAT          
    RET                      

TMP_2HI:
    CLR MTR1_EN              
    SETB MTR2_EN             
    MOV DPTR, #STR_2H        ; Danger
    ACALL PRNT_STAT          
    RET                      

TMP_LO:
    CLR MTR1_EN              
    CLR MTR2_EN              
    MOV DPTR, #STR_LO        ; LOW
    ACALL PRNT_STAT          
    RET                      

;====================================================================
; Subroutine to print status messages on the LCD
;====================================================================
PRNT_STAT:
    MOV R0, #0C0H            ; Force the cursor to the beginning of 2nd Line
    ACALL CMND_WRT           
PRNT_STRNG:
    CLR A                    
    MOVC A, @A+DPTR          ; Move code byte relative to DPTR to accumulator
    MOV R0, A                
    JZ END_STRNG             ; If zero, end string
    ACALL DATA_WRT           
    ACALL DELAY              
    INC DPTR                 
    SJMP PRNT_STRNG          
END_STRNG:
    RET                      

;====================================================================
; Subroutine to convert binary to ASCII for display
;====================================================================
BIN_2_ASCII:
    MOV R7, #10D             
    MOV A, TEMP             
    MOV B, R7               
    DIV AB                   ; Divide A by B, result in A (quotient), B (remainder)
    ADD A, #30H              ; Convert quotient to ASCII
    MOV R0, A                
    ACALL DATA_WRT           
    MOV A, B                 
    ADD A, #30H              ; Convert remainder to ASCII
    MOV R0, A                
    ACALL DATA_WRT          
    RET                      

;====================================================================
; LCD initialization and command/data write subroutines
;====================================================================
LCD_INIT:
    MOV R0, #38H             ; Function set: 2 lines, 5x7 matrix
    ACALL CMND_WRT           
    MOV R0, #0EH             ; Display on, cursor on
    ACALL CMND_WRT           
    MOV R0, #01H             ; Clear display
    ACALL CMND_WRT           
    MOV A, #06H              ; Entry mode set: increment cursor
    ACALL CMND_WRT          
    MOV R0, #80H             ; Force cursor to beginning of 1st line
    ACALL CMND_WRT           
    MOV A, #3CH              ; Activate second line
    ACALL CMND_WRT           
    RET                      

DATA_WRT:
    MOV LCD_PORT, R0         
    SETB RS                  
    SETB EN                  ; Enable LCD to latch data
    ACALL DELAY              
    CLR EN                   ; Disable LCD
    RET                      

CMND_WRT:
    MOV LCD_PORT, R0         
    CLR RS                   
    SETB EN                  ; Enable LCD to latch command
    ACALL DELAY             
    CLR EN                   ; Disable LCD
    RET                      

DELAY:
    MOV R0, #10               
Y:	MOV R1, #255
	DJNZ R1, $
	DJNZ R0, Y
    RET

;====================================================================
; Data and message strings stored in program memory
;====================================================================
ORG 200H                    
MSG1: DB "Temp.(C):", 0     
STR_2H: DB 'DANGER', 0      
STR_HI: DB 'HIGH  ', 0      
STR_NR: DB 'NORMAL', 0      
STR_LO: DB 'LOW   ', 0      

END