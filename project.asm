.ORIG x3000

;~~~~~~~~~~~~~~~~~~~~MAIN PROGRAM~~~~~~~~~~~~~~~~~~~~
; Description: Calls subroutines to create a
;              functional assembly program
; Inputs: N/A
; Outputs: Max, Min, Avg printed to console
; Registers Used: R1-R4
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
LD	R1, testNum	; Load the number of test scores to process
LEA	R2, testArray
LEA	R3, charArray
LEA	R4, startMsg
JSR	GetTestScores	; Read and store user input scores with validation and grade output
LD	R1, testNum	; Load the number of test scores to process
JSR	FindMax	; Subroutine to find the maximum test score
LEA	R2, charArray
JSR	ConvertInt	; Convert integer in R1 to ASCII and store in charArray
LEA	R0, maxMsg
PUTS
LEA	R0, charArray
PUTS
LD	R1, testNum	; Load the number of test scores to process
LEA	R2, testArray
JSR	FindMin
LEA	R2, charArray
JSR	ConvertInt	; Convert integer in R1 to ASCII and store in charArray
LEA	R0, minMsg
PUTS
LEA	R0, charArray
PUTS
LD	R1, testNum	; Load the number of test scores to process
LEA	R2, testArray
JSR	FindAvg	; Subroutine to compute average of test scores
LEA	R2, charArray
JSR	ConvertInt	; Convert integer in R1 to ASCII and store in charArray
LEA	R0, avgMsg
PUTS
LEA	R0, charArray
PUTS
HALT
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~INITIALIZING VARIABLES~~~~~~~~~~~~~~~
startMsg	.STRINGZ	"Enter a test score: "
charErrorMsg	.STRINGZ	"ERROR: Invalid character entered.\n"
numErrorMsg	.STRINGZ	"ERROR: Invalid number entered.\n"
gradeMsg	.STRINGZ	"Grade: "
maxMsg	.STRINGZ	"\nMax: "
minMsg	.STRINGZ	"\nMin: "
avgMsg	.STRINGZ	"\nAvg: "
tempR		.FILL	0x0
testNum	.FILL	0x5
testArray	.FILL	0x0
		.FILL	0x0
		.FILL	0x0
		.FILL	0x0
		.FILL	0x0
charArray	.FILL	0x0
		.FILL	0x0
		.FILL	0x0
		.FILL	0x0
		.FILL	0x0
