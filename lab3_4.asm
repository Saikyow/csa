.data

input_addr:  .word 0x80
output_addr: .word 0x84

.text

_start:
    lui  t0, %hi(input_addr)
    addi t0, t0, %lo(input_addr)
    lw   t0, 0(t0)

    lui  t1, %hi(output_addr)
    addi t1, t1, %lo(output_addr)
    lw   t1, 0(t1)

    lw a0, 0(t0)

    addi a1, zero, 0

    beqz a0, input_zero


count_loop:
    srli t2, a0, 31

    bnez t2, finish

    ; count++
    addi a1, a1, 1

    slli a0, a0, 1

    j count_loop


input_zero:
    addi a1, zero, 32


finish:
    sw a1, 0(t1)
    halt
