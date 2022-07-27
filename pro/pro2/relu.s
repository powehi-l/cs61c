.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
    addi sp sp -8
    sw s0, 0(sp)
    sw s1, 4(sp)

loop_start:
    add s0, a0, x0
    addi s1, a1, -1








loop_continue:
    blt s1, x0, loop_end
    slli t0, s1, 2
    add t0, t0, s0
    lw t1, 0(t0)
    bge t1, x0, nop
    add t1, x0, x0
nop:
    sw t1, 0(t0)
    addi s1, s1, -1
    j loop_continue

loop_end:
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8

    # Epilogue

    
	ret
