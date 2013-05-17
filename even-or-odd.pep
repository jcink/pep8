;+-------------------------------------------+
;|   Pep/8 Assembly Language
;|   Even or odd number checking
;|   ========================================
;|   Author:   admin@jcink.com
;|   Modified: 12:59 AM Thursday, Feb 28, 2013
;|   ========================================
;+-------------------------------------------+

;+--------------------------------------------------------+
; The difference between even and odd numbers can easily
; be seen by looking at the least significant bit. 
; Ex: 21 in binary is 10101, and 20 is 10100. The last
; bit is the only one that changes. We'll use this to
; figure out if the number is even or odd since Pep/8
; cannot actually do modulus.
;
; The program does an AND bitwise operation on the inputted
; number to check if it's even or odd, and then branches
; to the right locations essentially creating an if/else
; statement. 
;+--------------------------------------------------------+

BR      main   
     
num:     .EQUATE 0           ;local variable #2d

main:    SUBSP   2,i         ;allocate #num
         DECI    num,s       ;cin >> num
if:      LDA     num,s       ;if (num != 1)
         ANDA    0x0001,i 
         BRNE    else        
         STRO    even_msg,d   ;cout << "Even" 
         BR      endIf       
else:    STRO    odd_msg,d    ;cout << "Odd"
endIf:   ADDSP   2,i         ;deallocate #num
         STOP
              
odd_msg:  .ASCII  "The number is: Odd\x00"  
even_msg: .ASCII  "The number is: Even\x00"   

.END
