;+-------------------------------------------+
;|   Pep/8 Assembly Language
;|   ========================================
;|   Multiply, Divide, Add, Subtract
;|   ========================================
;|   Author:   admin@jcink.com
;|   Modified: 3:13 AM Monday, April 15, 2013
;|   ========================================
;+-------------------------------------------+

;+-------------------------------------------
;| Prologue: This program handles small, basic 
;| numbers and adds, subtracts, multiplies, 
;| and divides them. There are three inputs,
;| num1 and num2 and the operator of choice.
;| Supported operators are +,-,*,/
;| The addition and subtraction use Pep/8's 
;| add and subtract mneumonics, while the
;| multiplication and division use 
;| shift-and-add/subtract algorithms to get
;| the result. Pep/8 has no multiply or divide
;| menumonics by default.
;|
;| Remember to run this program using the 
;| Terminal I/O tab and not Batch I/O
;+-------------------------------------------

BR      main        

;******** int multiply (int mcand, int mpr) ********
;
; Shift-and-Add algorithm for multiplication in pep8
;
; 1. Infinite while loop for checking that mpr is
;    not equal to zero.
;
; 2.  Modulus of mpr is gotten by masking all but
;    the right most bit to see tell if it has a 
;    remainder or not.
;
; 3. The shift operations run as long as the mpr is
;    not zero, and mpr is right shifted while the
;    mcand is left shifted until it can't be anymore
;    in which the sum is returned which we allocated
;    on the stack earlier in the function and set it to 0 

; 4. Return the sum 
;  
;******************************************************

sum:     .EQUATE 0           ;local variable   #2d
mpr:     .EQUATE 4           ;formal parameter #2d
mcand:   .EQUATE 6           ;formal parameter #2d
retVal2: .EQUATE 8           ;returned value   #2d

multiply: LDA     0x0000,i   
          SUBSP   2,i              ;allocate #sum 
          LDA     0,i
          STA     sum,s            ;int sum = 0;     

