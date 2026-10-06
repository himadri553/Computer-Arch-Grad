# Project 1 -- reconstructed source for variant E0E201
# Must assemble in OARS to EXACTLY the words in mystery.txt.
#
# What the program does:
#   n = read_int()
#   for i = 1..n:  arr[i-1] = mult(i, i)      # arr at 0x10010840
#   sum = arr[0] + ... + arr[n-1]
#   print "=> ", sum, '\n'  then exit
#   mult(a, b) multiplies by repeated addition (b loops)

.data
msg:    .asciz "=> "                # 0x10010000: 0x00203e3d

.text
main:
    # ---- read n --------------------------------------------------------------
    addi a7, zero, 5                # 0x00400000  0x00500893  service 5 = read int
    ecall                           # 0x00400004  0x00000073  a0 = n
    addi s0, a0, 0                  # 0x00400008  0x00050413  s0 = n
    lui  s6, 0x10011                # 0x0040000c  0x10011b37  s6 = 0x10011000
    addi s6, s6, -1984              # 0x00400010  0x840b0b13  s6 = 0x10010840 (array base)
    addi s2, zero, 1                # 0x00400014  0x00100913  i = 1

    # ---- loop 1: arr[i-1] = mult(i, i) for i = 1..n ----------------------------
fill_loop:
    blt  s0, s2, sum_init           # 0x00400018  0x03244263  if n < i, done
    addi a0, s2, 0                  # 0x0040001c  0x00090513  a0 = i
    addi a1, s2, 0                  # 0x00400020  0x00090593  a1 = i
    jal  ra, mult                   # 0x00400024  0x06c000ef  a0 = i * i
    slli t2, s2, 2                  # 0x00400028  0x00291393  t2 = 4i
    add  t2, t2, s6                 # 0x0040002c  0x016383b3  t2 = base + 4i
    sw   a0, -4(t2)                 # 0x00400030  0xfea3ae23  arr[i-1] = i*i
    addi s2, s2, 1                  # 0x00400034  0x00190913  i++
    jal  zero, fill_loop            # 0x00400038  0xfe1ff06f

    # ---- loop 2: sum = arr[0] + ... + arr[n-1] -------------------------------
sum_init:
    addi s1, zero, 0                # 0x0040003c  0x00000493  sum = 0
    addi t1, zero, 0                # 0x00400040  0x00000313  j = 0
sum_loop:
    bge  t1, s0, print              # 0x00400044  0x00835e63  if j >= n, done
    slli t0, t1, 2                  # 0x00400048  0x00231293  t0 = 4j
    add  t0, t0, s6                 # 0x0040004c  0x016282b3  t0 = &arr[j]
    lw   t3, 0(t0)                  # 0x00400050  0x0002ae03  t3 = arr[j]
    add  s1, s1, t3                 # 0x00400054  0x01c484b3  sum += arr[j]
    addi t1, t1, 1                  # 0x00400058  0x00130313  j++
    jal  zero, sum_loop             # 0x0040005c  0xfe9ff06f

    # ---- print "=> ", sum, '\n', then exit -----------------------------------
print:
    lui  a0, 0x10010                # 0x00400060  0x10010537  a0 = &msg (upper)
    addi a0, a0, 0                  # 0x00400064  0x00050513  a0 = &msg (lower)
    addi a7, zero, 4                # 0x00400068  0x00400893  service 4 = print string
    ecall                           # 0x0040006c  0x00000073
    addi a0, s1, 0                  # 0x00400070  0x00048513  a0 = sum
    addi a7, zero, 1                # 0x00400074  0x00100893  service 1 = print int
    ecall                           # 0x00400078  0x00000073
    addi a0, zero, 10               # 0x0040007c  0x00a00513  a0 = '\n'
    addi a7, zero, 11               # 0x00400080  0x00b00893  service 11 = print char
    ecall                           # 0x00400084  0x00000073
    addi a7, zero, 10               # 0x00400088  0x00a00893  service 10 = exit
    ecall                           # 0x0040008c  0x00000073

    # ---- mult(a0, a1): returns a0 * a1 by repeated addition ------------------
mult:
    addi t4, zero, 0                # 0x00400090  0x00000e93  result = 0
mult_loop:
    beq  a1, zero, mult_done        # 0x00400094  0x00058863  if b == 0, done
    add  t4, t4, a0                 # 0x00400098  0x00ae8eb3  result += a
    addi a1, a1, -1                 # 0x0040009c  0xfff58593  b--
    jal  zero, mult_loop            # 0x004000a0  0xff5ff06f
mult_done:
    addi a0, t4, 0                  # 0x004000a4  0x000e8513  return value
    jalr zero, 0(ra)                # 0x004000a8  0x00008067  return