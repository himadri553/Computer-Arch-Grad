# Project 2, Part A: control signals in the single-cycle processor, RV32_SS.
.data
val: .word 25
.text
    la   x20, val
    lw   x5,  0(x20)
    addi x6,  x0, 25
    sub  x7,  x5, x6
    beq  x7,  x0, equal
    addi x8,  x0, 1
equal:
    sw   x6,  4(x20)
    jal  x1,  func
    addi x9,  x0, 9
    beq  x9,  x0, equal
    j    end
func:
    slli x10, x5, 1
    jalr x0,  x1, 0
end:
    nop
