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
main:
    addi sp, sp, -16
    sw ra, 12(sp)
    sw s0, 8(sp)

    la s0, nums1         # load nums address

    la t0, size1         # numsSize 
    lw a1, 0(t0)

    la a0, nums1         

    call maxSubArray

    lw ra, 12(sp)
    lw s0, 8(sp)
    addi sp, sp, 16

    jal ra, printResult

    la s0, nums2         # load nums address

    la t0, size2         # numsSize 
    lw a1, 0(t0)

    la a0, nums2         

    call maxSubArray

    lw ra, 12(sp)
    lw s0, 8(sp)
    addi sp, sp, 16

    jal ra, printResult

    la s0, nums3         # load nums address

    la t0, size3         # numsSize 
    lw a1, 0(t0)

    la a0, nums3         

    call maxSubArray

    lw ra, 12(sp)
    lw s0, 8(sp)
    addi sp, sp, 16

    jal ra, printResult

    li a7, 10           # end
    ecall

.globl maxSubArray
maxSubArray:
    addi sp, sp, -8         
    sw ra, 4(sp)
 
    mv s0, a0               # s0 = nums
    mv s1, a1               # s1 = numsSize
    lw s2, 0(s0)            # s2 = max_current = nums[0]
    lw s3, 0(s0)            # s3 = max_global = nums[0]


    li s4, 1                # s4 = i = 1
loop:
    bge s4, s1, end_loop    # if (i >= numsSize) break
    slli t0, s4, 2          # t0 = i * 4 (因為每個整數佔 4 字節)
    add t1, s0, t0          # t1 = nums + i*4
    lw t2, 0(t1)            # t2 = nums[i]

    add t3, s2, t2          # t3 = max_current + nums[i]
    blt t2, t3, no_change   # if (nums[i] > (max_current + nums[i]))
    mv s2, t2               # max_current = nums[i]
    j check_global
    
no_change:
    mv s2, t3               # max_current = max_current + nums[i]
    
check_global:
    blt s2, s3, no_global   # if (max_current > max_global)
    mv s3, s2               # max_global = max_current
    
no_global:
    addi s4, s4, 1          # i++
    j loop
    
end_loop:
    mv a0, s3               # return max_global

    lw ra, 4(sp)
    addi sp, sp, 8
    jr ra                     

printResult:
    mv t0, a0           # return value
    
    la a0, str1
    li a7, 4            
    ecall
    
    mv a0, t0
    li a7, 1            
    ecall

    la a0, str2
    li a7, 4            
    ecall
    jr ra