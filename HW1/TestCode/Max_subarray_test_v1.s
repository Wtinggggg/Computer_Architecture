.data
nums1:     .word -2, 1, -3, 4, -1, 2, 1, -5, 4
size1:     .word 9
nums2:     .word 1
size2:     .word 1
nums3:     .word 5, 4, -1, 7, 8
size3:     .word 5
str1:      .string "Maximum subarray sum of nums is "
str2:      .string "\n" 

.text
.globl main
    la a0, nums1         # load nums address
    la t0, size1         # numsSize 
    lw a1, 0(t0)
    call maxSubArray
    
    la a0, nums2         # load nums address
    la t0, size2         # numsSize 
    lw a1, 0(t0)
    call maxSubArray
    
    la a0, nums3         # load nums address
    la t0, size3         # numsSize 
    lw a1, 0(t0)
    call maxSubArray
    
    li a7, 10           # end
    ecall

# Assume array's address is passed in a0, numSize is passed in a1
# And result will be returned in a0
maxSubArray:
    # 初始化變量
    li s0, -2147483648 # (INT_MIN)
    li t1, 0           # i

outer_loop:
    bge t1, a1, end_outer_loop # 如果 t1 >= size 則跳出外層迴圈

    li t3, 0           # current_sum = 0
    mv t2, t1          # j = i

inner_loop:
    bge t2, a1, end_inner_loop # 如果 t2 >= size 則跳出內層迴圈

    # 計算當前子數組和
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
    la a0, str1
    li a7, 4            
    ecall
    
    mv a0, s0       
    li a7, 1        
    ecall   
    
    la a0, str2
    li a7, 4            
    ecall           

    ret