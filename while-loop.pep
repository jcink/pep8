;+-------------------------------------------+
;|   Pep/8 Assembly Language
;|   While loop + a counter
;|   ========================================
;|   Author:   admin@jcink.com
;|   Modified: 1:13 AM Tuesday, April 2, 2013
;|   ========================================
;+-------------------------------------------+

;+-------------------------------------------
;| Prologue: This is just a while loop
;| An int variable is stored on the run time
;| stack with a value of 5, and then the number
;| is incrimented by 1 each time in an infinite
;| while loop. 
;+-------------------------------------------


num:     .EQUATE 0                ;local variable #2d

main:     LDA     0,i   
          SUBSP   2,i             ;allocate #num 
          LDA     5,i
          STA     num,s           ;int num = 0;     

while1:  LDA 0,i                  ;while(1){
         
         LDA  num,s               ;load num 
         ADDA 1,i                 ;num++
         STA  num,s               ;store the value 

         STRO  msg1,d             ;cout << 'Result'; 
         DECO num,s               ;output the num variable
         CHARO   '\n',i           ;<< endl
        
         BR while1         ;}

msg1:  .ASCII "num++ Result: "  
           
.END                  


