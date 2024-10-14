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
    
_start:
    la a0, nums1             
    lw a1, size1             
    jal ra, maxSubArray      
    
    mv s0, a0
    la a0, str1
    li a7, 4            
    ecall
    mv a0, s0
    li a7, 1            
    ecall  
    la a0, str2
    li a7, 4            
    ecall 
    
    la a0, nums2             
    lw a1, size2             
    jal ra, maxSubArray      
    mv s0, a0
    la a0, str1
    li a7, 4            
    ecall
    mv a0, s0
    li a7, 1            
    ecall  
    la a0, str2
    li a7, 4            
    ecall  
    
    la a0, nums3             
    lw a1, size3             
    jal ra, maxSubArray      
    mv s0, a0
    la a0, str1
    li a7, 4            
    ecall
    mv a0, s0
    li a7, 1            
    ecall  
    la a0, str2
    li a7, 4            
    ecall                
    
    li a7, 10            
    ecall  
.globl maxSubArray
maxSubArray:
    mv s0, a0               # s0 = nums
    mv s1, a1               # s1 = numsSize
    lw s2, 0(s0)            # s2 = max_current = nums[0]
    lw s3, 0(s0)            # s3 = max_global = nums[0]

    li s4, 1                # s4 = i = 1

loop:
    bge s4, s1, end_loop    # if (i >= numsSize) break

    slli t0, s4, 2          # t0 = i * 4 
    add t1, s0, t0          # t1 = nums + i*4
    lw t2, 0(t1)            # t2 = nums[i]
    add t3, s2, t2          # t3 = max_current + nums[i]
    blt t2, t3, no_change1  # if (nums[i] > (max_current + nums[i]))
    mv s2, t2               # max_current = nums[i]
    j check_global1

no_change1:
    mv s2, t3               # max_current = max_current + nums[i]

check_global1:
    blt s2, s3, no_global1  # if (max_current > max_global)
    mv s3, s2               # max_global = max_current

no_global1:
    addi s4, s4, 1          # i++
    bge s4, s1, end_loop    # if (i >= numsSize) break

    slli t0, s4, 2          # t0 = i * 4 
    add t1, s0, t0          # t1 = nums + i*4
    lw t2, 0(t1)            # t2 = nums[i]
    add t3, s2, t2          # t3 = max_current + nums[i]
    blt t2, t3, no_change2  # if (nums[i] > (max_current + nums[i]))
    mv s2, t2               # max_current = nums[i]
    j check_global2

no_change2:
    mv s2, t3               # max_current = max_current + nums[i]

check_global2:
    blt s2, s3, no_global2  # if (max_current > max_global)
    mv s3, s2               # max_global = max_current

no_global2:
    addi s4, s4, 1          # i++
    j loop

end_loop:
    mv a0, s3               # return max_global
    ret

