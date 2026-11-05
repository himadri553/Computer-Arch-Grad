# Project 2, Part F: the scheduling challenge. Run on RV32_5S.
# Computes a0 = sum of |arr[i]| and a1 = max |arr[i]| over n words.
# Rules: RV32I only. Keep the .data section format exactly, because the grader
# swaps in other arrays. n is always a multiple of 4 and at least 4.
.data
n:   .word 16
arr: .word 5, -3, 12, -7, 0, 9, -14, 2, 8, -1, 6, -11, 3, 4, -10, 13
.text
    la   x20, n
    lw   x21, 0(x20)        # x21 = n
    la   x20, arr           # x20 = &arr[0]
    addi a0, x0, 0          # a0 = sum
    addi a1, x0, 0          # a1 = max
loop:
    lw   x5, 0(x20)
    bge  x5, x0, pos
    sub  x5, x0, x5         # x5 = -x5
pos:
    add  a0, a0, x5
    bge  a1, x5, nomax
    addi a1, x5, 0
nomax:
    addi x20, x20, 4
    addi x21, x21, -1
    bne  x21, x0, loop
