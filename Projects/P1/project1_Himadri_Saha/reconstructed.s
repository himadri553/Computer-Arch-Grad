# Project 1 -- reconstructed source for variant E0E201
# Must assemble in OARS to EXACTLY the words in mystery.txt.

.data

.text
main:
    addi a0, zero, 42    # a0 = 42
    addi a7, zero, 1     # service 1 = print int
    ecall
    addi a7, zero, 10    # service 10 = exit
    ecall
