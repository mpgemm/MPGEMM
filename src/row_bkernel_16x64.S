    .text 
    .global _row_bkernel_16x64
    .align  4

.macro KERNEL_M16N64_K1
    ld1b    {z4.b}, p5/z,   [x10]               //packa a_ptr
    ld1b    {z0.b-z3.b}, pn10/z, [x24]               //packb 
    smopa   za0.s, p5/m, p0/m, z4.b, z0.b
    smopa   za1.s, p5/m, p1/m, z4.b, z1.b
    smopa   za2.s, p5/m, p2/m, z4.b, z2.b
    smopa   za3.s, p5/m, p3/m, z4.b, z3.b
    addvl x10, x10, #1                     // packa += 1*svls
    addvl x24, x24, #4                     // packb += 4*svlb 
.endm 


.macro KERNEL_M16N64_K16    
//--------------- 
    ld1b    {z0.b-z3.b}, pn10/z,  [x10]    //4 a_ptr
    ld1b    {z4.b-z7.b}, pn10/z,  [x24]    //1-4 b_ptr  
    smopa   za0.s, p5/m, p0/m, z0.b, z4.b
    smopa   za1.s, p5/m, p1/m, z0.b, z5.b
    smopa   za2.s, p5/m, p2/m, z0.b, z6.b
    smopa   za3.s, p5/m, p3/m, z0.b, z7.b

    addvl   x24, x24, #4

    ld1b    {z8.b-z11.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z1.b, z8.b
    smopa   za1.s, p5/m, p1/m, z1.b, z9.b
    smopa   za2.s, p5/m, p2/m, z1.b, z10.b
    smopa   za3.s, p5/m, p3/m, z1.b, z11.b
   
    addvl   x24, x24, #4

    ld1b    {z12.b-z15.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z2.b, z12.b
    smopa   za1.s, p5/m, p1/m, z2.b, z13.b
    smopa   za2.s, p5/m, p2/m, z2.b, z14.b
    smopa   za3.s, p5/m, p3/m, z2.b, z15.b

    addvl   x24, x24, #4

    ld1b    {z16.b-z19.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z3.b, z16.b
    smopa   za1.s, p5/m, p1/m, z3.b, z17.b
    smopa   za2.s, p5/m, p2/m, z3.b, z18.b
    smopa   za3.s, p5/m, p3/m, z3.b, z19.b

    addvl   x24, x24, #4        // packb

    //4
    ld1b    {z20.b-z23.b}, pn10/z,  [x10, #4, MUL VL]    //4 a_ptr
    ld1b    {z24.b-z27.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z20.b, z24.b
    smopa   za1.s, p5/m, p1/m, z20.b, z25.b
    smopa   za2.s, p5/m, p2/m, z20.b, z26.b
    smopa   za3.s, p5/m, p3/m, z20.b, z27.b

    addvl   x24, x24, #4        // packb
    ld1b    {z28.b-z31.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z21.b, z28.b
    smopa   za1.s, p5/m, p1/m, z21.b, z29.b
    smopa   za2.s, p5/m, p2/m, z21.b, z30.b
    smopa   za3.s, p5/m, p3/m, z21.b, z31.b


    addvl   x24, x24, #4        // packb
    ld1b    {z0.b-z3.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z22.b, z0.b
    smopa   za1.s, p5/m, p1/m, z22.b, z1.b
    smopa   za2.s, p5/m, p2/m, z22.b, z2.b
    smopa   za3.s, p5/m, p3/m, z22.b, z3.b

    addvl   x24, x24, #4        // packb
    ld1b    {z4.b-z7.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z23.b, z4.b
    smopa   za1.s, p5/m, p1/m, z23.b, z5.b
    smopa   za2.s, p5/m, p2/m, z23.b, z6.b
    smopa   za3.s, p5/m, p3/m, z23.b, z7.b

    addvl   x24, x24, #4        // packb

    //8
    ld1b    {z8.b-z11.b}, pn10/z,  [x10, #8, MUL VL]    //4 a_ptr
    ld1b    {z12.b-z15.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z8.b, z12.b
    smopa   za1.s, p5/m, p1/m, z8.b, z13.b
    smopa   za2.s, p5/m, p2/m, z8.b, z14.b
    smopa   za3.s, p5/m, p3/m, z8.b, z15.b

    addvl   x24, x24, #4        // packb
    ld1b    {z16.b-z19.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z9.b, z16.b
    smopa   za1.s, p5/m, p1/m, z9.b, z17.b
    smopa   za2.s, p5/m, p2/m, z9.b, z18.b
    smopa   za3.s, p5/m, p3/m, z9.b, z19.b

    addvl   x24, x24, #4        // packb
    ld1b    {z20.b-z23.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z10.b, z20.b
    smopa   za1.s, p5/m, p1/m, z10.b, z21.b
    smopa   za2.s, p5/m, p2/m, z10.b, z22.b
    smopa   za3.s, p5/m, p3/m, z10.b, z23.b

    addvl   x24, x24, #4        // packb
    ld1b    {z24.b-z27.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z11.b, z24.b
    smopa   za1.s, p5/m, p1/m, z11.b, z25.b
    smopa   za2.s, p5/m, p2/m, z11.b, z26.b
    smopa   za3.s, p5/m, p3/m, z11.b, z27.b

    addvl   x24, x24, #4        // packb

    //12
    ld1b    {z28.b-z31.b}, pn10/z,  [x10, #12, MUL VL]    //4 a_ptr
    ld1b    {z0.b-z3.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z28.b, z0.b
    smopa   za1.s, p5/m, p1/m, z28.b, z1.b
    smopa   za2.s, p5/m, p2/m, z28.b, z2.b
    smopa   za3.s, p5/m, p3/m, z28.b, z3.b

    addvl   x24, x24, #4        // packb
    ld1b    {z4.b-z7.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z29.b, z4.b
    smopa   za1.s, p5/m, p1/m, z29.b, z5.b
    smopa   za2.s, p5/m, p2/m, z29.b, z6.b
    smopa   za3.s, p5/m, p3/m, z29.b, z7.b

    addvl   x24, x24, #4        // packb
    ld1b    {z8.b-z11.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z30.b, z8.b
    smopa   za1.s, p5/m, p1/m, z30.b, z9.b
    smopa   za2.s, p5/m, p2/m, z30.b, z10.b
    smopa   za3.s, p5/m, p3/m, z30.b, z11.b

    addvl   x24, x24, #4        // packb
    ld1b    {z12.b-z15.b}, pn10/z,  [x24]  
    smopa   za0.s, p5/m, p0/m, z31.b, z12.b
    smopa   za1.s, p5/m, p1/m, z31.b, z13.b
    smopa   za2.s, p5/m, p2/m, z31.b, z14.b
    smopa   za3.s, p5/m, p3/m, z31.b, z15.b

    addvl   x24, x24, #4        // packb
    addvl   x10, x10, #16        // packa
//------------ 16 ---------------
.endm


_row_bkernel_16x64:  //i8i8->i32
//x0:mc, x1:kc, x2:nc, x3: packa, x4: XB, x5: packb, x6:c, x7:KC, x8:ldc, x9:pc

    ldr     w8,  [sp]        // ldc
    ldr     w9,  [sp, #4]    // pc

    stp     x19, x20, [sp, #-96]!
    stp     x21, x22, [sp, #16]
    stp     x23, x24, [sp, #32]
    stp     x25, x26, [sp, #48]
    stp     x27, x28, [sp, #64]
    stp     x29, x30, [sp, #80]


    smstart


    cntw    x12                     //   SVLs -> 16

    
    lsl     x25, x8, #1    // ldc * 2
    add     x15, x25, x8   // ldc * 3


    add     x26, x1, #3
    lsr     x26, x26, #2              // ceil(kc/4)
    mul     x29, x26, x12             // SVLs * ceil(kc/4)
    lsl     x29, x29, #2              // ceil(kc/4) * SVLb
    

    mul     x28, x12, x8             // SVLs * ldc

    lsl     x22, x0, #2             // 4 * mc

    mov     x14, #0
    whilelt p4.s, x14, x0           // tiles predicate (M dimension)

    mov     x30, #0                 
    whilelt p5.b, x30, x22          // tile predicate (M dimension) as counter

LOOP_MR:
    mov     x27, x3                     // packa
    mov     x20, x6                     // c_base
    mov     x16, x5                     // packb

    mov     x21, #0
    lsl     x19, x2, #2                 // N exit condition   4 * nc  int8 bytes
    whilelt pn9.s, x21, x2, vlx4       // tiles predicate (N dimension)

    mov     x17, #0
    whilelt pn14.b, x17, x19, vlx4

LOOP_NR:
    mov     x10, x27                  // packa
    mov     x24, x16                  // packb

    pext   {p0.b, p1.b}, pn14[0]      // tiles predicate (N dimension) tile 0/1
    pext   {p2.b, p3.b}, pn14[1]      // tiles predicate (N dimension) tile 2/3

    zero    {za}

    cmp     x9, x7
    b.lt    KERNEL_START
//----------------LOAD  C---------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr

LOAD_C_END:
    psel    pn10, pn9, p4.s[w13, 0]
    psel    pn11, pn9, p4.s[w13, 1]
    psel    pn12, pn9, p4.s[w13, 2]
    psel    pn13, pn9, p4.s[w13, 3]
    ld1w    {z0.s, z4.s, z8.s, z12.s}, pn10/z, [x11]               // c_ptr0
    ld1w    {z1.s, z5.s, z9.s, z13.s}, pn11/z, [x11, x8, lsl #2]   // c_ptr0 + ldc
    ld1w    {z2.s, z6.s, z10.s, z14.s}, pn12/z, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    ld1w    {z3.s, z7.s, z11.s, z15.s}, pn13/z, [x11, x15, lsl #2]  // c_ptr0 + ldc*3

    mova    za0h.s[w13,0:3], {z0.s-z3.s}
    mova    za1h.s[w13,0:3], {z4.s-z7.s}
    mova    za2h.s[w13,0:3], {z8.s-z11.s}
    mova    za3h.s[w13,0:3], {z12.s-z15.s}

    add     x11, x11, x8, lsl #4         //c_ptr0 += 4*ldc int32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    LOAD_C_END


//-------------------------------------------------------------------  
KERNEL_START:

    ptrue   pn10.b

    lsr x23, x26, #4                 // ceil(KC/4) / 16
    and x13, x26, #0xF               // ceil(KC/4) % 16

    cbz  x23, 3f
KERNEL_M16xN64_LOOP_K16:
    KERNEL_M16N64_K16
    subs x23, x23, #1
    b.ne KERNEL_M16xN64_LOOP_K16

3:
    cbz  x13, 4f
KERNEL_M16xN64_LOOP_K1:
    KERNEL_M16N64_K1
    subs  x13, x13, #1
    b.ne  KERNEL_M16xN64_LOOP_K1
    
4:
    //nop

//----------------STORE C-----------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr

STORE_C_END:
    psel    pn10, pn9, p4.s[w13, 0]
    psel    pn11, pn9, p4.s[w13, 1]
    psel    pn12, pn9, p4.s[w13, 2]
    psel    pn13, pn9, p4.s[w13, 3]
    mova    {z0.s-z3.s}, za0h.s[w13,0:3]
    mova    {z4.s-z7.s}, za1h.s[w13,0:3]
    mova    {z8.s-z11.s}, za2h.s[w13,0:3]
    mova    {z12.s-z15.s}, za3h.s[w13,0:3]

    st1w    {z0.s, z4.s, z8.s, z12.s},  pn10, [x11]               // c_ptr0 
    st1w    {z1.s, z5.s, z9.s, z13.s},  pn11, [x11, x8, lsl #2]   // c_ptr0 + ldc
    st1w    {z2.s, z6.s, z10.s, z14.s},  pn12, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    st1w    {z3.s, z7.s, z11.s, z15.s},  pn13, [x11, x15, lsl #2]   // c_ptr0 + ldc*3

    add     x11, x11, x8, lsl #4         //c_ptr0 += 4 * ldc FP32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    STORE_C_END

//--------Jump to LOOP_NR-----------------------

   
    add     x16, x16, x29, lsl #2       // packbs += ceil(KC/4) * 4 * SVLb   int8 
    addvl   x20, x20, #4                // c_base += 4*SVLb


    addvl   x17, x17, #4              // N loop counter += 4 * SVLb
    whilelt pn14.b, x17, x19, vlx4     // tiles predicate (N dimension)

    incw    x21,all, mul #4
    whilelt pn9.s, x21, x2, vlx4     // tile predicate (N dimension)
    b.first LOOP_NR
    
    
//----Jump to LOOP_MR-----------------------

    add    x3, x3, x29               // packa += ceil(KC/4) * SVLs fp32 (bytes)
    add    x6, x6, x28, lsl #2       // c += SVLs * ldc fp32 (bytes)

    incb    x30
    whilelt p5.b, x30, x22 
    
    incw    x14             // M loop counter += SVLs
    whilelt p4.s, x14, x0   // tiles predicate (M dimension)
    b.first LOOP_MR



    smstop


    ldp     x29, x30, [sp, #80]
    ldp     x27, x28, [sp, #64]
    ldp     x25, x26, [sp, #48]
    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #96
    

    ret