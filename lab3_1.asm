.data
.org 0x00

buffer:  .word 0x5F5F5F5F
buf4:    .word 0x5F5F5F5F
buf8:    .word 0x5F5F5F5F
buf12:   .word 0x5F5F5F5F
buf16:   .word 0x5F5F5F5F
buf20:   .word 0x5F5F5F5F
buf24:   .word 0x5F5F5F5F
buf28:   .word 0x5F5F5F5F

ptr: .word 0x01
length: .word 0x00

input_addr: .word 0x80
output_addr: .word 0x84

ascii_a: .word 0x61
ascii_z: .word 0x7A
delta: .word 0x20
newline: .word 10

const_1: .word 0x01
max_length: .word 0x1F

mask_clear_bytes: .word 0xFFFFFF00
overflow_value: .word 0xCCCCCCCC
mask_byte: .word 0x000000FF

tmp: .word 0x00

.text
.org 0x100
_start:

read_loop:
  load input_addr
  load_acc
  store tmp
  
  sub newline
  beqz done

  load length
  sub max_length
  beqz overflow

  load tmp
  sub ascii_a
  bltz save_char

  load tmp

  sub ascii_z
  bgtz save_char

  load tmp
  sub delta
  store tmp

save_char:
  load ptr
  load_acc 
  and mask_clear_bytes
  or tmp 
  store_ind ptr
  
  load ptr 
  add const_1
  store ptr

  load length
  add const_1
  store length 
  
  jmp read_loop

overflow:   
  load overflow_value
  store_ind output_addr
  halt
  
output_loop:
  load length
  beqz finish

  load ptr
  load_acc
  and mask_byte
  store_ind output_addr

  load ptr 
  add const_1
  store ptr 

  load length 
  sub const_1
  store length

  jmp output_loop

finish:
  halt

done:
  load_addr buffer
  and mask_clear_bytes
  or length
  store_addr buffer

  load_imm 0x01
  store ptr

  jmp output_loop
