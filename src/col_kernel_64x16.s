    .text 
    .global _col_kernel_64x16
    .align  4

.macro PACKA_KERNEL_M64N16_K1
    ld1w    {z0.s-z3.s}, pn9/z, [x19]       //a_ptr
    ld1w    {z4.s}, p4/z, [x24]       //packb

    fmopa   za0.s, p0/m, p4/m, z0.s, z4.s
    fmopa   za1.s, p1/m, p4/m, z1.s, z4.s
    fmopa   za2.s, p2/m, p4/m, z2.s, z4.s
    fmopa   za3.s, p3/m, p4/m, z3.s, z4.s

    st1w    {z0.s-z3.s}, pn9, [x10]        //packa

    add     x19, x19, x8, lsl #2    // a_ptr+= lda
    addvl   x24, x24, #1            // packb += SVLb
    addvl   x10, x10, #4            // packa += 4*SVLb (bytes)

.endm


.macro PACKA_KERNEL_M64N16_K16
    // K = 8
    ld1w    {z0.s-z3.s}, pn9/z, [x19]       //1 a_ptr
    ld1w    {z4.s-z7.s}, pn10/z, [x24]       //4 packb

    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z8.s-z11.s}, pn9/z, [x19]      //2 a_ptr

    fmopa   za0.s, p0/m, p4/m, z0.s, z4.s
    fmopa   za1.s, p1/m, p4/m, z1.s, z4.s
    fmopa   za2.s, p2/m, p4/m, z2.s, z4.s
    fmopa   za3.s, p3/m, p4/m, z3.s, z4.s

    st1w    {z0.s-z3.s}, pn9, [x10]         //1 packa
   
    add     x19, x19, x8, lsl #2            
    ld1w    {z12.s-z15.s}, pn9/z, [x19]      //3 a_ptr
    
    fmopa   za0.s, p0/m, p4/m, z8.s, z5.s
    fmopa   za1.s, p1/m, p4/m, z9.s, z5.s
    fmopa   za2.s, p2/m, p4/m, z10.s, z5.s
    fmopa   za3.s, p3/m, p4/m, z11.s, z5.s

    st1w    {z8.s-z11.s}, pn9, [x10, #4, MUL VL]   //2 packa
    
    add     x19, x19, x8, lsl #2          
    ld1w    {z16.s-z19.s}, pn9/z, [x19]      //4 a_ptr
    fmopa   za0.s, p0/m, p4/m, z12.s, z6.s
    fmopa   za1.s, p1/m, p4/m, z13.s, z6.s
    fmopa   za2.s, p2/m, p4/m, z14.s, z6.s
    fmopa   za3.s, p3/m, p4/m, z15.s, z6.s

    st1w    {z12.s-z15.s}, pn9, [x10, #8, MUL VL]       //3 packa
    
    add     x19, x19, x8, lsl #2      
    ld1w    {z24.s-z27.s}, pn10/z, [x24, #4, MUL VL]       //8 packb      
    ld1w    {z20.s-z23.s}, pn9/z, [x19]      //5 a_ptr
    fmopa   za0.s, p0/m, p4/m, z16.s, z7.s
    fmopa   za1.s, p1/m, p4/m, z17.s, z7.s
    fmopa   za2.s, p2/m, p4/m, z18.s, z7.s
    fmopa   za3.s, p3/m, p4/m, z19.s, z7.s

    st1w    {z16.s-z19.s}, pn9, [x10, #12, MUL VL]      //4 packa
    
    add     x19, x19, x8, lsl #2            
    ld1w    {z28.s-z31.s}, pn9/z, [x19]      //6 a_ptr
    fmopa   za0.s, p0/m, p4/m, z20.s, z24.s
    fmopa   za1.s, p1/m, p4/m, z21.s, z24.s
    fmopa   za2.s, p2/m, p4/m, z22.s, z24.s
    fmopa   za3.s, p3/m, p4/m, z23.s, z24.s

    st1w    {z20.s-z23.s}, pn9, [x10, #16, MUL VL]      //5 packa
   
    add     x19, x19, x8, lsl #2            
    ld1w    {z0.s-z3.s}, pn9/z, [x19]      //7 a_ptr
    fmopa   za0.s, p0/m, p4/m, z28.s, z25.s
    fmopa   za1.s, p1/m, p4/m, z29.s, z25.s
    fmopa   za2.s, p2/m, p4/m, z30.s, z25.s
    fmopa   za3.s, p3/m, p4/m, z31.s, z25.s

    st1w    {z28.s-z31.s}, pn9, [x10, #20, MUL VL]      //6 packa
   
    add     x19, x19, x8, lsl #2            
    ld1w    {z4.s-z7.s}, pn9/z, [x19]      //8 a_ptr
    fmopa   za0.s, p0/m, p4/m, z0.s, z26.s
    fmopa   za1.s, p1/m, p4/m, z1.s, z26.s
    fmopa   za2.s, p2/m, p4/m, z2.s, z26.s
    fmopa   za3.s, p3/m, p4/m, z3.s, z26.s

    st1w    {z0.s-z3.s}, pn9, [x10, #24, MUL VL]      //7 packa
    
    add     x19, x19, x8, lsl #2  
    ld1w    {z12.s-z15.s}, pn10/z, [x24, #8, MUL VL]       //12 packb          
    ld1w    {z8.s-z11.s}, pn9/z, [x19]      //9 a_ptr
    
    fmopa   za0.s, p0/m, p4/m, z4.s, z27.s
    fmopa   za1.s, p1/m, p4/m, z5.s, z27.s
    fmopa   za2.s, p2/m, p4/m, z6.s, z27.s
    fmopa   za3.s, p3/m, p4/m, z7.s, z27.s
 
//----------------------------------------------------------------------
    st1w    {z4.s-z7.s}, pn9, [x10, #28, MUL VL]      //8 packa
    add     x19, x19, x8, lsl #2       
    ld1w    {z16.s-z19.s}, pn9/z, [x19]      //10 a_ptr
    add     x10, x10, #2048         //packa += 4 * 8 * SVLb    
    fmopa   za0.s, p0/m, p4/m, z8.s, z12.s
    fmopa   za1.s, p1/m, p4/m, z9.s, z12.s
    fmopa   za2.s, p2/m, p4/m, z10.s, z12.s
    fmopa   za3.s, p3/m, p4/m, z11.s, z12.s

    st1w    {z8.s-z11.s}, pn9, [x10]         //9 packa
    add     x19, x19, x8, lsl #2            
    ld1w    {z20.s-z23.s}, pn9/z, [x19]      //11 a_ptr

    fmopa   za0.s, p0/m, p4/m, z16.s, z13.s
    fmopa   za1.s, p1/m, p4/m, z17.s, z13.s
    fmopa   za2.s, p2/m, p4/m, z18.s, z13.s
    fmopa   za3.s, p3/m, p4/m, z19.s, z13.s

    st1w    {z16.s-z19.s}, pn9, [x10, #4, MUL VL]      //10 packa
    add     x19, x19, x8, lsl #2            
    ld1w    {z24.s-z27.s}, pn9/z, [x19]      //12 a_ptr


    fmopa   za0.s, p0/m, p4/m, z20.s, z14.s
    fmopa   za1.s, p1/m, p4/m, z21.s, z14.s
    fmopa   za2.s, p2/m, p4/m, z22.s, z14.s
    fmopa   za3.s, p3/m, p4/m, z23.s, z14.s

    st1w    {z20.s-z23.s}, pn9, [x10, #8, MUL VL]      //11 packa
    add     x19, x19, x8, lsl #2        
    ld1w    {z0.s-z3.s}, pn10/z, [x24, #12, MUL VL]       //16 packb 
    ld1w    {z28.s-z31.s}, pn9/z, [x19]      //13 a_ptr

    fmopa   za0.s, p0/m, p4/m, z24.s, z15.s
    fmopa   za1.s, p1/m, p4/m, z25.s, z15.s
    fmopa   za2.s, p2/m, p4/m, z26.s, z15.s
    fmopa   za3.s, p3/m, p4/m, z27.s, z15.s

    st1w    {z24.s-z27.s}, pn9, [x10, #12, MUL VL]      //12 packa
    add     x19, x19, x8, lsl #2
    ld1w    {z4.s-z7.s}, pn9/z, [x19]      //14 a_ptr
  
    fmopa   za0.s, p0/m, p4/m, z28.s, z0.s
    fmopa   za1.s, p1/m, p4/m, z29.s, z0.s
    fmopa   za2.s, p2/m, p4/m, z30.s, z0.s
    fmopa   za3.s, p3/m, p4/m, z31.s, z0.s

    st1w    {z28.s-z31.s}, pn9, [x10, #16, MUL VL]      //13 packa
    add     x19, x19, x8, lsl #2
    ld1w    {z8.s-z11.s}, pn9/z, [x19]      //15 a_ptr

    fmopa   za0.s, p0/m, p4/m, z4.s, z1.s
    fmopa   za1.s, p1/m, p4/m, z5.s, z1.s  
    fmopa   za2.s, p2/m, p4/m, z6.s, z1.s
    fmopa   za3.s, p3/m, p4/m, z7.s, z1.s

    st1w    {z4.s-z7.s}, pn9, [x10, #20, MUL VL]      //14 packa
    add     x19, x19, x8, lsl #2
    ld1w    {z12.s-z15.s}, pn9/z, [x19]      //16 a_ptr

    fmopa   za0.s, p0/m, p4/m, z8.s, z2.s  
    fmopa   za1.s, p1/m, p4/m, z9.s, z2.s
    fmopa   za2.s, p2/m, p4/m, z10.s, z2.s
    fmopa   za3.s, p3/m, p4/m, z11.s, z2.s

    st1w    {z8.s-z11.s}, pn9, [x10, #24, MUL VL]      //15 packa
    
    fmopa   za0.s, p0/m, p4/m, z12.s, z3.s
    fmopa   za1.s, p1/m, p4/m, z13.s, z3.s
    fmopa   za2.s, p2/m, p4/m, z14.s, z3.s
    fmopa   za3.s, p3/m, p4/m, z15.s, z3.s

    st1w    {z12.s-z15.s}, pn9, [x10, #28, MUL VL]      //16 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    add     x24, x24, #1024         //packb += 16 * SVLb
    add     x10, x10, #2048         //packa += 4 * 8 * SVLb (bytes)
.endm


.macro KERNEL_M64N16_K1
    ld1w    {z0.s-z3.s}, pn9/z,   [x10]    //packa a_ptr
    ld1w    {z4.s}, p4/z,   [x24]    //packb 
    fmopa   za0.s, p0/m, p4/m, z0.s, z4.s
    fmopa   za1.s, p1/m, p4/m, z1.s, z4.s
    fmopa   za2.s, p2/m, p4/m, z2.s, z4.s
    fmopa   za3.s, p3/m, p4/m, z3.s, z4.s
    addvl x10, x10, #4                     // packa += 4*svls
    addvl x24, x24, #1                     // packb += 1*svls 
.endm 


.macro KERNEL_M64N16_K16    
    //---------------
    // K = 16
    ld1w    {z0.s-z3.s}, pn9/z,   [x10]    //1 a_ptr
    ld1w    {z4.s-z7.s}, pn10/z,   [x24]    //4 b_ptr  
    ld1w    {z8.s-z11.s}, pn9/z,   [x10, #4, MUL VL]    //2 aptr
    fmopa   za0.s, p0/m, p4/m, z0.s, z4.s
    fmopa   za1.s, p1/m, p4/m, z1.s, z4.s
    fmopa   za2.s, p2/m, p4/m, z2.s, z4.s
    fmopa   za3.s, p3/m, p4/m, z3.s, z4.s

    ld1w    {z12.s-z15.s}, pn9/z,   [x10, #8, MUL VL]    //3 aptr
    fmopa   za0.s, p0/m, p4/m, z8.s, z5.s
    fmopa   za1.s, p1/m, p4/m, z9.s, z5.s
    fmopa   za2.s, p2/m, p4/m, z10.s, z5.s
    fmopa   za3.s, p3/m, p4/m, z11.s, z5.s

    ld1w    {z16.s-z19.s}, pn9/z,   [x10, #12, MUL VL]    //4 aptr
    fmopa   za0.s, p0/m, p4/m, z12.s, z6.s
    fmopa   za1.s, p1/m, p4/m, z13.s, z6.s
    fmopa   za2.s, p2/m, p4/m, z14.s, z6.s
    fmopa   za3.s, p3/m, p4/m, z15.s, z6.s

    ld1w    {z20.s-z23.s}, pn9/z,   [x10, #16, MUL VL]    //5 aptr
    ld1w    {z24.s-z27.s}, pn10/z,   [x24, #4, MUL VL]    //8 b_ptr
    fmopa   za0.s, p0/m, p4/m, z16.s, z7.s
    fmopa   za1.s, p1/m, p4/m, z17.s, z7.s
    fmopa   za2.s, p2/m, p4/m, z18.s, z7.s
    fmopa   za3.s, p3/m, p4/m, z19.s, z7.s

    ld1w    {z28.s-z31.s}, pn9/z,   [x10, #20, MUL VL]    //6 aptr
    fmopa   za0.s, p0/m, p4/m, z20.s, z24.s
    fmopa   za1.s, p1/m, p4/m, z21.s, z24.s
    fmopa   za2.s, p2/m, p4/m, z22.s, z24.s
    fmopa   za3.s, p3/m, p4/m, z23.s, z24.s

    ld1w    {z0.s-z3.s}, pn9/z,   [x10, #24, MUL VL]    //7 a_ptr
    fmopa   za0.s, p0/m, p4/m, z28.s, z25.s
    fmopa   za1.s, p1/m, p4/m, z29.s, z25.s
    fmopa   za2.s, p2/m, p4/m, z30.s, z25.s
    fmopa   za3.s, p3/m, p4/m, z31.s, z25.s

    ld1w    {z4.s-z7.s}, pn9/z,   [x10, #28, MUL VL]    //8 a_ptr
    fmopa   za0.s, p0/m, p4/m, z0.s, z26.s
    fmopa   za1.s, p1/m, p4/m, z1.s, z26.s
    fmopa   za2.s, p2/m, p4/m, z2.s, z26.s
    fmopa   za3.s, p3/m, p4/m, z3.s, z26.s

    add   x10, x10, #2048  // MR 4SVLs * 8 bytes

    ld1w    {z8.s-z11.s}, pn9/z,   [x10]    //9 a_ptr
    ld1w    {z12.s-z15.s}, pn10/z,  [x24, #8, MUL VL]  //12 bptr
    fmopa   za0.s, p0/m, p4/m, z4.s, z27.s
    fmopa   za1.s, p1/m, p4/m, z5.s, z27.s
    fmopa   za2.s, p2/m, p4/m, z6.s, z27.s
    fmopa   za3.s, p3/m, p4/m, z7.s, z27.s

//--------------------------------------------------------------------
    ld1w    {z16.s-z19.s}, pn9/z,   [x10, #4, MUL VL]    //10 a_ptr
    fmopa   za0.s, p0/m, p4/m, z8.s, z12.s
    fmopa   za1.s, p1/m, p4/m, z9.s, z12.s
    fmopa   za2.s, p2/m, p4/m, z10.s, z12.s
    fmopa   za3.s, p3/m, p4/m, z11.s, z12.s

    ld1w    {z20.s-z23.s}, pn9/z,   [x10, #8, MUL VL]    //11 a_ptr
    fmopa   za0.s, p0/m, p4/m, z16.s, z13.s
    fmopa   za1.s, p1/m, p4/m, z17.s, z13.s
    fmopa   za2.s, p2/m, p4/m, z18.s, z13.s
    fmopa   za3.s, p3/m, p4/m, z19.s, z13.s

    ld1w    {z24.s-z27.s}, pn9/z,   [x10, #12, MUL VL]    //12 a_ptr
    fmopa   za0.s, p0/m, p4/m, z20.s, z14.s
    fmopa   za1.s, p1/m, p4/m, z21.s, z14.s
    fmopa   za2.s, p2/m, p4/m, z22.s, z14.s
    fmopa   za3.s, p3/m, p4/m, z23.s, z14.s

    ld1w    {z28.s-z31.s}, pn9/z,   [x10, #16, MUL VL]    //13 a_ptr
    ld1w    {z0.s-z3.s}, pn10/z,  [x24, #12, MUL VL]  //16 bptr
    fmopa   za0.s, p0/m, p4/m, z24.s, z15.s
    fmopa   za1.s, p1/m, p4/m, z25.s, z15.s
    fmopa   za2.s, p2/m, p4/m, z26.s, z15.s
    fmopa   za3.s, p3/m, p4/m, z27.s, z15.s

    ld1w    {z4.s-z7.s}, pn9/z,   [x10, #20, MUL VL]    //14 a_ptr
    fmopa   za0.s, p0/m, p4/m, z28.s, z0.s
    fmopa   za1.s, p1/m, p4/m, z29.s, z0.s
    fmopa   za2.s, p2/m, p4/m, z30.s, z0.s
    fmopa   za3.s, p3/m, p4/m, z31.s, z0.s

    ld1w    {z8.s-z11.s}, pn9/z,   [x10, #24, MUL VL]    //15 a_ptr
    fmopa   za0.s, p0/m, p4/m, z4.s, z1.s
    fmopa   za1.s, p1/m, p4/m, z5.s, z1.s
    fmopa   za2.s, p2/m, p4/m, z6.s, z1.s
    fmopa   za3.s, p3/m, p4/m, z7.s, z1.s

    ld1w    {z12.s-z15.s}, pn9/z,   [x10, #28, MUL VL]    //16 a_ptr
    fmopa   za0.s, p0/m, p4/m, z8.s, z2.s
    fmopa   za1.s, p1/m, p4/m, z9.s, z2.s
    fmopa   za2.s, p2/m, p4/m, z10.s, z2.s
    fmopa   za3.s, p3/m, p4/m, z11.s, z2.s

    fmopa   za0.s, p0/m, p4/m, z12.s, z3.s
    fmopa   za1.s, p1/m, p4/m, z13.s, z3.s
    fmopa   za2.s, p2/m, p4/m, z14.s, z3.s
    fmopa   za3.s, p3/m, p4/m, z15.s, z3.s

.endm


_col_kernel_64x16:
//x0:mc, x1:kc, x2:nc, x3: XA, x4: packa, x5: packb, x6:c, x7:lda, x8:ldc, x9:pc

    ldr     w8,  [sp]        // ldc
    ldr     w9,  [sp, #4]    // pc

    stp     x19, x20, [sp, #-64]!
    stp     x21, x22, [sp, #16]
    stp     x23, x24, [sp, #32]
    stp     x25, x26, [sp, #48]


    smstart


    cntw    x12                     //   SVLs -> 16

    mov    x20, x6                  // c_base

    lsl     x25, x8, #1   // ldc * 2
    lsl     x17, x8, #2   // ldc * 4
    add     x15, x25, x8   // ldc * 3

    mov x14, #0
    whilelt p4.s, x14, x2           // tiles predicate (N dimension)


    add    x21, x3, x0, lsl #2     // Exit condition for M loop
    mov    x16, x3                  // a_base
    whilelt pn9.b, x16, x21, vlx4   // tiles predicate (M dimension)

//--------------------MR : MC LOOP -> PACKA + FMOPA ------------------------------------
    mov x10, x4                      // packa

LOOP_MR:

    pext   {p0.b, p1.b}, pn9[0]      // tiles predicate (M dimension)
    pext   {p2.b, p3.b}, pn9[1]      // tiles predicate (M dimension)

    zero {za}

    //cmp     x9, x7   // KC
    //b.lt    PACKA_KERNEL

//----------------LOAD  C---------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr

LOAD_C_START:
    psel    pn10, pn9, p4.s[w13, 0]
    psel    pn11, pn9, p4.s[w13, 1]
    psel    pn12, pn9, p4.s[w13, 2]
    psel    pn13, pn9, p4.s[w13, 3]
    ld1w    {z0.s, z4.s, z8.s, z12.s}, pn10/z, [x11]               // c_ptr0
    ld1w    {z1.s, z5.s, z9.s, z13.s}, pn11/z, [x11, x8, lsl #2]   // c_ptr0 + ldc
    ld1w    {z2.s, z6.s, z10.s, z14.s}, pn12/z, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    ld1w    {z3.s, z7.s, z11.s, z15.s}, pn13/z, [x11, x15, lsl #2]  // c_ptr0 + ldc*3

    mova    za0v.s[w13,0:3], {z0.s-z3.s}
    mova    za1v.s[w13,0:3], {z4.s-z7.s}
    mova    za2v.s[w13,0:3], {z8.s-z11.s}
    mova    za3v.s[w13,0:3], {z12.s-z15.s}

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes
    add     w13, w13, #4

    psel    pn10, pn9, p4.s[w13, 0]
    psel    pn11, pn9, p4.s[w13, 1]
    psel    pn12, pn9, p4.s[w13, 2]
    psel    pn13, pn9, p4.s[w13, 3]
    ld1w    {z16.s, z20.s, z24.s, z28.s}, pn10/z, [x11]               // c_ptr0
    ld1w    {z17.s, z21.s, z25.s, z29.s}, pn11/z, [x11, x8, lsl #2]   // c_ptr0 + ldc
    ld1w    {z18.s, z22.s, z26.s, z30.s}, pn12/z, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    ld1w    {z19.s, z23.s, z27.s, z31.s}, pn13/z, [x11, x15, lsl #2]  // c_ptr0 + ldc*3

    mova    za0v.s[w13,0:3], {z16.s-z19.s}
    mova    za1v.s[w13,0:3], {z20.s-z23.s}
    mova    za2v.s[w13,0:3], {z24.s-z27.s}
    mova    za3v.s[w13,0:3], {z28.s-z31.s}

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    LOAD_C_START


//-------------------------------------------------------------------    
PACKA_KERNEL:
    mov x19, x16                     // a_ptr = a_base
    
    mov x24, x5                     // packb

    ptrue pn10.b

//---------------------KC LOOP PACKA------------------------------------------------
    lsr x23, x1, #4                 // KC/16
    and x13, x1, #0xF               // KC % 16
    
    cbz     x23, 1f
PACKA_M64xN16_LOOP_K16:
    PACKA_KERNEL_M64N16_K16
    subs  x23, x23, #1
    b.ne PACKA_M64xN16_LOOP_K16

1:
    cbz    x13, 2f
PACKA_M64xN16_LOOP_K1:
    PACKA_KERNEL_M64N16_K1
    subs    x13, x13, #1
    b.ne    PACKA_M64xN16_LOOP_K1       
    
2:
    //nop


//----------------STORE C-----------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr
STORE_C_START:
    psel    pn10, pn9, p4.s[w13, 0]
    psel    pn11, pn9, p4.s[w13, 1]
    psel    pn12, pn9, p4.s[w13, 2]
    psel    pn13, pn9, p4.s[w13, 3]
    mova    {z0.s-z3.s}, za0v.s[w13,0:3]
    mova    {z4.s-z7.s}, za1v.s[w13,0:3]
    mova    {z8.s-z11.s}, za2v.s[w13,0:3]
    mova    {z12.s-z15.s}, za3v.s[w13,0:3]
    
    st1w    {z0.s, z4.s, z8.s, z12.s},  pn10, [x11]               // c_ptr0 
    st1w    {z1.s, z5.s, z9.s, z13.s},  pn11, [x11, x8, lsl #2]   // c_ptr0 + ldc
    st1w    {z2.s, z6.s, z10.s, z14.s},  pn12, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    st1w    {z3.s, z7.s, z11.s, z15.s},  pn13, [x11, x15, lsl #2]   // c_ptr0 + ldc*3

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4 * ldc FP32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    STORE_C_START

//----Jump to Loop_MR-------------------------
    addvl   x16, x16, #4            // a_base += 4*SVLb (bytes)
    addvl   x20, x20, #4              // c_base += 4*SVLb
    whilelt pn9.b, x16, x21, vlx4   // tile predicate (M dimension)
    b.first LOOP_MR

//-------------------------PACKA END--------------------------------------------------



//--------------------------NR1 : NC -> FMOPA --------------------------------------------------------
    mul     x22, x12, x1              // KC * NR(SVLs)
    mul     x26, x12, x8              // SVLs * ldc

    incw    x14              // N loop counter +=  SVLs
    whilelt p4.s, x14, x2    // tiles predicate (N dimension)

LOOP_NR1:
// NUM 1 NR START
   
    //mov     x10, x4                   // packa  MCxKC

    add     x5, x5, x22, lsl #2      // packb +=  SVLs*KC
    add     x6, x6, x26, lsl #2      // c_base +=  SVLs*ldc

    
    mov     x20, x6                  // XC_ptr

    mov     x16, x4                  // packa

    mov     x21, #0
    whilelt pn9.s, x21, x0, vlx4   // tiles predicate (M dimension)

LOOP_MR_END:

    mov     x24, x5                  // packb_ptr
    mov     x10, x16                  // packa


    pext   {p0.s, p1.s}, pn9[0]      // tiles predicate (M dimension)
    pext   {p2.s, p3.s}, pn9[1]      // tiles predicate (M dimension)
    
    zero    {za}
    //cmp     x9, x7   // KC
    //b.lt    KERNEL_START

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

    mova    za0v.s[w13,0:3], {z0.s-z3.s}
    mova    za1v.s[w13,0:3], {z4.s-z7.s}
    mova    za2v.s[w13,0:3], {z8.s-z11.s}
    mova    za3v.s[w13,0:3], {z12.s-z15.s}

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes
    add     w13, w13, #4

    psel    pn10, pn9, p4.s[w13, 0]
    psel    pn11, pn9, p4.s[w13, 1]
    psel    pn12, pn9, p4.s[w13, 2]
    psel    pn13, pn9, p4.s[w13, 3]
    ld1w    {z16.s, z20.s, z24.s, z28.s}, pn10/z, [x11]               // c_ptr0
    ld1w    {z17.s, z21.s, z25.s, z29.s}, pn11/z, [x11, x8, lsl #2]   // c_ptr0 + ldc
    ld1w    {z18.s, z22.s, z26.s, z30.s}, pn12/z, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    ld1w    {z19.s, z23.s, z27.s, z31.s}, pn13/z, [x11, x15, lsl #2]  // c_ptr0 + ldc*3

    mova    za0v.s[w13,0:3], {z16.s-z19.s}
    mova    za1v.s[w13,0:3], {z20.s-z23.s}
    mova    za2v.s[w13,0:3], {z24.s-z27.s}
    mova    za3v.s[w13,0:3], {z28.s-z31.s}

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    LOAD_C_END

//-------------------------------------------------------------------  
KERNEL_START:

    ptrue   pn10.b

    lsr x23, x1, #4                 // KC/16
    and x13, x1, #0xF               // KC % 16

    cbz  x23, 3f
KERNEL_M64xN16_LOOP_K16:
    KERNEL_M64N16_K16
    add x10, x10, #2048 // 64*16*4 / 2  packa
    add x24, x24, #1024 //16*SVLb    packb
    subs x23, x23, #1
    b.ne KERNEL_M64xN16_LOOP_K16

3:
    cbz  x13, 4f
KERNEL_M64xN16_LOOP_K1:
    KERNEL_M64N16_K1
    subs  x13, x13, #1
    b.ne  KERNEL_M64xN16_LOOP_K1
    
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
    mova    {z0.s-z3.s}, za0v.s[w13,0:3]
    mova    {z4.s-z7.s}, za1v.s[w13,0:3]
    mova    {z8.s-z11.s}, za2v.s[w13,0:3]
    mova    {z12.s-z15.s}, za3v.s[w13,0:3]
    
    st1w    {z0.s, z4.s, z8.s, z12.s},  pn10, [x11]               // c_ptr0 
    st1w    {z1.s, z5.s, z9.s, z13.s},  pn11, [x11, x8, lsl #2]   // c_ptr0 + ldc
    st1w    {z2.s, z6.s, z10.s, z14.s},  pn12, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    st1w    {z3.s, z7.s, z11.s, z15.s},  pn13, [x11, x15, lsl #2]   // c_ptr0 + ldc*3

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4 * ldc FP32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    STORE_C_END


//--------Jump to LOOP_MR_END-----------------------

    add     x16, x16, x22, lsl #4             // packas += 4*SVLs * KC (bytes)
    addvl   x20, x20, #4              // c_base += 4*SVLb

    add     x21, x21, #64           // M loop counter += 4 * SVLs
    whilelt pn9.s, x21, x0, vlx4   // tile predicate (M dimension)
    b.first LOOP_MR_END

  

//----Jump to LOOP_NR1-----------------------
    incw    x14        // N loop counter += SVLs
    whilelt p4.s, x14, x2   // tiles predicate (N dimension)
    b.first LOOP_NR1



    smstop



    ldp     x25, x26, [sp, #48]
    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #64
    

    ret