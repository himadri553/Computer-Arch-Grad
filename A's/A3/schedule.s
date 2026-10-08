# Problem 4(c): reordered code, 0 load-use stalls with full forwarding (14 cycles).
#   x10 = address of A, x11 = address of B (int arrays, 4 bytes per element)
#   A[0] = B[0] + B[1];  A[1] = B[2] - B[0];  A[2] = B[3] & B[1];

lw   x5, 0(x11)      # B[0]
lw   x6, 4(x11)      # B[1]
lw   x8, 8(x11)      # B[2]
add  x7, x5, x6      # x6 was loaded two instructions earlier, so no stall
sw   x7, 0(x10)      # A[0]
lw   x12, 12(x11)    # B[3]
sub  x9, x8, x5      # x8 was loaded three instructions earlier, so no stall
sw   x9, 4(x10)      # A[1]
and  x13, x12, x6    # x12 was loaded two instructions earlier, so no stall
sw   x13, 8(x10)     # A[2]