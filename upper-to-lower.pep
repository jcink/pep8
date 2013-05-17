;+-------------------------------------------+
;|   Pep/8 Assembly Language
;|   uppercase to lowercase letters
;|   ========================================
;|   Author:   admin@jcink.com
;|   Modified: 12:45 PM Monday, March 11, 2013
;|   ========================================
;+-------------------------------------------+

;+-------------------------------------------
; Program stores ascii word john and equates each location in memory
; with the individual letter of the name.  Then changes each letter
; one by one simply by subtracting 0x0020 because that's the difference
; between all lower and upper case letters. Outputs the result.
;+-------------------------------------------

       br main ; branch to main

       .ascii "john" ; store the name in memory

;+-------------------------------------------
; Equate each location
; in memory with a value
; The value is set to the
; actual letter that's stored
; in memory for each variable
;+-------------------------------------------

j:    .EQUATE 3 
o:    .EQUATE 4
h:    .EQUATE 5
n:    .EQUATE 6 

;+-------------------------------------------
; The main function runs when it
; gets branched to, and each
; bye is loaded into memory, 
; subtracted by 0x0020, and 
; is then written back to the
; same location with stbytea

; This operation is done for
; every letter until complete
;+-------------------------------------------

main: ldbytea j,d 
      suba 0x0020,i 
      stbytea j,d

      ldbytea o,d
      suba 0x0020,i
      stbytea o,d

      ldbytea h,d
      suba 0x0020,i
      stbytea h,d

      ldbytea n,d
      suba 0x0020,i
      stbytea n,d

;+-------------------------------------------
; Print the output, at this point
; all of the letters stored in memory
; have been swapped to the uppercase
; version...
;+-------------------------------------------

      charo j,d  
      charo o,d
      charo h,d
      charo n,d          

           
.END                  


