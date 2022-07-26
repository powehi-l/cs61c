.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
    addi sp, sp, -16
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    sw s3, 12(sp)
    # Prologue

    add s0, a0, x0
    add s1, a1, x0
    add t2, x0, x0
    addi a2, a2, -1
    slli s2, a3, 2
    slli s3, a4, 2
loop_start:
    blt a2, x0, loop_end
    lw t0, 0(s0)
    lw t1, 0(s1)
    mul t0, t0, t1
    add t2, t2, t0
    add s0, s0, s2
    add s1, s1, s3
    addi a2, a2, -1
    j loop_start

loop_end:
    add a0, t2, x0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    addi sp, sp, 16

    # Epilogue

    
    ret
