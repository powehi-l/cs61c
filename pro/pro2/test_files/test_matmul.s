.import ../matmul.s
.import ../utils.s
.import ../dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output
# 1 2 3     1 2 3
# 4 5 6     4 5 6
# 7 8 9     7 8 9

# 30  36  42
# 66  81  96
# 102 126 150

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la a0, m0
    addi a1, x0, 3
    addi a2, x0, 3
    la a3, m1
    addi a4, x0, 3
    addi a5, x0, 3
    la a6, d



    # Call matrix multiply, m0 * m1
    jal ra, matmul



    # Print the output (use print_int_array in utils.s)
    add a0, a6, x0
    addi a1, x0, 3
    addi a2, x0, 3 
    jal print_int_array



    # Exit the program
    jal exit