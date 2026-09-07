.data

input_addr: .word 0x80
output_addr: .word 0x84

count: .word 0x0
tmp: .word 0x0  
sign: .word 0x0 

sum_low: .word 0x0
sum_hi: .word 0x0

.text
.org 0x100

_start: 
  1 
  eam 

  @p input_addr
  a! 
  @
  !p count
  @p output_addr
  b!
  @
process_word:
  !p tmp

  @p tmp
  -if non_negative
  
  -1
  !p sign
  sign_ready ;
non_negative: 
  0 
  !p sign

sign_ready:
  
  \суммируем 64 битное слово 
  @p sum_hi
  @p sign
  @p sum_low
  @p tmp

  +
  >r 
  + 
  r>
  !p sum_low
  !p sum_hi

  @p count
  -1
  +
  dup 
  !p count
  \если count == 0, done
  if done
  \иначе читаем следующий x
  @
  process_word ;

done:
  @p sum_hi
  !b 

  @p sum_low
  !b

  halt
  
  
  

