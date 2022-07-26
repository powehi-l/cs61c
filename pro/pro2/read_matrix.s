.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:
    addi sp, sp, -28
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)

    # Prologue
    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0

    # open file
    mv a1, s0
    add a2, x0, x0
    jal ra, fopen
    addi t0, a0, 1
    beq t0, x0, eof_or_error
    mv s4, a0   # s4 is the file specifier

    #read rows
    mv a1, s4
    mv a2, s1
    addi a3, x0, 4
    jal ra, fread
    addi t0, x0, 4
    bne t0, a0, eof_or_error

    #read columns
    mv a1, s4
    mv a2, s2
    addi a3, x0, 4
    jal ra, fread
    addi t0, x0, 4
    bne t0, a0, eof_or_error

    # allocate enough space of matrix
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t0, t0, t1   # s3 is the matrix bytes
    slli a0, t0, 2
    mv s3, a0
    jal ra, malloc

    mv s5, a0 # s5 is the address of matrix
    # read from file
    
    mv a1, s4
    mv a2, s5
    mv a3, s3
    jal ra, fread
    bne s3, a0, eof_or_error

    mv a1, s4
    jal ra, fclose
    addi t0, x0, -1
    beq a0, t0, eof_or_error

    # Epilogue
    mv a0, s5
    mv a1, s1
    mv a2, s2
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28

    ret

eof_or_error:
    li a1 1
    jal exit2
    