while1:   LDA 0x0000,s;            while (mpr) { 
     
          LDA mpr, s	           ;load the muliplier 
          ANDA 0x0001,i            ;mask all but rightmost bit
          CPA  1,i                 ;if (mpr % 2 == 1)
          BRNE shiftops            ;skip to the bit shifting operations if it's not 1
          LDA  sum,s               ;load sum
          ADDA mcand,s             ;add the multiplicand to the sum
          STA  sum,s               ;add to the sum
        
shiftops: LDA mpr,s               ;load the multiplier 
          ASRA 	          	;arithmetic shift right mpr
          STA mpr,s               ;push mpr

          LDA mcand,s             ;load the multiplicand
          ASLA 	           ;arithmetic shift left mcand
          STA mcand,s             ;push mcand

          LDA mpr,s               ;load mpr
          CPA     0,i             ;check if mpr is 0
          BREQ    endWh1          ;end the while loop if 0
          BR      while1          ;continue looping
    
endWh1:   LDA sum,s;
          STA retVal2,s
          RET2                    ;pop #sum
		
;******** int divide (int dvnd, int dvr) ************
;
; Shift-and-Subtract algorithm for division in pep8
;
; 1. Allocate the varirables shifts, quotient, and remaindr 
;    on the stack. 6 bytes for 3 new integers.
;
;  2. Check to see if the left shift of the divisor
;    is greater than or equal to the dividend
;
;  3. While the dividend is greater than or equal to dvnd
;    do a shift operation on dvr to the left and increaase
;    the shift count
;
;  4. While the shifts are greater than 0, do two ops:
;
;     a. Check if dvr is greater than or equal to quotient
;        and +1 it and subtract the dvr  from the dvnd
;
;     b. Regardless of the if statement, shift dvr to the
;        right and shift the quotient to the left.
;
;     c. Subtract 1 from shifts

;  5. Check if the dvr is less than or equal to the remaindr
;     and then add 1 to the quotient, and set the remaindr
;     to dvnd - dvr.
;
;     Else, check if dvr is greater than dvnd and just set
;     the remainder to that.
;
;  6. Return the quotient.
;  
;******************************************************

remaindr:  .EQUATE 0           ;local variable #2d
quotient:  .EQUATE 2           ;local variable #2d
shifts:    .EQUATE 4           ;local variable #2d 

dvr:       .EQUATE 8           ;formal parameter #2d
dvnd:      .EQUATE 10          ;formal parameter #2d

retVal3:  .EQUATE 12           ;returned value #2d

divide:   LDA     0x0000,i
          SUBSP   6,i               ; pop #shifts #quotient #remaindr   

          STA     shifts,s          ;shifts = 0;     
          STA     quotient,s        ;quotient = 0;   
          STA     remaindr,s        ;quotient = 0;  
      
          LDA dvr,s;  ;load the divisor
          ASLA        ;left shift the accumulator
          CPA dvnd,s  ;if ((dvr << 1) <= dvnd)
          BRLE while2        
          BR if2        ;skip all of this and go to the second if statement
                        ;outside the while loop 

while2:   LDA 0,i;     ;while (dvr <= dvnd) {

          LDA dvr,s    ;load the divisor
          ASLA         ;left shift the divisor
          STA dvr,s    ;push dvr 

          LDA shifts,s  ;load the shift counter
          ADDA 1,i      ;shifts++;
          STA shifts,s  ;push shifts
 
          LDA dvr,s
          CPA dvnd,s    
          BRLE while2  ;continue looping...  }
  
while3:   LDA 0,i                 ;while (shifts > 0 ) {
      
          LDA dvr,s               ;load the dvr
          CPA dvnd,s              ;if (dvr <= dvnd) {
          BRLE w3_if 
          BR loopshif 

w3_if:    LDA quotient,s          ;load the quotient
          ADDA 1,i 	              ;quotient += 1;
          STA quotient,s          ;push quotient

          LDA  dvnd,s              ;load the quotient
          SUBA dvr,s 	            ;dvnd -= dvr;
          STA  dvnd,s              ;push dvnd 

w3_endif: LDA 0,i                 ; }

loopshif: LDA dvr,s               ;load the dvr
          ASRA 	           ;arithmetic shift right dvr
          STA dvr,s               ;push dvr

          LDA quotient,s          ;load the quotient
          ASLA 	           ;arithmetic shift left quotient
          STA quotient,s          ;push quotient

          LDA shifts,s  ;load the shift counter
          SUBA 1,i      ;shifts--;
          STA shifts,s  ;push shifts

          LDA shifts,s;
          CPA 0,s      
          BRGT while3  ;continue looping... }            

if2:     LDA dvr,s               ;load the dvr
         CPA dvnd,s              ;if (dvr <= dvnd) {
         BRLE if4

         LDA dvr,s               ;load the dvr
         CPA dvnd,s              ;else if (dvr > dvnd)
         BRGT if5
         BR endfunc3

if4:     LDA quotient,s          ;load the quotient
         ADDA 1,i 	          ;quotient += 1;
         STA quotient,s          ;push quotient

         LDA  dvnd,s              ;load the quotient
         SUBA dvr,s 	           ;remainder = dvnd - dvr
         STA  remaindr,s          ;push remaindr 
         
         BR endfunc3; 

if5:     LDA  dvnd,s              ;load the quotient
         STA  remaindr,s          ;push remaindr 
                
endfunc3: LDA quotient,s          ;Load the quotient, and return it!
          STA retVal3,s
          RET6                   ;pop #remaindr #quotient #shifts 

;********int doMath (int num1, int num2, char op) ********
;
; Handles addition, subtraction, multiplication and division
;
; 1. CPA is used to check the op character, which is one byte,
;    and this determines which section to branch to.
;
; 2. The addition and subtraction use ADDA and SUBA to complete
;    those operations and simply return the value.
;
; 3. Two function calls are here; one to the multiply function
;    and one to the division function for those routines.
;
;***********************************************************

opchar:   .EQUATE 2           ;formal parameter #1d
n2:       .EQUATE 3           ;formal parameter #2d
n1:       .EQUATE 5           ;formal parameter #2d
retVal:   .EQUATE 7           ;returned value #2d 

doMath:  LDA 0x0000,i
         LDBYTEA opchar,s       

; ---------------------------------
; => if statement to check for addition
; => Simple addtion operation
; ---------------------------------

addif:    CPA     '+',i       ;if (op  == '+') {      
          BREQ    add;
          BRNE    subif;

add:      LDA     n1,s       ;get n1 into accumulator
          ADDA    n2,s       ;add n2 to accumulator
          STA     retVal,s   ;val = num1 + num2
          BR      endFunc1   ;exit the conditional    

; ------------------------------------------
; => 'else if' to check for subtraction
; ==> Simple subtraction operation
; ------------------------------------------

subif:    CPA     '-',i       ;else if (op == '-')     
          BREQ    sub;
          BRNE    mltplyif; 

sub:      LDA     0x0000,s
          LDA     n1,s        ;get n1 into accumulator
          SUBA    n2,s        ;subtract n2 to accumulator
          STA     retVal,s    ;val = num1 - num2
          BR      endFunc1;   ;exit the conditional  

; ------------------------------------------
; => 'else if' to check for multiplication
; ==> call to multiply function
; -----------------------------------------

mltplyif: CPA     '*',i       ;else if (op == '*')    
          BREQ    mltplyc;
          BRNE    divif; 

mltplyc:  LDA     n1,s       ;get num1 into Acc
          STA     -4,s       ;push num1 

          LDA     n2,s       ;get num2 into Acc
          STA     -6,s       ;push num2 and skip result

          SUBSP   6,i        ;push #retVal2 #num1 #num2     
          CALL    multiply   ;call multiply function, retAddr automatically pushed onto stack
          ADDSP   6,i        ;deallocate #retVal2 #num1 #num2
          STA     retVal,s   ;val = multiply(mcand, mpr);
          BR      endFunc1;  ;exit the conditional
     

; ------------------------------------------
; => 'else if' to check for division
; ==> call to division function
; -----------------------------------------

divif:    CPA     '/',i       ;else if (op == '/')    
          BREQ    divc;
          BRNE    endprog; 

divc:     LDA     n1,s       ;get num1 into Acc
          STA     -4,s       ;push num1 

          LDA     n2,s       ;get num2 into Acc
          STA     -6,s       ;push num2 and skip result

          SUBSP   6,i        ;push #retVal3 #num1 #num2     
          CALL    divide     ;call division function, retAddr automatically pushed onto stack
enddiv:   ADDSP   6,i        ;deallocate #retVal3 #num1 #num2            
          STA     retVal,s   ;val = divide(mcand, mpr);
          BR      endFunc1;  ;exit the conditional

endFunc1: RET0               ;return, automtically pops retAddr into PC

;******** int doMath (int num1, int num2, char op) ********
;
; 1. Allocate 7 bytes on the stack because: 
;     -> 2 bytes for integers  (num1,num2,result)
;     -> 1 byte for characters (num3)
;
; 2. Input prompts for number 1, number 2, and the character op
;
; 3. If the user quits with q, end the program and break
;    out of the loop.
;
; *********************************************************

ret:    .EQUATE -2          ;return value from function #2d
op:     .EQUATE 7           ;local variable #1d 
num1:   .EQUATE 4           ;local variable #2d
num2:   .EQUATE 2           ;local variable #2d
result: .EQUATE 0           ;local variable #2d

main:    SUBSP   7,i        ;allocate #op #num1 #num2 #result 

inf_for: LDA 0,i            ;for(;;) {

         STRO    prompt1,d
         DECI    num1,s      ;cin >> num1
         STRO    prompt2,d
         DECI    num2,s      ;cin >> num2
         LDA     num1,s      ;get num1 into Acc
         STRO    prompt3,d 
         CHARI   op,s         ;cin >> op

         LDBYTEA  op,s    ;if (op == 'q') 
         CPA      'q',i        
         BREQ     endprog; 

         LDA     num1,s     ;get num1 into Acc
         STA     -4,s       ;push num1 

         LDA     num2,s     ;get num2 into Acc
         STA     -6,s       ;push num2 and skip result

         LDA 0x0000,i
         LDBYTEA    op,s    ;get op into Acc
         STBYTEA    -7,s    ;push op

         SUBSP   7,i        ;push #retVal #num1 #num2 #op

         CALL    doMath     ;call add function, retAddr automatically pushed onto stack 

         ADDSP   7,i        ;pop #num1 #num2 #op #retVal 
         LDA     ret,s
         STA     result,s

         CHARO   '\n',i      ;   << endl

         DECO num1,s;
         STRO spacer,d;
         CHARO op,s;
         STRO spacer,d;
         DECO num2,s;
         STRO spacer,d;
         STRO equalsgn,d;
         STRO spacer,d; 
         DECO result,s

         ADDSP   7,i        ;deallocate #result #num1 #num2 #op          
      
         CHARO   '\n',i      ;   << endl
         CHARO   '\n',i      ;   << endl

         BR inf_for         ; }

endprog:  STOP
                
prompt1:  .ASCII  "Enter the first number: \x00"
prompt2:  .ASCII  "Enter the second number: \x00"
prompt3:  .ASCII  "Enter operation (+, -, *, /, q (quit)): \x00"
debug:    .ASCII "test"
equalsgn: .ASCII "="
spacer:   .ASCII " "

         .END                  


