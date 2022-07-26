.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    # Prologue

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3

    #open the file   
    mv a1, s0
    addi a2, x0, 1
    jal ra, fopen
    addi t0, x0, -1
    beq t0, a0, eof_or_error
    mv s0, a0   # set s0 as the file descriptor

    # write rows
    mv a1, s0

    addi sp, sp, -4 #store the s2, in stack for access
    sw s2, 0(sp)
    mv a2, sp

    addi a3, x0, 1
    addi a4, x0, 4
    jal ra, fwrite
    addi sp, sp, 4
    addi t0, x0, 1
    bne a0, t0, eof_or_error

    # write columns
    mv a1, s0
    
    addi sp, sp, -4
    sw s3, 0(sp)
    mv a2, sp

    addi a3, x0, 1
    addi a4, x0, 4
    jal ra, fwrite
    addi sp, sp, 4
    addi t0, x0, 1
    bne a0, t0, eof_or_error

    # write matrix
    mv a1, s0
    mv a2, s1
    mul a3, s2, s3
    addi a4, x0, 4
    jal ra, fwrite
    mul t0, s2, s3
    bne a0, t0, eof_or_error

    # close the file
    mv a1, s0
    jal ra, fclose
    bne a0, x0, eof_or_error


    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    addi sp, sp, 20

    ret

eof_or_error:
    li a1 1
    jal exit2
    