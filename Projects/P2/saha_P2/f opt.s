.data
n:   .word 16
arr: .word 5, -3, 12, -7, 0, 9, -14, 2, 8, -1, 6, -11, 3, 4, -10, 13
.text
    la   x20, n
    lw   x21, 0(x20)        # x21 = n
    la   x20, arr           # x20 = &arr[0]
    slli x22, x21, 2        # x22 = 4 * n
    add  x22, x22, x20      # x22 = end of arr
    addi a0, x0, 0          # a0 = sum
    addi a1, x0, 0          # a1 = max
loop:
    lw   x5, 0(x20)
    lw   x6, 4(x20)
    lw   x7, 8(x20)
    lw   x8, 12(x20)
    bge  x5, x0, p0
    sub  x5, x0, x5
p0:
    add  a0, a0, x5
    bge  a1, x5, n0
    addi a1, x5, 0
n0:
    bge  x6, x0, p1
    sub  x6, x0, x6
p1:
    add  a0, a0, x6
    bge  a1, x6, n1
    addi a1, x6, 0
n1:
    bge  x7, x0, p2
    sub  x7, x0, x7
p2:
    add  a0, a0, x7
    bge  a1, x7, n2
    addi a1, x7, 0
n2:
    bge  x8, x0, p3
    sub  x8, x0, x8
p3:
    add  a0, a0, x8
    bge  a1, x8, n3
    addi a1, x8, 0
n3:
    addi x20, x20, 16
    bne  x20, x22, loop