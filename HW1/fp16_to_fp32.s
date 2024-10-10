fp16_to_fp32:
    # Assume h is passed in a0, and result will be returned in a0
    mv s0, a0                 # move h to s0
    slli s1, s0, 16           # s1 = w = (uint32_t) h << 16

    # Extract the sign bit
    lui s2, 0x80000           # Load upper immediate, s2 = 0x80000000
    and s2, s1, s2            # s2 = sign = w & 0x80000000

    # Extract the nonsign bits
    lui s3, 0x7FFFF           # Load upper immediate, s3 = 0x7FFFF000
    li  t0, 0xFFF
    or  s3, s3, t0            # s3 = 0x7FFFFFFF
    and s3, s1, s3            # s3 = nonsign = w & 0x7FFFFFFF

    # Call my_clz function
    mv a0, s3                 # Move nonsign to a0 (for function argument)
    addi sp, sp, -24
    sw ra, 20(sp)
    sw s0, 16(sp)
    sw s1, 12(sp)
    sw s2, 8(sp)
    sw s3, 4(sp)
    jal ra, my_clz            # Call my_clz
    lw ra, 20(sp)
    lw s0, 16(sp)
    lw s1, 12(sp)
    lw s2, 8(sp)
    lw s3, 4(sp)
    addi sp, sp, 24
    mv s4, a0                 # Move result of my_clz to s4 (renorm_shift)

    # Calculate renorm_shift > 5 ? renorm_shift - 5 : 0
    addi t0, zero, 5          # t0 = 5
    bgt s4, t0, adjust_shift  # If renorm_shift > 5, jump to adjust_shift
    mv s4, zero               # renorm_shift = 0
    j done_shift
adjust_shift:
    sub s4, s4, t0            # renorm_shift = renorm_shift - 5
        
done_shift:

    # Calculate inf_nan_mask
    lui t0, 0x04000
    add t1, s3, t0            # t1 = nonsign + 0x04000000
    srai t1, t1, 8            # t1 = t1 >> 8
    lui t2, 0x7F800            
    and s5, t1, t2            # s6 = inf_nan_mask = (nonsign + 0x04000000) & 0x7F800000

    # Calculate zero_mask
    addi t0, s3, -1           # t0 = nonsign - 1
    srai s6, t0, 31           # t0 = zero_mask = (nonsign - 1) >> 31

    # Calculate final result
    sll t0, s3, s4            # t0 = nonsign << renorm_shift
    srli t0, t0, 3            # t0 = nonsign << renorm_shift >> 3
        
    addi t1, zero, 0x00070
    sub t1, t1, s4             
    slli t1, t1, 23           # t1 = (0x70 - renorm_shift) << 23
        
    add t2, t0, t1            # t2 = (nonsign << renorm_shift >> 3) + 
                              #      ((0x70 - renorm_shift) << 23)
        
    or t3, t2, s5             # t3 = t2 | inf_nan_mask
    xori t4, s6, 0xFFF        # t4 = ~zero_mask
    and t5, t3, t4            # t5 = t3 & ~zero_mask
    or a0, s2, t5             # Return value
    
    ret