# Project 2, Part E: control hazards in a loop. Run on RV32_5S.
# Sums the first n words of arr into x12.
.data
n:   .word 8
arr: .word 3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9, 3
.text
    la   x20, n
    lw   x21, 0(x20)
    la   x20, arr
    addi x12, x0, 0
loop:
    lw   x5,  0(x20)
    add  x12, x12, x5
    addi x20, x20, 4
    addi x21, x21, -1
    bne  x21, x0, loop
    slli x13, x12, 1        # x13 = 2 * sum
    addi x14, x13, 1        # x14 = 2 * sum + 1
