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
    mv a7, a0
    mv a2, a0
    mv a1, s6

    lw a0, 8(s1)
    jal ra, read_matrix
    mv s5, a0   # s5 is the matrix of m1

    # Load input matrix
    addi a0, x0, 4
    jal ra, malloc
    mv s8, a0

    addi a0, x0, 4
    jal ra, malloc
    mv s9, a0
    mv a2, s9
    mv a1, s8

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
    mul t0, s3, s10
    slli a0, t0, 2
    jal ra, malloc
    mv s11, a0

    # m0 * input
    mv a0, s2
    mv a1, s3
    mv a2, s4
    mv a3, s8
    mv a4, s9
    mv a5, s10
    mv a6, s11
    jal ra, matmul

    # relu temp
    mv a0, s11
    mul a1, s3, s10
    jal ra, relu
    # temp - s8, s9, s10
    mv s8, s11
    mv s9, s3

    mul t0, s6, s10
    slli a0, t0, 2
    jal ra, malloc
    mv s2, a0
    mv s4, s10

    # m1 * temp
    mv a0, s5
    mv a1, s6
    mv a2, s7
    mv a3, s8
    mv a4, s9
    mv s5, s10
    mv s6, s2

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw a0 16(s0) # Load pointer to output filename
    mv a1, s2
    mv a2, s6
    mv a3, s10
    jal ra, write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    mv a0, s2
    mul a1, s6, s10
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
