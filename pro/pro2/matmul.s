.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	a0 is the pointer to the start of m0
#	a1 is the # of rows (height) of m0
#	a2 is the # of columns (width) of m0
#	a3 is the pointer to the start of m1
# 	a4 is the # of rows (height) of m1
#	a5 is the # of columns (width) of m1
#	a6 is the pointer to the the start of d
# Returns:
#	None, sets d = matmul(m0, m1)
#
#   for(i = 0; i < s1; i++){
#       for(j = 0; j < s2; j++){
#           dot    
#       }
#   }
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions

    addi sp sp -40
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    
    # Prologue

    add s0, a0, x0
    add s1, a1, x0
    add s2, a2, x0
    add s3, a3, x0
    add s4, a4, x0
    add s5, a5, x0
    add s6, a6, x0
    add s7, x0, x0
outer_loop_start:
    beq s7, s1, outer_loop_end
    add s8, x0, x0
inner_loop_start:
    beq s8, s5, inner_loop_end
    mul a0, s2, s7
    slli a0, a0, 2
    add a0, a0, s0
    slli a1, s8, 2
    add a1, a1, s3

    add a2, s2, x0
    addi a3, x0, 1
    add a4, s5, x0
    jal ra, dot

    mul t0, s2, s7
    add t0, t0, s8
    slli t0, t0, 2
    add t0, t0, s6
    sw a0, 0(t0)
    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    addi s7, s7, 1
    j outer_loop_start

outer_loop_end:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40
    # Epilogue
    ret


mismatched_dimensions:
    li a1 2
    jal exit2
