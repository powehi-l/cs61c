.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    # Prologue


loop_start:
    add s0, a0, x0
    addi s1, a1, -2
    addi s2, a1, -1
    slli t0, s2, 2
    add t0, t0, s0
    lw t1, 0(t0) 
loop_continue:
    blt s1, x0, loop_end
    slli t0, s1, 2
    add t0, t0, s0
    lw t2, 0(t0)
    blt t2, t1, nop
    add s2, s1, x0
    add t1, t2, x0
nop:
    addi s1, s1, -1
    j loop_continue


loop_end:
    add a0, s2, x0
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    # Epilogue


    ret
