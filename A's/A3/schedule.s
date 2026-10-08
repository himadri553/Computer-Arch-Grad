# Problem 4(c): reorder this code to remove as many stalls as you can.
#   x10 = address of A, x11 = address of B (int arrays, 4 bytes per element)
#   A[0] = B[0] + B[1];  A[1] = B[2] - B[0];  A[2] = B[3] & B[1];
# Rules: use only lw, sw, add, sub, and, or. No labels.
# You may rename registers, but do not assume any register except x10 and x11
# holds a known value when the code starts. Comments start with #.
# This starting file is the ORIGINAL, unscheduled code.

lw   x5, 0(x11)      # B[0]
lw   x6, 4(x11)      # B[1]
add  x7, x5, x6
sw   x7, 0(x10)      # A[0]
lw   x8, 8(x11)      # B[2]
sub  x9, x8, x5
sw   x9, 4(x10)      # A[1]
lw   x12, 12(x11)    # B[3]
and  x13, x12, x6
sw   x13, 8(x10)     # A[2]