pointer		.FILL	0x6000
asciiA		.FILL	0x41
nhundred	.FILL	-100
ninety		.FILL	90
sixty		.FILL	60
nzAscii		.FILL	-48
zAscii		.FILL	48
newline	.FILL	x000A
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~PUSH SUBROUTINE~~~~~~~~~~~~~~~~~~~
; Description: Pushes R0 onto a stack at 
;              memory[pointer]
; Inputs: R0 (value to push)
; Outputs: Stack updated
; Registers Used: R0, R1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Push
ST	R1, tempR
LD	R1, pointer
ADD 	R1, R1, #-1
STR	R0, R1, #0
ST	R1, pointer
LD	R1, tempR
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~~POP SUBROUTINE~~~~~~~~~~~~~~~~~~~
; Description: Pops top value off the software stack
;              into R0
; Inputs: Stack contents at pointer
; Outputs: R0 = top of stack
; Registers Used: R0, R1
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Pop
ST	R1, tempR
LD	R1, pointer
LDR	R0, R1, #0
ADD 	R1, R1, #1
ST	R1, pointer
LD	R1, tempR
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~RETURNGRADE SUBROUTINE~~~~~~~~~~~~~~~
; Description: Assigns a letter grade (A-F) based on
;              numeric score in R1
; Inputs: R1 = score (0-100)
; Outputs: R1 = ASCII letter grade (A-F)
; Registers Used: R1-R5 (also uses stack)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ReturnGrade
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R2, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
ADD	R0, R4, #0
JSR 	Push
ADD	R0, R5, #0
JSR 	Push
LD	R2, asciiA
LD	R3, ninety
LD	R4, sixty
FindGrade
NOT	R5, R3
ADD	R5, R5, #1
ADD	R5, R5, R1
BRZP	EndFindGrade	; If R1 >= current grade threshold, finish grading
ADD	R3, R3, #-10
ADD	R2, R2, #1
NOT	R5, R4
ADD	R5, R5, #1
ADD	R5, R5, R3
BRZP	FindGrade
ADD	R2, R2, #1
EndFindGrade
ADD	R1, R2, #0
JSR	Pop
ADD	R5, R0, #0
JSR	Pop
ADD	R4, R0, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R2, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~CONVERTASCII SUBROUTINE~~~~~~~~~~~~~~~
; Description: Converts an ASCII string (in R3) to
;              integer in R1
; Inputs: R3 = address of ASCII string ending with 0
; Outputs: R1 = numeric result
; Registers Used: R1-R5 (also uses stack)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ConvertAscii
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R2, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
ADD	R0, R4, #0
JSR 	Push
ADD	R0, R5, #0
JSR 	Push
AND	R2, R2, #0
ADD	R2, R2, #10
ADD	R3, R1, #0
AND	R1, R1, #0
LD	R4, nzAscii
ConvertA
LDR	R5, R3, #0
ADD	R5, R5, #0
BRZ	EndConvertA
ADD	R5, R5, R4
JSR	Mult	; Multiply two values using repeated addition
ADD	R1, R1, R5
ADD	R3, R3, #1
BR	ConvertA
EndConvertA
JSR	Pop
ADD	R5, R0, #0
JSR	Pop
ADD	R4, R0, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R2, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~CONVERTINT SUBROUTINE~~~~~~~~~~~~~~~~
; Description: Converts integer in R1 into ASCII
;              string at R2
; Inputs: R1 = integer value
; Outputs: Memory[R2] = null-terminated ASCII string
; Registers Used: R0-R6 (also uses stack)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
ConvertInt
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R1, #0
JSR 	Push
ADD	R0, R2, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
ADD	R0, R4, #0
JSR 	Push
ADD	R0, R5, #0
JSR 	Push
ADD	R3, R1, #0
ADD	R4, R2, #0
AND	R5, R5, #0
CountDigit
ADD	R5, R5, #1
AND	R2, R2, #0
ADD	R2, R2, #10
JSR	Div	; Divide R1 by R2 using repeated subtraction
ADD	R1, R2, #0
BRNP 	CountDigit
ADD	R5, R5, R4
AND	R0, R0, #0
STR	R0, R5, #0
ADD	R1, R3, #0
LD	R3, zAscii
ConvertI
AND	R2, R2, #0
ADD	R2, R2, #10
JSR	Div	; Divide R1 by R2 using repeated subtraction
ADD	R1, R1, R3
ADD	R5, R5, #-1
STR	R1, R5, #0
ADD	R1, R2, #0
BRNP 	ConvertI
JSR	Pop
ADD	R5, R0, #0
JSR	Pop
ADD	R4, R0, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R2, R0, #0
JSR	Pop
ADD	R1, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~GETTESTSCORES SUBROUTINE~~~~~~~~~~~~~
; Description: Prompt user for N test scores, validate,
;              store, and print grades.
; Inputs: R1 - number of scores
;         R2 - address of score storage array
;         R3 - address of buffer for string input
;         R4 - address of prompt string
; Outputs: testArray filled, grades printed,
;          R1 = last score entered
; Registers Used: R0-R6 (also uses stack)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GetTestScores
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R1, #0
JSR 	Push
ADD	R0, R2, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
ADD	R0, R4, #0
JSR 	Push
ADD	R0, R5, #0
JSR 	Push
ADD	R0, R6, #0
JSR 	Push
ADD	R6, R4, #0
ADD	R4, R1, #0
GetScore	; Start of loop to collect and process one test score
ADD	R0, R6, #0
PUTS
ADD	R5, R3, #0
Input
GETC
OUT
ADD	R1, R0, #-10
BRZ	InputEnd
STR	R0, R5, #0
ADD	R5, R5, #1
BR	Input
InputEnd
AND	R0, R0, #0
STR	R0, R5, #0
ADD	R1, R3, #0
JSR	ConvertAscii
ValidateRange
ADD	R0, R1, #0
JSR 	Push
AND 	R0, R0, #0
LD	R5, nhundred
ADD 	R0, R5, R1
BRP 	InvalidRange
BR	Continue
InvalidRange
JSR 	Pop
ADD	R1, R0, #0
LEA	R0, numErrorMsg
PUTS
BR	GetScore	; Start of loop to collect and process one test score
Continue
JSR 	Pop
ADD	R3, R0, #0
JSR	ReturnGrade	; Determine letter grade based on numeric score
LEA	R0, gradeMsg
PUTS
ADD	R0, R1, #0
PUTC
LD	R0, newline
PUTC
ADD	R1, R3, #0
STR	R1, R2, #0
ADD	R2, R2, #1
ADD	R4, R4, #-1
BRP	GetScore	; Start of loop to collect and process one test score
JSR	Pop
ADD	R6, R0, #0
JSR	Pop
ADD	R5, R0, #0
JSR	Pop
ADD	R4, R0, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R2, R0, #0
JSR	Pop
ADD	R1, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~FINDMAX SUBROUTINE~~~~~~~~~~~~~~~~~
; Description: Finds max value in the array
; Inputs: R1 = size, R2 = base address
; Outputs: R1 = max value
; Registers Used: R0-R4
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FindMax
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R2, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
ADD	R0, R4, #0
JSR 	Push
ADD	R0, R5, #0
JSR 	Push
LDR	R3, R2, #0
MaxLoop
ADD	R1, R1, #-1
BRZ	EndMaxLoop
ADD	R2, R2, #1
LDR	R4, R2, #0
NOT	R5, R3
ADD	R5, R5, #1
ADD	R5, R5, R4
BRNZ	FoundMax
ADD	R3, R4, #0
FoundMax
BR	MaxLoop
EndMaxLoop
ADD 	R1, R3, #0
JSR	Pop
ADD	R5, R0, #0
JSR	Pop
ADD	R4, R0, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R2, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~FINDMIN SUBROUTINE~~~~~~~~~~~~~~~~~~
; Description: Finds min value in the array
; Inputs: R1 = size, R2 = base address
; Outputs: R1 = min value
; Registers Used: R0-R4
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FindMin
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R2, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
ADD	R0, R4, #0
JSR 	Push
ADD	R0, R5, #0
JSR 	Push
LDR	R3, R2, #0
MinLoop
ADD	R1, R1, #-1
BRZ	EndMinLoop
ADD	R2, R2, #1
LDR	R4, R2, #0
NOT	R5, R3
ADD	R5, R5, #1
ADD	R5, R5, R4
BRZP	FoundMin
ADD	R3, R4, #0
FoundMin
BR	MinLoop
EndMinLoop
ADD 	R1, R3, #0
JSR	Pop
ADD	R5, R0, #0
JSR	Pop
ADD	R4, R0, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R2, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~FINDAVG SUBROUTINE~~~~~~~~~~~~~~~~~~
; Description: Computes average from array
; Inputs: R1 = size, R2 = base address
; Outputs: R1 = average value
; Registers Used: R0-R4
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
FindAvg
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R2, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
ADD	R0, R4, #0
JSR 	Push
ADD	R0, R5, #0
JSR 	Push
ADD	R5, R1, #0
AND 	R3, R3, #0
AvgLoop
LDR	R4, R2, #0
ADD	R3, R3, R4
ADD	R2, R2, #1
ADD	R1, R1, #-1
BRNP	AvgLoop
ADD	R1, R3, #0
ADD	R2, R5, #0
JSR	Div	; Divide R1 by R2 using repeated subtraction
ADD	R1, R2, #0
JSR	Pop
ADD	R5, R0, #0
JSR	Pop
ADD	R4, R0, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R2, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~MULT SUBROUTINE~~~~~~~~~~~~~~~~~~~~
; Description: Multiplies R1 by R2, result in R1
; Inputs: R1, R2
; Outputs: R1 = R1 * R2
; Registers Used: R0, R2, R3
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Mult
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R2, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
AND	R3, R3, #0
MLoop
ADD	R1, R1, #0
BRZ	EndMLoop
ADD	R3, R3, R2
ADD	R1, R1, #-1
BR	MLoop
EndMLoop
ADD	R1, R3, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R2, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~~~~~~~~~~~~~~DIV SUBROUTINE~~~~~~~~~~~~~~~~~~~~
; Description: Divides R0 = R0 / R1
;              (R0=dividend, R1=divisor)
; Outputs: R0 = remainder, R1 = quotient
; Registers Used: R2, R3
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Div
ADD	R0, R7, #0
JSR 	Push
ADD	R0, R3, #0
JSR 	Push
ADD	R0, R4, #0
JSR 	Push
ADD	R0, R5, #0
JSR 	Push
AND	R3, R3, #0
NOT	R4, R2
ADD	R4, R4, #1
DLoop
ADD	R5, R4, R1
BRN	EndDLoop
ADD	R1, R1, R4
ADD	R3, R3, #1
BR	DLoop
EndDLoop
ADD	R2, R3, #0
JSR	Pop
ADD	R5, R0, #0
JSR	Pop
ADD	R4, R0, #0
JSR	Pop
ADD	R3, R0, #0
JSR	Pop
ADD	R7, R0, #0
RET
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.END
