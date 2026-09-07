.data 

input_addr: .word 0x80
output_addr: .word 0x84

bracket_stack: .word 0x700
stack_top: .word 0x1000

.text
.org 0x100

_start: 
  ; A7 - stack
  movea.l stack_top, A7
  movea.l (A7), A7
  
  ;A0 - input
  movea.l input_addr, A0
  movea.l (A0), A0 
  
  ;A1 - output
  movea.l output_addr, A1
  movea.l (A1), A1

  ;A2 - bracket_stack
  movea.l bracket_stack, A2 
  movea.l (A2), A2

  clr.l D4 ; length
  clr.l D5 ; Количество открытых скобок
  clr.l D6 ; флаг ошибки

read_loop: 
  move.b (A0), D0 ; D0 - cur char
  cmp.b 0xA, D0
  beq line_finish

  ; length++
  add.l 1, D4 

  ; overflow check
  cmp.l 0x40, D4
  beq overflow

  jsr process_char

  jmp read_loop

process_char: 
  cmp.l 0, D6
  bne process_char_end

  cmp.b '(', D0
  beq process_open

  cmp.b '{', D0
  beq process_open

  cmp.b '[', D0
  beq process_open

  cmp.b ')', D0
  beq process_close_deffault

  cmp.b ']', D0
  beq process_close_square
  
  cmp.b '}', D0
  beq process_close_curly

  rts

process_open: 
  jsr push_open 
  rts

push_open: 
  move.b D0, (A2)+
  add.l 1, D5 ; D5 - Количество скобок в стеке
  rts

process_close_deffault: 
  move.b '(', D1
  jsr check_close
  rts
process_close_curly:
  move.b '{', D1
  jsr check_close
  rts
process_close_square: 
  move.b '[', D1
  jsr check_close
  rts
check_close:
  ; стек пуст?
  cmp.l 0, D5
  beq invalid_brackets
  ; Достаем верхнюю скобку
  move.b -(A2), D2
  sub.l 1, D5

  cmp.b D1, D2
  bne invalid_brackets

  rts

invalid_brackets: 
  move.l -1, D6
  rts

  process_char_end: 
  rts

line_finish: 
  cmp.l 0, D6
  bne output_invalid

  cmp.l 0, D5
  bne output_invalid

  move.l 1, (A1)
  halt

output_invalid: 
  move.l -1, (A1)
  halt

overflow: 
  move.l 0xCCCCCCCC, (A1) 
  halt
