.data
arr: .word 4, 9, 2, 0
.text
    la   x20, arr
    lw   x5,  0(x20)
    lw   x6,  4(x20)
    nop
    add  x7,  x5, x6
    lw   x8,  8(x20)
    nop
    addi x9,  x8, 1
    sub  x10, x9, x5
    sw   x7,  12(x20)
    lw   x11, 12(x20)
    nop
    add  x12, x11, x10