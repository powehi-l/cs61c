.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    mv s0, a0
    mv s1, a1

    # Exit if incorrect number of command line args
    addi t0, x0, 5
    bne t0, s0, wrong_arg


	# =====================================
    # LOAD MATRICES
    # =====================================
    
    # Load pretrained m0
    addi a0, x0, 4
    jal ra, malloc
    mv s3, a0

    addi a0, x0, 4
    jal ra, malloc
    mv s4, a0
    mv a2, a0
    mv a1, s3

    lw a0, 4(s1)
    jal ra, read_matrix
    mv s2, a0   # s2 is the matrix of m0

    # Load pretrained m1
    addi a0, x0, 4
    jal ra, malloc
    mv s6, a0

    addi a0, x0, 4
    jal ra, malloc
    mv s7, a0
    mv a2, a0
    mv a1, s6

    lw a0, 8(s1)
    jal ra, read_matrix
    mv s5, a0   # s5 is the matrix of m1

    # Load input matrix
    addi a0, x0, 4
    jal ra, malloc
    mv s9, a0

    addi a0, x0, 4
    jal ra, malloc
    mv s10, a0
    mv a1, s9
    mv a2, s10

    lw a0, 12(s1)
    jal ra, read_matrix
    mv s8, a0   # s8 is the matrix of input


    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    # malloc space for temp
    lw t0, 0(s3)
    lw t1, 0(s10)
    mul t0, t0, t1
    slli a0, t0, 2
    jal ra, malloc
    mv s11, a0

    # m0 * input
    mv a0, s2
    lw a1, 0(s3)
    lw a2, 0(s4)
    mv a3, s8
    lw a4, 0(s9)
    lw a5, 0(s10)
    mv a6, s11
    jal ra, matmul

    # relu temp
    mv a0, s11
    lw t0, 0(s3)
    lw t1, 0(s10)
    mul a1, t0, t1
    jal ra, relu
    # temp - s8, s9, s10
    mv s8, s11
    mv s9, s3

    lw t0, 0(s6)
    lw t1, 0(s10)
    mul t0, t0, t1
    slli a0, t0, 2
    jal ra, malloc
    mv s2, a0
    mv s3, s6
    mv s4, s10

    # m1 * temp
    mv a0, s5
    lw a1, 0(s6)
    lw a2, 0(s7)
    mv a3, s8
    lw a4, 0(s9)
    lw a5, 0(s10)
    mv a6, s2
    jal ra, matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s1) # Load pointer to output filename
    mv a1, s2
    lw a2, 0(s3)
    lw a3, 0(s4)
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s2
    lw t0, 0(s3)
    lw t1, 0(s4)
    mul a1, t0, t1
    jal ra, argmax



    # Print classification
    mv a1, a0
    jal print_int

    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char

    jal exit

wrong_arg:
    li a1 3
    jal exit2
