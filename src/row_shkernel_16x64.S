    .text 
    .global _row_shkernel_16x64
    .align  4

.macro KERNEL_M16N64_K1
    ld1h    {z4.h}, p5/z,   [x10]     //packa a_ptr
    ld1h    {z0.h-z1.h}, pn10/z, [x24]     //packb 
    ld1h    {z2.h-z3.h}, pn10/z, [x24, x29, lsl #1]   //packb + 2 * ceil(kc/2) * SVLh fp16
    fmopa   za0.s, p5/m, p0/m, z4.h, z0.h
    fmopa   za1.s, p5/m, p1/m, z4.h, z1.h
    fmopa   za2.s, p5/m, p2/m, z4.h, z2.h
    fmopa   za3.s, p5/m, p3/m, z4.h, z3.h
    addvl x10, x10, #1                     // packa += 1*svls
    addvl x24, x24, #2                     // packb += 2*svls 
.endm 


.macro KERNEL_M16N64_K16    
//--------------- 
    ld1h    {z0.h-z3.h}, pn10/z,  [x10]    //4 a_ptr
    ld1h    {z4.h-z7.h}, pn10/z,  [x24]    //2-2 b_ptr  
    ld1h    {z8.h-z11.h}, pn10/z,  [x24, x29, lsl #1]   //4-2 b_ptr
    fmopa   za0.s, p5/m, p0/m, z0.h, z4.h
    fmopa   za1.s, p5/m, p1/m, z0.h, z5.h
    fmopa   za0.s, p5/m, p0/m, z1.h, z6.h
    fmopa   za1.s, p5/m, p1/m, z1.h, z7.h

    addvl   x24, x24, #4

    ld1h    {z12.h-z15.h}, pn10/z,   [x24]    //2-4 bptr
    fmopa   za2.s, p5/m, p2/m, z0.h, z8.h
    fmopa   za3.s, p5/m, p3/m, z0.h, z9.h
    fmopa   za2.s, p5/m, p2/m, z1.h, z10.h
    fmopa   za3.s, p5/m, p3/m, z1.h, z11.h

    ld1h    {z16.h-z19.h}, pn10/z,  [x24, x29, lsl #1]   //4-4 b_ptr
    fmopa   za0.s, p5/m, p0/m, z2.h, z12.h
    fmopa   za1.s, p5/m, p1/m, z2.h, z13.h
    fmopa   za0.s, p5/m, p0/m, z3.h, z14.h
    fmopa   za1.s, p5/m, p1/m, z3.h, z15.h

    ld1h    {z20.h-z23.h}, pn10/z,  [x10, #4, MUL VL]    //8 a_ptr
    addvl   x24, x24, #4
    ld1h    {z24.h-z27.h}, pn10/z,  [x24]    //2-6 b_ptr  
    fmopa   za2.s, p5/m, p2/m, z2.h, z16.h
    fmopa   za3.s, p5/m, p3/m, z2.h, z17.h
    fmopa   za2.s, p5/m, p2/m, z3.h, z18.h
    fmopa   za3.s, p5/m, p3/m, z3.h, z19.h

//------------ 4 ---------------
    ld1h    {z28.h-z31.h}, pn10/z,  [x24, x29, lsl #1]   //4-6 b_ptr
    fmopa   za0.s, p5/m, p0/m, z20.h, z24.h
    fmopa   za1.s, p5/m, p1/m, z20.h, z25.h
    fmopa   za0.s, p5/m, p0/m, z21.h, z26.h
    fmopa   za1.s, p5/m, p1/m, z21.h, z27.h

    addvl   x24, x24, #4

    ld1h    {z0.h-z3.h}, pn10/z,   [x24]    //2-6 bptr
    fmopa   za2.s, p5/m, p2/m, z20.h, z28.h
    fmopa   za3.s, p5/m, p3/m, z20.h, z29.h
    fmopa   za2.s, p5/m, p2/m, z21.h, z30.h
    fmopa   za3.s, p5/m, p3/m, z21.h, z31.h

    ld1h    {z4.h-z7.h}, pn10/z,  [x24, x29, lsl #1]   //4-6 b_ptr
    fmopa   za0.s, p5/m, p0/m, z22.h, z0.h
    fmopa   za1.s, p5/m, p1/m, z22.h, z1.h
    fmopa   za0.s, p5/m, p0/m, z23.h, z2.h
    fmopa   za1.s, p5/m, p1/m, z23.h, z3.h

    ld1h    {z8.h-z11.h}, pn10/z,  [x10, #8, MUL VL]    //12 a_ptr
    addvl   x24, x24, #4
    ld1h    {z12.h-z15.h}, pn10/z,  [x24]    //2-12 b_ptr  

    fmopa   za2.s, p5/m, p2/m, z22.h, z4.h
    fmopa   za3.s, p5/m, p3/m, z22.h, z5.h
    fmopa   za2.s, p5/m, p2/m, z23.h, z6.h
    fmopa   za3.s, p5/m, p3/m, z23.h, z7.h

//------------ 8 ---------------
    ld1h    {z16.h-z19.h}, pn10/z,  [x24, x29, lsl #1]   //4-12 b_ptr
    fmopa   za0.s, p5/m, p0/m, z8.h, z12.h
    fmopa   za1.s, p5/m, p1/m, z8.h, z13.h
    fmopa   za0.s, p5/m, p0/m, z9.h, z14.h
    fmopa   za1.s, p5/m, p1/m, z9.h, z15.h

    addvl   x24, x24, #4

    ld1h    {z12.h-z15.h}, pn10/z,   [x24]    //2-12 bptr
    fmopa   za2.s, p5/m, p2/m, z8.h, z16.h
    fmopa   za3.s, p5/m, p3/m, z8.h, z17.h
    fmopa   za2.s, p5/m, p2/m, z9.h, z18.h
    fmopa   za3.s, p5/m, p3/m, z9.h, z19.h

    ld1h    {z16.h-z19.h}, pn10/z,  [x24, x29, lsl #1]   //4-12 b_ptr
    fmopa   za0.s, p5/m, p0/m, z10.h, z12.h
    fmopa   za1.s, p5/m, p1/m, z10.h, z13.h
    fmopa   za0.s, p5/m, p0/m, z11.h, z14.h
    fmopa   za1.s, p5/m, p1/m, z11.h, z15.h

    ld1h    {z20.h-z23.h}, pn10/z,  [x10, #12, MUL VL]    //16 a_ptr
    addvl   x24, x24, #4
    ld1h    {z24.h-z27.h}, pn10/z,  [x24]    //2-16 b_ptr  
    fmopa   za2.s, p5/m, p2/m, z10.h, z16.h
    fmopa   za3.s, p5/m, p3/m, z10.h, z17.h
    fmopa   za2.s, p5/m, p2/m, z11.h, z18.h
    fmopa   za3.s, p5/m, p3/m, z11.h, z19.h

    
//------------ 12 ---------------
    ld1h    {z28.h-z31.h}, pn10/z,  [x24, x29, lsl #1]   //4-16 b_ptr
    fmopa   za0.s, p5/m, p0/m, z20.h, z24.h
    fmopa   za1.s, p5/m, p1/m, z20.h, z25.h
    fmopa   za0.s, p5/m, p0/m, z21.h, z26.h
    fmopa   za1.s, p5/m, p1/m, z21.h, z27.h

    addvl   x24, x24, #4

    ld1h    {z0.h-z3.h}, pn10/z,  [x24]    //2-16 bptr
    fmopa   za2.s, p5/m, p2/m, z20.h, z28.h
    fmopa   za3.s, p5/m, p3/m, z20.h, z29.h
    fmopa   za2.s, p5/m, p2/m, z21.h, z30.h
    fmopa   za3.s, p5/m, p3/m, z21.h, z31.h

    ld1h    {z4.h-z7.h}, pn10/z,  [x24, x29, lsl #1]   //4-16 b_ptr
    fmopa   za0.s, p5/m, p0/m, z22.h, z0.h
    fmopa   za1.s, p5/m, p1/m, z22.h, z1.h
    fmopa   za0.s, p5/m, p0/m, z23.h, z2.h
    fmopa   za1.s, p5/m, p1/m, z23.h, z3.h

    fmopa   za2.s, p5/m, p2/m, z22.h, z4.h
    fmopa   za3.s, p5/m, p3/m, z22.h, z5.h
    fmopa   za2.s, p5/m, p2/m, z23.h, z6.h
    fmopa   za3.s, p5/m, p3/m, z23.h, z7.h

    addvl   x24, x24, #4        // packb
    addvl   x10, x10, 16        // packa
//------------ 16 ---------------
.endm


_row_shkernel_16x64:  //fp16fp16 -> fp32
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
    lsl     x17, x8, #2    // ldc * 4
    add     x15, x25, x8   // ldc * 3


    add     x26, x1, #1
    lsr     x26, x26, #1              // ceil(kc/2)
    mul     x29, x26, x12             // SVLs * ceil(kc/2)
    lsl     x29, x29, #2              // 2 * ceil(kc/2) * SVLh

    mul     x28, x12, x8             // SVLs * ldc

    lsl     x22, x0, #1             // 2 * mc

    mov     x14, #0
    whilelt p4.s, x14, x0           // tiles predicate (M dimension)

    mov     x30, #0                 
    whilelt p5.h, x30, x22          // tile predicate (M dimension) as counter

LOOP_MR:
    mov     x27, x3                     // packa
    mov     x20, x6                     // c_base
    mov     x16, x5                     // packb

    mov     x21, #0
    lsl     x19, x2, #2                 // N exit condition   2 * nc  fp16 bytes
    whilelt pn9.b, x21, x19, vlx4       // tiles predicate (N dimension)

LOOP_NR:
    mov     x10, x27                  // packa
    mov     x24, x16                  // packb

    pext   {p0.b, p1.b}, pn9[0]      // tiles predicate (N dimension) tile 0/1
    pext   {p2.b, p3.b}, pn9[1]      // tiles predicate (N dimension) tile 2/3
    
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

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    LOAD_C_END


//-------------------------------------------------------------------  
KERNEL_START:

    ptrue   pn10.b

    lsr x23, x26, #4                 // ceil(KC/2) / 16
    and x13, x26, #0xF               // ceil(KC/2) % 16

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

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4 * ldc FP32 bytes
    add     w13, w13, #4

    psel    pn10, pn9, p4.s[w13, 0]
    psel    pn11, pn9, p4.s[w13, 1]
    psel    pn12, pn9, p4.s[w13, 2]
    psel    pn13, pn9, p4.s[w13, 3]
    mova    {z16.s-z19.s}, za0h.s[w13,0:3]
    mova    {z20.s-z23.s}, za1h.s[w13,0:3]
    mova    {z24.s-z27.s}, za2h.s[w13,0:3]
    mova    {z28.s-z31.s}, za3h.s[w13,0:3]

    st1w    {z16.s, z20.s, z24.s, z28.s},  pn10, [x11]               // c_ptr0 
    st1w    {z17.s, z21.s, z25.s, z29.s},  pn11, [x11, x8, lsl #2]   // c_ptr0 + ldc
    st1w    {z18.s, z22.s, z26.s, z30.s},  pn12, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    st1w    {z19.s, z23.s, z27.s, z31.s},  pn13, [x11, x15, lsl #2]   // c_ptr0 + ldc*3

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4 * ldc FP32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    STORE_C_END

//--------Jump to LOOP_NR-----------------------

    //add     x16, x16, x22, lsl #4     // packbs += ceil(KC/2) * 2 * SVLh * 2  fp16) (bytes) = ceil(KC/2) * 4 * SVLs fp32
    add     x16, x16, x29, lsl #2
    addvl   x20, x20, #4              // c_base += 4*SVLb


    addvl   x21, x21, #4              // N loop counter += 4 * SVLb
    whilelt pn9.b, x21, x19, vlx4     // tile predicate (N dimension)
    b.first LOOP_NR
    
    

//----Jump to LOOP_MR-----------------------

    //add    x3, x3, x22, lsl #2       // packa += ceil(KC/2) * SVLs fp32 (bytes)
    add    x3, x3, x29
    add    x6, x6, x28, lsl #2       // c += SVLs * ldc fp32 (bytes)

    inch    x30
    whilelt p5.h, x30, x22 
    
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