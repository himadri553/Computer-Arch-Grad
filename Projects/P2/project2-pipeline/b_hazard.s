# Project 2, Parts B and C: data hazards with no loads or branches.
# Do not reorder or change these 8 instructions. In Part B you may only insert nop's.
.text
    addi x5,  x0, 10
    addi x6,  x0, 3
    add  x7,  x5, x6
    sub  x8,  x7, x5
    slli x9,  x8, 2
    addi x10, x0, 1
    or   x11, x9, x10
    add  x12, x11, x7
