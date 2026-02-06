    .text 
    .global _row_kernel_16x64
    .align  4

.macro PACKB_KERNEL_M16N64_K1
    ld1w    {z0.s-z3.s}, pn9/z, [x19]       //b_ptr
    ld1w    {z4.s}, p4/z, [x24]       //packa

    fmopa   za0.s, p4/m, p0/m, z4.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z4.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z4.s, z2.s
    fmopa   za3.s, p4/m, p3/m, z4.s, z3.s

    st1w    {z0.s-z3.s}, pn9, [x10]        //packb

    add     x19, x19, x8, lsl #2    // b_ptr+= ldb
    addvl   x24, x24, #1            // packa += SVLb
    addvl   x10, x10, #4            // packb += 4*SVLb (bytes)

.endm


.macro PACKB_KERNEL_M16N64_K16
    // K = 8
    ld1w    {z0.s-z3.s}, pn9/z, [x19]       //1 b_ptr
    ld1w    {z4.s-z7.s}, pn10/z, [x24]       //4 packa

    add     x19, x19, x8, lsl #2            //b_ptr+= ldb
    ld1w    {z8.s-z11.s}, pn9/z, [x19]      //2 b_ptr
    fmopa   za0.s, p4/m, p0/m, z4.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z4.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z4.s, z2.s
    fmopa   za3.s, p4/m, p3/m, z4.s, z3.s

    st1w    {z0.s-z3.s}, pn9, [x10]         //1 packb
    
    add     x19, x19, x8, lsl #2            
    ld1w    {z12.s-z15.s}, pn9/z, [x19]      //3 b_ptr
    fmopa   za0.s, p4/m, p0/m, z5.s, z8.s
    fmopa   za1.s, p4/m, p1/m, z5.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z5.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z5.s, z11.s

    st1w    {z8.s-z11.s}, pn9, [x10, #4, MUL VL]   //2 packb
    
   
    add     x19, x19, x8, lsl #2          
    ld1w    {z16.s-z19.s}, pn9/z, [x19]      //4 b_ptr
    fmopa   za0.s, p4/m, p0/m, z6.s, z12.s
    fmopa   za1.s, p4/m, p1/m, z6.s, z13.s
    fmopa   za2.s, p4/m, p2/m, z6.s, z14.s
    fmopa   za3.s, p4/m, p3/m, z6.s, z15.s

    st1w    {z12.s-z15.s}, pn9, [x10, #8, MUL VL]       //3 packb
   
    add     x19, x19, x8, lsl #2      
    ld1w    {z24.s-z27.s}, pn10/z, [x24, #4, MUL VL]       //8 packa      
    ld1w    {z20.s-z23.s}, pn9/z, [x19]      //5 b_ptr
    fmopa   za0.s, p4/m, p0/m, z7.s, z16.s
    fmopa   za1.s, p4/m, p1/m, z7.s, z17.s
    fmopa   za2.s, p4/m, p2/m, z7.s, z18.s
    fmopa   za3.s, p4/m, p3/m, z7.s, z19.s

    st1w    {z16.s-z19.s}, pn9, [x10, #12, MUL VL]      //4 packb
    
    add     x19, x19, x8, lsl #2            
    ld1w    {z28.s-z31.s}, pn9/z, [x19]      //6 b_ptr
    fmopa   za0.s, p4/m, p0/m, z24.s, z20.s
    fmopa   za1.s, p4/m, p1/m, z24.s, z21.s
    fmopa   za2.s, p4/m, p2/m, z24.s, z22.s
    fmopa   za3.s, p4/m, p3/m, z24.s, z23.s

    st1w    {z20.s-z23.s}, pn9, [x10, #16, MUL VL]      //5 packb
    
    add     x19, x19, x8, lsl #2            
    ld1w    {z0.s-z3.s}, pn9/z, [x19]      //7 b_ptr
    fmopa   za0.s, p4/m, p0/m, z25.s, z28.s
    fmopa   za1.s, p4/m, p1/m, z25.s, z29.s
    fmopa   za2.s, p4/m, p2/m, z25.s, z30.s
    fmopa   za3.s, p4/m, p3/m, z25.s, z31.s

    st1w    {z28.s-z31.s}, pn9, [x10, #20, MUL VL]      //6 packb
   
    add     x19, x19, x8, lsl #2            
    ld1w    {z4.s-z7.s}, pn9/z, [x19]      //8 b_ptr
    fmopa   za0.s, p4/m, p0/m, z26.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z26.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z26.s, z2.s
    fmopa   za3.s, p4/m, p3/m, z26.s, z3.s

    st1w    {z0.s-z3.s}, pn9, [x10, #24, MUL VL]      //7 packb
    
    add     x19, x19, x8, lsl #2  
    ld1w    {z12.s-z15.s}, pn10/z, [x24, #8, MUL VL]       //12 packa          
    ld1w    {z8.s-z11.s}, pn9/z, [x19]      //9 b_ptr
    fmopa   za0.s, p4/m, p0/m, z27.s, z4.s
    fmopa   za1.s, p4/m, p1/m, z27.s, z5.s
    fmopa   za2.s, p4/m, p2/m, z27.s, z6.s
    fmopa   za3.s, p4/m, p3/m, z27.s, z7.s
 
//----------------------------------------------------------------------
    st1w    {z4.s-z7.s}, pn9, [x10, #28, MUL VL]      //8 packb

    add     x19, x19, x8, lsl #2  
    ld1w    {z16.s-z19.s}, pn9/z, [x19]      //10 b_ptr
    fmopa   za0.s, p4/m, p0/m, z12.s, z8.s
    fmopa   za1.s, p4/m, p1/m, z12.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z12.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z12.s, z11.s

         
    add     x10, x10, #2048         //packb += 4 * 8 * SVLb    
    st1w    {z8.s-z11.s}, pn9, [x10]         //9 packb

    add     x19, x19, x8, lsl #2            
    ld1w    {z20.s-z23.s}, pn9/z, [x19]      //11 b_ptr
    fmopa   za0.s, p4/m, p0/m, z13.s, z16.s
    fmopa   za1.s, p4/m, p1/m, z13.s, z17.s
    fmopa   za2.s, p4/m, p2/m, z13.s, z18.s
    fmopa   za3.s, p4/m, p3/m, z13.s, z19.s

    st1w    {z16.s-z19.s}, pn9, [x10, #4, MUL VL]      //10 packb
   
    add     x19, x19, x8, lsl #2            
    ld1w    {z24.s-z27.s}, pn9/z, [x19]      //12 b_ptr
    fmopa   za0.s, p4/m, p0/m, z14.s, z20.s
    fmopa   za1.s, p4/m, p1/m, z14.s, z21.s
    fmopa   za2.s, p4/m, p2/m, z14.s, z22.s
    fmopa   za3.s, p4/m, p3/m, z14.s, z23.s

    st1w    {z20.s-z23.s}, pn9, [x10, #8, MUL VL]      //11 packb
   
    add     x19, x19, x8, lsl #2        
    ld1w    {z0.s-z3.s}, pn10/z, [x24, #12, MUL VL]       //16 packa 
    ld1w    {z28.s-z31.s}, pn9/z, [x19]      //13 b_ptr
    fmopa   za0.s, p4/m, p0/m, z15.s, z24.s
    fmopa   za1.s, p4/m, p1/m, z15.s, z25.s
    fmopa   za2.s, p4/m, p2/m, z15.s, z26.s
    fmopa   za3.s, p4/m, p3/m, z15.s, z27.s

    st1w    {z24.s-z27.s}, pn9, [x10, #12, MUL VL]      //12 packb
   
    add     x19, x19, x8, lsl #2
    ld1w    {z4.s-z7.s}, pn9/z, [x19]      //14 b_ptr
    fmopa   za0.s, p4/m, p0/m, z0.s, z28.s
    fmopa   za1.s, p4/m, p1/m, z0.s, z29.s
    fmopa   za2.s, p4/m, p2/m, z0.s, z30.s
    fmopa   za3.s, p4/m, p3/m, z0.s, z31.s

    st1w    {z28.s-z31.s}, pn9, [x10, #16, MUL VL]      //13 packb
    
    add     x19, x19, x8, lsl #2
    ld1w    {z8.s-z11.s}, pn9/z, [x19]      //15 b_ptr
    fmopa   za0.s, p4/m, p0/m, z1.s, z4.s
    fmopa   za1.s, p4/m, p1/m, z1.s, z5.s  
    fmopa   za2.s, p4/m, p2/m, z1.s, z6.s
    fmopa   za3.s, p4/m, p3/m, z1.s, z7.s

    st1w    {z4.s-z7.s}, pn9, [x10, #20, MUL VL]      //14 packb
   
    add     x19, x19, x8, lsl #2
    ld1w    {z12.s-z15.s}, pn9/z, [x19]      //16 b_ptr
    fmopa   za0.s, p4/m, p0/m, z2.s, z8.s  
    fmopa   za1.s, p4/m, p1/m, z2.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z2.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z2.s, z11.s

    st1w    {z8.s-z11.s}, pn9, [x10, #24, MUL VL]      //15 packb
    
    fmopa   za0.s, p4/m, p0/m, z3.s, z12.s
    fmopa   za1.s, p4/m, p1/m, z3.s, z13.s
    fmopa   za2.s, p4/m, p2/m, z3.s, z14.s
    fmopa   za3.s, p4/m, p3/m, z3.s, z15.s

    st1w    {z12.s-z15.s}, pn9, [x10, #28, MUL VL]      //16 packb
    add     x19, x19, x8, lsl #2            //b_ptr+= ldb
    add     x24, x24, #1024         //packa += 16 * SVLb
    add     x10, x10, #2048         //packb += 4 * 8 * SVLb (bytes)
.endm


.macro KERNEL_M16N64_K1
    ld1w    {z0.s-z3.s}, pn9/z,   [x10]    //packb b_ptr
    ld1w    {z4.s}, p4/z,   [x24]    //packa 

    fmopa   za0.s, p4/m, p0/m, z4.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z4.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z4.s, z2.s
    fmopa   za3.s, p4/m, p3/m, z4.s, z3.s
    addvl x10, x10, #4                     // packb += 4*svls
    addvl x24, x24, #1                     // packa += 1*svls 
.endm 


.macro KERNEL_M16N64_K16    
    //---------------
    // K = 16
    ld1w    {z0.s-z3.s}, pn9/z,   [x10]    //1 b_ptr
    ld1w    {z4.s-z7.s}, pn10/z,   [x24]    //4 a_ptr  
    ld1w    {z8.s-z11.s}, pn9/z,   [x10, #4, MUL VL]    //2 b_ptr
    fmopa   za0.s, p4/m, p0/m, z4.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z4.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z4.s, z2.s
    fmopa   za3.s, p4/m, p3/m, z4.s, z3.s

    ld1w    {z12.s-z15.s}, pn9/z,   [x10, #8, MUL VL]    //3 b_ptr
    fmopa   za0.s, p4/m, p0/m, z5.s, z8.s
    fmopa   za1.s, p4/m, p1/m, z5.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z5.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z5.s, z11.s

    ld1w    {z16.s-z19.s}, pn9/z,   [x10, #12, MUL VL]    //4 b_ptr
    fmopa   za0.s, p4/m, p0/m, z6.s, z12.s
    fmopa   za1.s, p4/m, p1/m, z6.s, z13.s
    fmopa   za2.s, p4/m, p2/m, z6.s, z14.s
    fmopa   za3.s, p4/m, p3/m, z6.s, z15.s

    ld1w    {z20.s-z23.s}, pn9/z,   [x10, #16, MUL VL]    //5 b_ptr
    ld1w    {z24.s-z27.s}, pn10/z,   [x24, #4, MUL VL]    //8 a_ptr
    fmopa   za0.s, p4/m, p0/m, z7.s, z16.s
    fmopa   za1.s, p4/m, p1/m, z7.s, z17.s
    fmopa   za2.s, p4/m, p2/m, z7.s, z18.s
    fmopa   za3.s, p4/m, p3/m, z7.s, z19.s

    ld1w    {z28.s-z31.s}, pn9/z,   [x10, #20, MUL VL]    //6 b_ptr
    fmopa   za0.s, p4/m, p0/m, z24.s, z20.s
    fmopa   za1.s, p4/m, p1/m, z24.s, z21.s
    fmopa   za2.s, p4/m, p2/m, z24.s, z22.s
    fmopa   za3.s, p4/m, p3/m, z24.s, z23.s

    ld1w    {z0.s-z3.s}, pn9/z,   [x10, #24, MUL VL]    //7 b_ptr
    fmopa   za0.s, p4/m, p0/m, z25.s, z28.s
    fmopa   za1.s, p4/m, p1/m, z25.s, z29.s
    fmopa   za2.s, p4/m, p2/m, z25.s, z30.s
    fmopa   za3.s, p4/m, p3/m, z25.s, z31.s

    ld1w    {z4.s-z7.s}, pn9/z,   [x10, #28, MUL VL]    //8 b_ptr
    fmopa   za0.s, p4/m, p0/m, z26.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z26.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z26.s, z2.s
    fmopa   za3.s, p4/m, p3/m, z26.s, z3.s

    add   x10, x10, #2048  // NR 4 * SVLs * 8 fp32 bytes

    ld1w    {z8.s-z11.s}, pn9/z,   [x10]    //9 b_ptr
    ld1w    {z12.s-z15.s}, pn10/z,  [x24, #8, MUL VL]  //12 a_ptr
    fmopa   za0.s, p4/m, p0/m, z27.s, z4.s
    fmopa   za1.s, p4/m, p1/m, z27.s, z5.s
    fmopa   za2.s, p4/m, p2/m, z27.s, z6.s
    fmopa   za3.s, p4/m, p3/m, z27.s, z7.s

//--------------------------------------------------------------------
    ld1w    {z16.s-z19.s}, pn9/z,   [x10, #4, MUL VL]    //10 b_ptr
    fmopa   za0.s, p4/m, p0/m, z12.s, z8.s
    fmopa   za1.s, p4/m, p1/m, z12.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z12.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z12.s, z11.s

    ld1w    {z20.s-z23.s}, pn9/z,   [x10, #8, MUL VL]    //11 b_ptr
    fmopa   za0.s, p4/m, p0/m, z13.s, z16.s
    fmopa   za1.s, p4/m, p1/m, z13.s, z17.s
    fmopa   za2.s, p4/m, p2/m, z13.s, z18.s
    fmopa   za3.s, p4/m, p3/m, z13.s, z19.s

    ld1w    {z24.s-z27.s}, pn9/z,   [x10, #12, MUL VL]    //12 b_ptr
    fmopa   za0.s, p4/m, p0/m, z14.s, z20.s
    fmopa   za1.s, p4/m, p1/m, z14.s, z21.s
    fmopa   za2.s, p4/m, p2/m, z14.s, z22.s
    fmopa   za3.s, p4/m, p3/m, z14.s, z23.s

    ld1w    {z28.s-z31.s}, pn9/z,   [x10, #16, MUL VL]    //13 b_ptr
    ld1w    {z0.s-z3.s}, pn10/z,  [x24, #12, MUL VL]  //16 a_ptr
    fmopa   za0.s, p4/m, p0/m, z15.s, z24.s
    fmopa   za1.s, p4/m, p1/m, z15.s, z25.s
    fmopa   za2.s, p4/m, p2/m, z15.s, z26.s
    fmopa   za3.s, p4/m, p3/m, z15.s, z27.s

    ld1w    {z4.s-z7.s}, pn9/z,   [x10, #20, MUL VL]    //14 b_ptr
    fmopa   za0.s, p4/m, p0/m, z0.s, z28.s
    fmopa   za1.s, p4/m, p1/m, z0.s, z29.s
    fmopa   za2.s, p4/m, p2/m, z0.s, z30.s
    fmopa   za3.s, p4/m, p3/m, z0.s, z31.s

    ld1w    {z8.s-z11.s}, pn9/z,   [x10, #24, MUL VL]    //15 b_ptr
    fmopa   za0.s, p4/m, p0/m, z1.s, z4.s
    fmopa   za1.s, p4/m, p1/m, z1.s, z5.s
    fmopa   za2.s, p4/m, p2/m, z1.s, z6.s
    fmopa   za3.s, p4/m, p3/m, z1.s, z7.s

    ld1w    {z12.s-z15.s}, pn9/z,   [x10, #28, MUL VL]    //16 b_ptr
    fmopa   za0.s, p4/m, p0/m, z2.s, z8.s
    fmopa   za1.s, p4/m, p1/m, z2.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z2.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z2.s, z11.s

   
    fmopa   za0.s, p4/m, p0/m, z3.s, z12.s
    fmopa   za1.s, p4/m, p1/m, z3.s, z13.s
    fmopa   za2.s, p4/m, p2/m, z3.s, z14.s
    fmopa   za3.s, p4/m, p3/m, z3.s, z15.s

    add x10, x10, #2048 // packb

    add x24, x24, #1024 //16*SVLb fp32  packa

.endm


_row_kernel_16x64:
//x0:mc, x1:kc, x2:nc, x3: XB, x4: packa, x5: packb, x6:c, x7:KC, x8:ldc, x9:pc

    ldr     w8,  [sp]        // ldc = ldb = n
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
    add     x15, x25, x8  // ldc * 3

    mov x14, #0
    whilelt p4.s, x14, x0           // tiles predicate (M dimension)


    add    x21, x3, x2, lsl #2     // Exit condition for N loop
    mov    x16, x3                  // b_base
    whilelt pn9.b, x16, x21, vlx4   // tiles predicate (N dimension)

//--------------------NR : NC LOOP -> PACKB + FMOPA ------------------------------------
    mov x10, x5                      // packb

LOOP_NR:

    pext   {p0.b, p1.b}, pn9[0]      // tiles predicate (N dimension)
    pext   {p2.b, p3.b}, pn9[1]      // tiles predicate (N dimension)

    zero {za}

    cmp     x9, x7
    b.lt    PACKB_KERNEL

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

    mova    za0h.s[w13,0:3], {z0.s-z3.s}
    mova    za1h.s[w13,0:3], {z4.s-z7.s}
    mova    za2h.s[w13,0:3], {z8.s-z11.s}
    mova    za3h.s[w13,0:3], {z12.s-z15.s}

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes
    add     w13, w13, #4

    cmp     w13, w12
    b.mi    LOAD_C_START


//-------------------------------------------------------------------    
PACKB_KERNEL:
    mov x19, x16                     // b_ptr = b_base
    
    mov x24, x4                     // packa

    ptrue pn10.b

//---------------------KC LOOP PACKB------------------------------------------------
    lsr x23, x1, #4                 // KC/16
    and x13, x1, #0xF               // KC % 16
    
    cbz     x23, 1f
PACKB_M16xN64_LOOP_K16:
    PACKB_KERNEL_M16N64_K16
    subs  x23, x23, #1
    b.ne PACKB_M16xN64_LOOP_K16

1:
    cbz    x13, 2f
PACKB_M16xN64_LOOP_K1:
    PACKB_KERNEL_M16N64_K1
    subs    x13, x13, #1
    b.ne    PACKB_M16xN64_LOOP_K1       
    
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

    cmp     w13, w12
    b.mi    STORE_C_START


//----Jump to Loop_NR-------------------------
    addvl   x16, x16, #4            // b_base += 4*SVLb (bytes)
    addvl   x20, x20, #4            // c_base += 4*SVLb
    whilelt pn9.b, x16, x21, vlx4   // tile predicate (N dimension)
    b.first LOOP_NR

//-------------------------PACKB END--------------------------------------------------



//--------------------------MR1 : MC -> FMOPA --------------------------------------------------------
    mul     x22, x12, x1              // KC * MR(SVLs)
    mul     x26, x12, x8              // SVLs * ldc

    incw    x14              // M loop counter +=  SVLs
    whilelt p4.s, x14, x0    // tiles predicate (M dimension)

LOOP_MR1:
// NUM 1 MR START

    add     x4, x4, x22, lsl #2      // packa +=  SVLs*KC
    add     x6, x6, x26, lsl #2      // c_base +=  SVLs*ldc

    
    mov     x20, x6                  // XC_ptr

    mov     x16, x5                  // packb

    mov     x21, #0
    whilelt pn9.s, x21, x2, vlx4   // tiles predicate (N dimension)

LOOP_NR_END:

    mov     x24, x4                  // packa_ptr
    mov     x10, x16                  // packb


    pext   {p0.s, p1.s}, pn9[0]      // tiles predicate (N dimension)
    pext   {p2.s, p3.s}, pn9[1]      // tiles predicate (N dimension)
    
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

    lsr x23, x1, #4                 // KC/16
    and x13, x1, #0xF               // KC % 16

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

    cmp     w13, w12
    b.mi    STORE_C_END

//--------Jump to LOOP_NR_END-----------------------

    add     x16, x16, x22, lsl #4             // packb += 4 * SVLs * KC (bytes)
    addvl   x20, x20, #4              // c_base += 4*SVLb

    add     x21, x21, #64           // N loop counter += 4 * SVLs
    whilelt pn9.s, x21, x2, vlx4   // tile predicate (N dimension)
    b.first LOOP_NR_END

  

//----Jump to LOOP_MR1-----------------------
    incw    x14        // M loop counter += SVLs
    whilelt p4.s, x14, x0   // tiles predicate (M dimension)
    b.first LOOP_MR1



    smstop



    ldp     x25, x26, [sp, #48]
    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #64
    

    ret