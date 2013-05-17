;+-------------------------------------------+
;|   Pep/8 Assembly Language
;|   ========================================
;|   Multiplication of two numbers
;|   Using shift-and-add algorithm
;|   ========================================
;|   Author:   admin@jcink.com
;|   Modified: 12:51 PM Friday, April 12, 2013
;|   ========================================
;+-------------------------------------------+

BR      main        

;******* int multiply (int mcand, int mpr)
mpr:    .EQUATE 2           ;formal parameter #2d
mcand:  .EQUATE 4           ;formal parameter #2d
sum:    .EQUATE 6           ;formal parameter #2d

multiply:LDA     0x0000,i    
         STA     sum,s        ;int sum = 0;     

while1:  LDA 0x0000,s;            while (mpr) { 
     
         LDA mpr, s	           ;load the muliplier 
         ANDA 0x0001,i            ;mask all but rightmost bit
         CPA  1,i                 ;if (mpr % 2 == 1)
         BRNE shiftops            ;skip to the bit shifting operations if it's not 1
         LDA  sum,s               ;load sum
         ADDA mcand,s             ;add the multiplicand to the sum
         STA  sum,s               ;add to the sum
        
shiftops: LDA mpr,s               ;load the multiplier 
          ASRA 	           ;arithmetic shift right mpr
          STA mpr,s               ;push mpr

          LDA mcand,s             ;load the multiplicand
          ASLA 	           ;arithmetic shift left mcand
          STA mcand,s             ;push mcand

          LDA mpr,s               ;load mpr
          CPA     0,i             ;check if mpr is 0
          BREQ    endWh1          ;end the while loop if 0
          BR      while1          ;continue looping
    
endWh1: LDA 0,s;
        RET0                      ;pop retAddr

;******* main ()


ret:    .EQUATE -2          ;return value from function #2d
num1:   .EQUATE 4           ;local variable #2d
num2:   .EQUATE 2           ;local variable #2d
result: .EQUATE 0           ;local variable #2d
main:    SUBSP   6,i        ;allocate #num1 #num2 #result 
         STRO    prompt1,d
         DECI    num1,s     ;cin >> num1
         STRO    prompt2,d
         DECI    num2,s     ;cin >> num2
         LDA     num1,s     ;get num1
         STA     -4,s       ;push n1, skip over return value
         LDA     num2,s     ;get num2
         STA     -6,s       ;push n2 
         SUBSP   6,i        ;push #sum #num1 #num2 
         CALL    multiply   ;call multiply function
         ADDSP   6,i        ;pop #mcand #mpr #sum 
         LDA     ret,s
         STA     result,s
         STRO    msg,d 
         DECO    result,s
         ADDSP   6,i        ;deallocate #result #num2 #num1 
         STOP
                
prompt1: .ASCII  "Enter the the multiplicand: (mcand) \x00"
prompt2: .ASCII  "Enter the multiplier: \x00"
msg:     .ASCII  "The result is: \x00"
         .END                  


