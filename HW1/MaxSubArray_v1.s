maxSubArray:
    li s0, -2147483648 # (INT_MIN)
    li t1, 0           # i

outer_loop:
    bge t1, a1, end_outer_loop 

    li t3, 0           # current_sum = 0
    mv t2, t1          # j = i

inner_loop:
    bge t2, a1, end_inner_loop 

    slli t4, t2, 2     # t4 = t2 * 4 (4 bytes)
    add t4, t4, a0     # t4 = &nums[j]
    lw t5, 0(t4)       # t5 = nums[j]
    add t3, t3, t5     # current_sum += nums[j]

    blt s0, t3, update_max_sum

    j continue_inner_loop

update_max_sum:
    mv s0, t3          # max_sum = current_sum

continue_inner_loop:
    addi t2, t2, 1     # j++

    j inner_loop

end_inner_loop:
    addi t1, t1, 1     # i++
    j outer_loop

end_outer_loop:
    mv a0, s0       
    ret