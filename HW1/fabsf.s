fabsf:
    # Assume x is passed in a0, and result will be returned in a0
    li t1, 0x7FFFFFFF # Load mask value into t1
    and a0, a0, t1    # clear sign bit
    ret