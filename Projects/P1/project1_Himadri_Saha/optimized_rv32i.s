# G3 -- optimized version using RV32I ONLY (no mul/div/rem), variant E0E201

.data
msg:    .asciz "=> "                # 0x10010000

.text
main:
    # ---- read n --------------------------------------------------------------
    addi a7, zero, 5                # service 5 = read int
    ecall                           # a0 = n
    bge  a0, zero, n_ok             # n >= 0 -> keep it
    addi a0, zero, 0                # n < 0  -> treat as 0 (original prints 0)
n_ok:
    # ---- P1 = n * (n+1)   (shift-and-add over bits 0..9 of n) ----------------
    addi t1, a0, 1                  # t1 = n + 1   (multiplicand)
    addi t2, zero, 0                # t2 = P1 = 0
    andi t3, a0, 1                  # bit 0 of n set?
    beq  t3, zero, p1_b1
    add  t2, t2, t1                 # P1 += (n+1)
p1_b1:
    andi t3, a0, 2                  # bit 1 of n set?
    beq  t3, zero, p1_b2
    slli t3, t1, 1                 # (n+1) << 1
    add  t2, t2, t3                 # P1 += (n+1) << 1
p1_b2:
    andi t3, a0, 4                  # bit 2 of n set?
    beq  t3, zero, p1_b3
    slli t3, t1, 2                 # (n+1) << 2
    add  t2, t2, t3                 # P1 += (n+1) << 2
p1_b3:
    andi t3, a0, 8                  # bit 3 of n set?
    beq  t3, zero, p1_b4
    slli t3, t1, 3                 # (n+1) << 3
    add  t2, t2, t3                 # P1 += (n+1) << 3
p1_b4:
    andi t3, a0, 16                 # bit 4 of n set?
    beq  t3, zero, p1_b5
    slli t3, t1, 4                 # (n+1) << 4
    add  t2, t2, t3                 # P1 += (n+1) << 4
p1_b5:
    andi t3, a0, 32                 # bit 5 of n set?
    beq  t3, zero, p1_b6
    slli t3, t1, 5                 # (n+1) << 5
    add  t2, t2, t3                 # P1 += (n+1) << 5
p1_b6:
    andi t3, a0, 64                 # bit 6 of n set?
    beq  t3, zero, p1_b7
    slli t3, t1, 6                 # (n+1) << 6
    add  t2, t2, t3                 # P1 += (n+1) << 6
p1_b7:
    andi t3, a0, 128                # bit 7 of n set?
    beq  t3, zero, p1_b8
    slli t3, t1, 7                 # (n+1) << 7
    add  t2, t2, t3                 # P1 += (n+1) << 7
p1_b8:
    andi t3, a0, 256                # bit 8 of n set?
    beq  t3, zero, p1_b9
    slli t3, t1, 8                 # (n+1) << 8
    add  t2, t2, t3                 # P1 += (n+1) << 8
p1_b9:
    andi t3, a0, 512                # bit 9 of n set?
    beq  t3, zero, p1_done
    slli t3, t1, 9                 # (n+1) << 9
    add  t2, t2, t3                 # P1 += (n+1) << 9
p1_done:
    # ---- P2 = 3S = P1/2 + n * P1   (same 10 bit tests, multiplicand = P1) ------
    srli t4, t2, 1                  # t4 = P2 = P1/2   (exact: P1 is even)
    andi t3, a0, 1                  # bit 0 of n set?
    beq  t3, zero, p2_b1
    add  t4, t4, t2                 # P2 += P1
p2_b1:
    andi t3, a0, 2                  # bit 1 of n set?
    beq  t3, zero, p2_b2
    slli t3, t2, 1                 # P1 << 1
    add  t4, t4, t3                 # P2 += P1 << 1
p2_b2:
    andi t3, a0, 4                  # bit 2 of n set?
    beq  t3, zero, p2_b3
    slli t3, t2, 2                 # P1 << 2
    add  t4, t4, t3                 # P2 += P1 << 2
p2_b3:
    andi t3, a0, 8                  # bit 3 of n set?
    beq  t3, zero, p2_b4
    slli t3, t2, 3                 # P1 << 3
    add  t4, t4, t3                 # P2 += P1 << 3
p2_b4:
    andi t3, a0, 16                 # bit 4 of n set?
    beq  t3, zero, p2_b5
    slli t3, t2, 4                 # P1 << 4
    add  t4, t4, t3                 # P2 += P1 << 4
p2_b5:
    andi t3, a0, 32                 # bit 5 of n set?
    beq  t3, zero, p2_b6
    slli t3, t2, 5                 # P1 << 5
    add  t4, t4, t3                 # P2 += P1 << 5
p2_b6:
    andi t3, a0, 64                 # bit 6 of n set?
    beq  t3, zero, p2_b7
    slli t3, t2, 6                 # P1 << 6
    add  t4, t4, t3                 # P2 += P1 << 6
p2_b7:
    andi t3, a0, 128                # bit 7 of n set?
    beq  t3, zero, p2_b8
    slli t3, t2, 7                 # P1 << 7
    add  t4, t4, t3                 # P2 += P1 << 7
p2_b8:
    andi t3, a0, 256                # bit 8 of n set?
    beq  t3, zero, p2_b9
    slli t3, t2, 8                 # P1 << 8
    add  t4, t4, t3                 # P2 += P1 << 8
p2_b9:
    andi t3, a0, 512                # bit 9 of n set?
    beq  t3, zero, p2_done
    slli t3, t2, 9                 # P1 << 9
    add  t4, t4, t3                 # P2 += P1 << 9
p2_done:
    # ---- S = P2 / 3 = P2 * 0xAAAAAAAB (mod 2^32), no divide ----------------------
    slli t5, t4, 2
    add  t5, t5, t4                 # t5 = P2 * 0x5
    slli t6, t5, 4
    add  t5, t5, t6                 # t5 = P2 * 0x55
    slli t6, t5, 8
    add  t5, t5, t6                 # t5 = P2 * 0x5555
    slli t6, t5, 16
    add  t5, t5, t6                 # t5 = P2 * 0x55555555

    # ---- print "=> " -----------------------------------------------------------
    lui  a0, 0x10010                # a0 = &msg
    addi a7, zero, 4                # service 4 = print string
    ecall

    # ---- finish the divide straight into a0, print S, '\n', exit ---------------
    slli t5, t5, 1                  # P2 * 0xAAAAAAAA
    add  a0, t5, t4                 # a0 = P2 * 0xAAAAAAAB = S
    addi a7, zero, 1                # service 1 = print int
    ecall
    addi a0, zero, 10               # '\n'
    addi a7, zero, 11               # service 11 = print char
    ecall
    addi a7, zero, 10               # service 10 = exit
    ecall