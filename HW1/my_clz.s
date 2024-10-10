my_clz:
    # Assume x is passed in a0, and result will be returned in a0
    addi t0, zero, 0           # Initialize count to 0 (t0 = count)
    addi t1, zero, 31          # Initialize i to 31 (t1 = i)

loop:
    slli t2, t1, 0             # Shift left logical t1 by 0 bits (t2 = i)
    li t3, 1                   # Load immediate 1 into t3
    sll t3, t3, t2             # Shift left logical t3 by t2 (t3 = 1U << i)
    and t3, t3, a0             # Perform bitwise AND (t3 = x & (1U << i))
    bnez t3, break_loop        # If t3(x & (1U << i)) is not zero, break the loop
    addi t0, t0, 1             # count++
    addi t1, t1, -1            # i--
    bgez t1, loop              # If i >= 0, repeat the loop

break_loop:
    mv a0, t0                  # Move count to a0 (return value)
    ret  