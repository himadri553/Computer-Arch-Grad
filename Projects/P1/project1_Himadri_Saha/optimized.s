# Project 1 -- optimized version, variant E0E201

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
    # ---- start the closed form (needs a0 before it is reused) -----------------
    addi t0, a0, 1                  # t0 = n + 1
    add  t2, a0, t0                 # t2 = 2n + 1
    mul  t1, a0, t0                 # t1 = n(n+1)

    # ---- print "=> " (a0 is free now) ----------------------------------------
    lui  a0, 0x10010                # a0 = &msg = 0x10010000 (low 12 bits are 0)
    addi a7, zero, 4                # service 4 = print string
    ecall

    # ---- finish: sum = n(n+1)/2 * (2n+1) / 3 ---------------------------------
    srli t1, t1, 1                  # t1 = n(n+1)/2   (exact: product is even)
    mul  t1, t1, t2                 # t1 = n(n+1)(2n+1)/2
    addi t3, zero, 3
    divu a0, t1, t3                 # a0 = n(n+1)(2n+1)/6   (exact)

    # ---- print sum, '\n', exit ------------------------------------------------
    addi a7, zero, 1                # service 1 = print int (a0 = sum)
    ecall
    addi a0, zero, 10               # '\n'
    addi a7, zero, 11               # service 11 = print char
    ecall
    addi a7, zero, 10               # service 10 = exit
    ecall