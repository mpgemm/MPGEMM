    .text 
    .global _col_kernel_16x64
    .align  4

.macro PACKA_KERNEL_M16N64_K1
    ld1w    {z0.s}, p4/z, [x19]       //a_ptr
    ld1w    {z1.s}, p0/z, [x24]       //packb
    ld1w    {z2.s}, p1/z, [x24, x28, lsl #2]       //packb + SVLs * KC * 4
    ld1w    {z3.s}, p2/z, [x24, x29, lsl #2]       //packb + SVLs * KC * 2 * 4
    ld1w    {z4.s}, p3/z, [x24, x30, lsl #2]       //packb + SVLs * KC * 3 * 4

    fmopa   za0.s, p4/m, p0/m, z0.s, z1.s
    fmopa   za1.s, p4/m, p1/m, z0.s, z2.s
    fmopa   za2.s, p4/m, p2/m, z0.s, z3.s
    fmopa   za3.s, p4/m, p3/m, z0.s, z4.s

    st1w    {z0.s}, p4, [x10]        //packa

    add     x19, x19, x8, lsl #2    // a_ptr+= lda
    addvl   x24, x24, #1            // packb += SVLb
    addvl   x10, x10, #1            // packa += SVLb (bytes)

.endm


.macro PACKA_KERNEL_M16N64_K16
    // K = 8
    ld1w    {z20.s}, p4/z, [x19]       //1 a_ptr
    ld1w    {z0.s-z3.s}, pn10/z, [x24]       //4-1 packb
    fmopa   za0.s, p4/m, p0/m, z20.s, z0.s

    ld1w    {z4.s-z7.s}, pn10/z, [x24, x28, lsl #2]       //4-2 packb = x24 + SVLs * KC * 4
    fmopa   za1.s, p4/m, p1/m, z20.s, z4.s

    ld1w    {z8.s-z11.s}, pn10/z, [x24, x29, lsl #2]       //4-3 packb = x24 + SVLs * KC * 2 * 4
    fmopa   za2.s, p4/m, p2/m, z20.s, z8.s

    ld1w    {z12.s-z15.s}, pn10/z, [x24, x30, lsl #2]       //4-4 packb = x24 + SVLs * KC * 3 * 4
    fmopa   za3.s, p4/m, p3/m, z20.s, z12.s

    st1w    {z20.s}, p4, [x10]              //1 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z21.s}, p4/z, [x19]            //2 a_ptr

    fmopa   za0.s, p4/m, p0/m, z21.s, z1.s
    fmopa   za1.s, p4/m, p1/m, z21.s, z5.s
    fmopa   za2.s, p4/m, p2/m, z21.s, z9.s
    fmopa   za3.s, p4/m, p3/m, z21.s, z13.s

    addvl   x24, x24, #4            // packb += 4 * SVLb
    ld1w    {z0.s, z4.s, z8.s, z12.s}, pn10/z, [x24]       //8-1 packb

    st1w    {z21.s}, p4, [x10, #1, MUL VL]   //2 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z22.s}, p4/z, [x19]            //3 a_ptr

    fmopa   za0.s, p4/m, p0/m, z22.s, z2.s
    fmopa   za1.s, p4/m, p1/m, z22.s, z6.s
    fmopa   za2.s, p4/m, p2/m, z22.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z22.s, z14.s

    ld1w    {z1.s, z5.s, z9.s, z13.s}, pn10/z, [x24, x28, lsl #2]       //8-2 packb
    st1w    {z22.s}, p4, [x10, #2, MUL VL]   //3 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z23.s}, p4/z, [x19]            //4 a_ptr

    fmopa   za0.s, p4/m, p0/m, z23.s, z3.s
    fmopa   za1.s, p4/m, p1/m, z23.s, z7.s
    fmopa   za2.s, p4/m, p2/m, z23.s, z11.s
    fmopa   za3.s, p4/m, p3/m, z23.s, z15.s

//----------- 4 ----------

    ld1w    {z2.s, z6.s, z10.s, z14.s}, pn10/z, [x24, x29, lsl #2]       //8-3 packb
    
    st1w    {z23.s}, p4, [x10, #3, MUL VL]   //4 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z24.s}, p4/z, [x19]            //5 a_ptr

    ld1w    {z3.s, z7.s, z11.s, z15.s}, pn10/z, [x24, x30, lsl #2]       //8-4 packb

    fmopa   za0.s, p4/m, p0/m, z24.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z24.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z24.s, z2.s
    fmopa   za3.s, p4/m, p3/m, z24.s, z3.s

    st1w    {z24.s}, p4, [x10, #4, MUL VL]   //5 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z25.s}, p4/z, [x19]            //6 a_ptr

    fmopa   za0.s, p4/m, p0/m, z25.s, z4.s
    fmopa   za1.s, p4/m, p1/m, z25.s, z5.s
    fmopa   za2.s, p4/m, p2/m, z25.s, z6.s
    fmopa   za3.s, p4/m, p3/m, z25.s, z7.s

    addvl   x24, x24, #4            // packb += 4 * SVLb
    ld1w    {z0.s-z3.s}, pn10/z, [x24]  //12-1

    st1w    {z25.s}, p4, [x10, #5, MUL VL]   //6 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z26.s}, p4/z, [x19]            //7 a_ptr

    fmopa   za0.s, p4/m, p0/m, z26.s, z8.s
    fmopa   za1.s, p4/m, p1/m, z26.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z26.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z26.s, z11.s

    ld1w    {z4.s-z7.s}, pn10/z, [x24, x28, lsl #2]  //12-2

    st1w    {z26.s}, p4, [x10, #6, MUL VL]   //7 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z27.s}, p4/z, [x19]            //8 a_ptr
    fmopa   za0.s, p4/m, p0/m, z27.s, z12.s
    fmopa   za1.s, p4/m, p1/m, z27.s, z13.s
    fmopa   za2.s, p4/m, p2/m, z27.s, z14.s
    fmopa   za3.s, p4/m, p3/m, z27.s, z15.s

    ld1w    {z8.s-z11.s}, pn10/z, [x24, x29, lsl #2]  //12-3

    st1w    {z27.s}, p4, [x10, #7, MUL VL]   //8 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    
//----------- 8 ----------
    ld1w    {z28.s}, p4/z, [x19]            //9 a_ptr

    ld1w    {z12.s-z15.s}, pn10/z, [x24, x30, lsl #2]  //12-4
    fmopa   za0.s, p4/m, p0/m, z28.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z28.s, z4.s
    fmopa   za2.s, p4/m, p2/m, z28.s, z8.s
    fmopa   za3.s, p4/m, p3/m, z28.s, z12.s

    add     x10, x10, #512          //packa +=  8 * SVLb (16 * 4)(bytes)
    st1w    {z28.s}, p4, [x10]      //9 packa
    
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z29.s}, p4/z, [x19]            //10 a_ptr

    fmopa   za0.s, p4/m, p0/m, z29.s, z1.s
    fmopa   za1.s, p4/m, p1/m, z29.s, z5.s
    fmopa   za2.s, p4/m, p2/m, z29.s, z9.s
    fmopa   za3.s, p4/m, p3/m, z29.s, z13.s

    addvl   x24, x24, #4            // packb += 4 * SVLb
    ld1w    {z0.s, z4.s, z8.s, z12.s}, pn10/z, [x24]  //16-1 packb

    st1w    {z29.s}, p4, [x10, #1, MUL VL]   //10 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z30.s}, p4/z, [x19]            //11 a_ptr

    fmopa   za0.s, p4/m, p0/m, z30.s, z2.s
    fmopa   za1.s, p4/m, p1/m, z30.s, z6.s
    fmopa   za2.s, p4/m, p2/m, z30.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z30.s, z14.s

    ld1w    {z1.s, z5.s, z9.s, z13.s}, pn10/z, [x24, x28, lsl #2]  //16-2 packb

    st1w    {z30.s}, p4, [x10, #2, MUL VL]   //11 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z16.s}, p4/z, [x19]            //12 a_ptr

    fmopa   za0.s, p4/m, p0/m, z16.s, z3.s
    fmopa   za1.s, p4/m, p1/m, z16.s, z7.s
    fmopa   za2.s, p4/m, p2/m, z16.s, z11.s
    fmopa   za3.s, p4/m, p3/m, z16.s, z15.s

    ld1w    {z2.s, z6.s, z10.s, z14.s}, pn10/z, [x24, x29, lsl #2]  //16-3 packb

    st1w    {z16.s}, p4, [x10, #3, MUL VL]   //12 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z17.s}, p4/z, [x19]            //13 a_ptr

    ld1w    {z3.s, z7.s, z11.s, z15.s}, pn10/z, [x24, x30, lsl #2]  //16-3 packb
//----------- 12 ----------
    fmopa   za0.s, p4/m, p0/m, z17.s, z0.s
    fmopa   za1.s, p4/m, p1/m, z17.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z17.s, z2.s
    fmopa   za3.s, p4/m, p3/m, z17.s, z3.s

    st1w    {z17.s}, p4, [x10, #4, MUL VL]   //13 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z18.s}, p4/z, [x19]            //14 a_ptr

    fmopa   za0.s, p4/m, p0/m, z18.s, z4.s
    fmopa   za1.s, p4/m, p1/m, z18.s, z5.s
    fmopa   za2.s, p4/m, p2/m, z18.s, z6.s
    fmopa   za3.s, p4/m, p3/m, z18.s, z7.s

    st1w    {z18.s}, p4, [x10, #5, MUL VL]   //14 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z19.s}, p4/z, [x19]            //15 a_ptr

    fmopa   za0.s, p4/m, p0/m, z19.s, z8.s
    fmopa   za1.s, p4/m, p1/m, z19.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z19.s, z10.s
    fmopa   za3.s, p4/m, p3/m, z19.s, z11.s

    st1w    {z19.s}, p4, [x10, #6, MUL VL]   //15 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    ld1w    {z20.s}, p4/z, [x19]            //16 a_ptr

    fmopa   za0.s, p4/m, p0/m, z20.s, z12.s
    fmopa   za1.s, p4/m, p1/m, z20.s, z13.s
    fmopa   za2.s, p4/m, p2/m, z20.s, z14.s
    fmopa   za3.s, p4/m, p3/m, z20.s, z15.s

    st1w    {z20.s}, p4, [x10, #7, MUL VL]   //16 packa
    add     x19, x19, x8, lsl #2            //a_ptr+= lda
    addvl   x24, x24, #4            //packb += 4 * SVLb
    add     x10, x10, #512         //packa +=  8 * SVLb (16 * 4)(bytes)
.endm


.macro KERNEL_M16N64_K1
    ld1w    {z0.s}, p4/z,   [x10]    //packa a_ptr
    ld1w    {z1.s}, p0/z,   [x24]    //packb 
    ld1w    {z2.s}, p1/z,   [x24, x28, lsl #2]       //packb + SVLs * KC * 4
    ld1w    {z3.s}, p2/z,   [x24, x29, lsl #2]       //packb + SVLs * KC * 2 * 4
    ld1w    {z4.s}, p3/z,   [x24, x30, lsl #2]       //packb + SVLs * KC * 3 * 4

    fmopa   za0.s, p4/m, p0/m, z0.s, z1.s
    fmopa   za1.s, p4/m, p1/m, z0.s, z2.s
    fmopa   za2.s, p4/m, p2/m, z0.s, z3.s
    fmopa   za3.s, p4/m, p3/m, z0.s, z4.s

    addvl x10, x10, #1      // packa += svls
    addvl x24, x24, #1      // packb += svls 
.endm 


.macro KERNEL_M16N64_K16    
    // K = 8
    ld1w    {z0.s-z3.s}, pn10/z,   [x10]    //4 a_ptr
    ld1w    {z4.s-z7.s}, pn10/z,   [x24]    //4-1 b_ptr 
    fmopa   za0.s, p4/m, p0/m, z0.s, z4.s
    fmopa   za0.s, p4/m, p0/m, z1.s, z5.s
    fmopa   za0.s, p4/m, p0/m, z2.s, z6.s
    fmopa   za0.s, p4/m, p0/m, z3.s, z7.s

    ld1w    {z8.s-z11.s}, pn10/z,   [x24, x28, lsl #2]    //4-2 bptr   packb + SVLs * KC
    fmopa   za1.s, p4/m, p1/m, z0.s, z8.s
    fmopa   za1.s, p4/m, p1/m, z1.s, z9.s
    fmopa   za1.s, p4/m, p1/m, z2.s, z10.s
    fmopa   za1.s, p4/m, p1/m, z3.s, z11.s

    ld1w    {z12.s-z15.s}, pn10/z,   [x24, x29, lsl #2]    //4-3 bptr
    fmopa   za2.s, p4/m, p2/m, z0.s, z12.s
    fmopa   za2.s, p4/m, p2/m, z1.s, z13.s
    fmopa   za2.s, p4/m, p2/m, z2.s, z14.s
    fmopa   za2.s, p4/m, p2/m, z3.s, z15.s

    ld1w    {z16.s-z19.s}, pn10/z,   [x24, x30, lsl #2]    //4-4 bptr
    fmopa   za3.s, p4/m, p3/m, z0.s, z16.s
    fmopa   za3.s, p4/m, p3/m, z1.s, z17.s
    fmopa   za3.s, p4/m, p3/m, z2.s, z18.s
    fmopa   za3.s, p4/m, p3/m, z3.s, z19.s

    addvl   x24, x24, #4        // packb += 4 * SVLb
    
    ld1w    {z20.s-z23.s}, pn10/z,   [x10, #4, MUL VL]    //8 aptr
    ld1w    {z24.s-z27.s}, pn10/z,   [x24]    //8-1 b_ptr
    fmopa   za0.s, p4/m, p0/m, z20.s, z24.s
    fmopa   za0.s, p4/m, p0/m, z21.s, z25.s
    fmopa   za0.s, p4/m, p0/m, z22.s, z26.s
    fmopa   za0.s, p4/m, p0/m, z23.s, z27.s

    ld1w    {z28.s-z31.s}, pn10/z,   [x24, x28, lsl #2]    //8-2 b_ptr
    fmopa   za1.s, p4/m, p1/m, z20.s, z28.s
    fmopa   za1.s, p4/m, p1/m, z21.s, z29.s
    fmopa   za1.s, p4/m, p1/m, z22.s, z30.s
    fmopa   za1.s, p4/m, p1/m, z23.s, z31.s

    ld1w    {z0.s-z3.s}, pn10/z,   [x24, x29, lsl #2]    //8-3 b_ptr
    fmopa   za2.s, p4/m, p2/m, z20.s, z0.s
    fmopa   za2.s, p4/m, p2/m, z21.s, z1.s
    fmopa   za2.s, p4/m, p2/m, z22.s, z2.s
    fmopa   za2.s, p4/m, p2/m, z23.s, z3.s

    ld1w    {z4.s-z7.s}, pn10/z,  [x24, x30, lsl #2]    //8-3 b_ptr
    fmopa   za3.s, p4/m, p3/m, z20.s, z4.s
    fmopa   za3.s, p4/m, p3/m, z21.s, z5.s
    fmopa   za3.s, p4/m, p3/m, z22.s, z6.s
    fmopa   za3.s, p4/m, p3/m, z23.s, z7.s

//--------------------------------------------------------------------
    addvl   x24, x24, #4   // packb += 4 * SVLb

    ld1w    {z8.s-z11.s}, pn10/z,   [x10, #8, MUL VL]    //12 a_ptr
    ld1w    {z12.s-z15.s}, pn10/z,  [x24]       //12 bptr
    fmopa   za0.s, p4/m, p0/m, z8.s, z12.s
    fmopa   za0.s, p4/m, p0/m, z9.s, z13.s
    fmopa   za0.s, p4/m, p0/m, z10.s, z14.s
    fmopa   za0.s, p4/m, p0/m, z11.s, z15.s

    ld1w    {z16.s-z19.s}, pn10/z,   [x24, x28, lsl #2] 
    fmopa   za1.s, p4/m, p1/m, z8.s, z16.s
    fmopa   za1.s, p4/m, p1/m, z9.s, z17.s
    fmopa   za1.s, p4/m, p1/m, z10.s, z18.s
    fmopa   za1.s, p4/m, p1/m, z11.s, z19.s

    ld1w    {z20.s-z23.s}, pn10/z,   [x24, x29, lsl #2]   
    fmopa   za2.s, p4/m, p2/m, z8.s, z20.s
    fmopa   za2.s, p4/m, p2/m, z9.s, z21.s
    fmopa   za2.s, p4/m, p2/m, z10.s, z22.s
    fmopa   za2.s, p4/m, p2/m, z11.s, z23.s

    ld1w    {z24.s-z27.s}, pn10/z,   [x24, x30, lsl #2]   
    fmopa   za3.s, p4/m, p3/m, z8.s, z24.s
    fmopa   za3.s, p4/m, p3/m, z9.s, z25.s
    fmopa   za3.s, p4/m, p3/m, z10.s, z26.s
    fmopa   za3.s, p4/m, p3/m, z11.s, z27.s

    addvl   x24, x24, #4   // packb += 4 * SVLb

    ld1w    {z28.s-z31.s}, pn10/z,   [x10, #12, MUL VL]    //16 a_ptr
    ld1w    {z0.s-z3.s}, pn10/z,  [x24]  //16 bptr
    fmopa   za0.s, p4/m, p0/m, z28.s, z0.s
    fmopa   za0.s, p4/m, p0/m, z29.s, z1.s
    fmopa   za0.s, p4/m, p0/m, z30.s, z2.s
    fmopa   za0.s, p4/m, p0/m, z31.s, z3.s

    ld1w    {z4.s-z7.s}, pn10/z,   [x24, x28, lsl #2]    
    fmopa   za1.s, p4/m, p1/m, z28.s, z4.s
    fmopa   za1.s, p4/m, p1/m, z29.s, z5.s
    fmopa   za1.s, p4/m, p1/m, z30.s, z6.s
    fmopa   za1.s, p4/m, p1/m, z31.s, z7.s

    ld1w    {z8.s-z11.s}, pn10/z,   [x24, x29, lsl #2]   
    fmopa   za2.s, p4/m, p2/m, z28.s, z8.s
    fmopa   za2.s, p4/m, p2/m, z29.s, z9.s
    fmopa   za2.s, p4/m, p2/m, z30.s, z10.s
    fmopa   za2.s, p4/m, p2/m, z31.s, z11.s

    ld1w    {z12.s-z15.s}, pn10/z,   [x24, x30, lsl #2]   
    fmopa   za3.s, p4/m, p3/m, z28.s, z12.s
    fmopa   za3.s, p4/m, p3/m, z29.s, z13.s
    fmopa   za3.s, p4/m, p3/m, z30.s, z14.s
    fmopa   za3.s, p4/m, p3/m, z31.s, z15.s

    add x10, x10, #1024     // 16* 16 *4  packa
    addvl  x24, x24, #4    // packb += 4 * SVLb 

.endm


_col_kernel_16x64:
//x0:mc, x1:kc, x2:nc, x3: XA, x4: packa, x5: packb, x6:c, x7:KC, x8:ldc, x9:pc

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

    mov    x20, x6                  // c_base

    lsl     x25, x8, #1   // ldc * 2
    lsl     x17, x8, #2   // ldc * 4
    add     x15, x25, x8   // ldc * 3
    mul     x27, x12, x8   // SVLs * ldc

    mov     x14, #0
    whilelt pn9.s, x14, x2, vlx4          // tiles predicate (N dimension)

    pext   {p0.s, p1.s}, pn9[0]      // tiles predicate (N dimension)
    pext   {p2.s, p3.s}, pn9[1]      // tiles predicate (N dimension)

    ptrue pn10.b

    add    x21, x3, x0, lsl #2     // Exit condition for M loop
    mov    x16, x3                  // a_base
    whilelt p4.b, x16, x21   // tiles predicate (M dimension)

//--------------------MR : MC LOOP -> PACKA + FMOPA ------------------------------------
    mov x10, x4                      // packa

LOOP_MR:

    zero {za}   // beta = 0 -> zero {zero}
    //cmp     x9, x7   // KC
    //b.lt    PACKA_KERNEL

//----------------LOAD  C---------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr
    add     x28, x20, x27, lsl  #2     // XC_ptr + SVLs * ldc * 4      
    add     x29, x20, x27, lsl  #3     // XC_ptr + SVLs * ldc * 2 * 4
    add     x30, x28, x27, lsl  #3     // XC_ptr + SVLs * ldc * 3 * 4

LOAD_C_START:
    psel    p5, p4, p0.s[w13, 0]
    psel    p6, p4, p0.s[w13, 1]
    psel    p7, p4, p0.s[w13, 2]
    ld1w    {z0.s}, p5/z, [x11]               // c_ptr0
    ld1w    {z1.s}, p6/z, [x11, x8, lsl #2]   // c_ptr0 + ldc
    ld1w    {z2.s}, p7/z, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    psel    p5, p4, p0.s[w13, 3]
    ld1w    {z3.s}, p5/z, [x11, x15, lsl #2]  // c_ptr0 + ldc*3
    mova    za0v.s[w13,0:3], {z0.s-z3.s}
    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    psel    p5, p4, p1.s[w13, 0]
    psel    p6, p4, p1.s[w13, 1]
    psel    p7, p4, p1.s[w13, 2]
    ld1w    {z4.s}, p5/z, [x28]               // c_ptr1
    ld1w    {z5.s}, p6/z, [x28, x8, lsl #2]   // c_ptr1 + ldc
    ld1w    {z6.s}, p7/z, [x28, x25, lsl #2]  // c_ptr1 + ldc*2
    psel    p5, p4, p1.s[w13, 3]
    ld1w    {z7.s}, p5/z, [x28, x15, lsl #2]  // c_ptr1 + ldc*3
    mova    za1v.s[w13,0:3], {z4.s-z7.s}
    add     x28, x28, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    psel    p5, p4, p2.s[w13, 0]
    psel    p6, p4, p2.s[w13, 1]
    psel    p7, p4, p2.s[w13, 2]
    ld1w    {z8.s}, p5/z, [x29]               // c_ptr2
    ld1w    {z9.s}, p6/z, [x29, x8, lsl #2]   // c_ptr2 + ldc
    ld1w    {z10.s}, p7/z, [x29, x25, lsl #2]  // c_ptr2 + ldc*2
    psel    p5, p4, p2.s[w13, 3]
    ld1w    {z11.s}, p5/z, [x29, x15, lsl #2]  // c_ptr2 + ldc*3
    mova    za2v.s[w13,0:3], {z8.s-z11.s}
    add     x29, x29, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    psel    p5, p4, p3.s[w13, 0]
    psel    p6, p4, p3.s[w13, 1]
    psel    p7, p4, p3.s[w13, 2]
    ld1w    {z12.s}, p5/z, [x30]               // c_ptr3
    ld1w    {z13.s}, p6/z, [x30, x8, lsl #2]   // c_ptr3 + ldc
    ld1w    {z14.s}, p7/z, [x30, x25, lsl #2]  // c_ptr3 + ldc*2
    psel    p5, p4, p3.s[w13, 3]
    ld1w    {z15.s}, p5/z, [x30, x15, lsl #2]  // c_ptr3 + ldc*3
    mova    za3v.s[w13,0:3], {z12.s-z15.s}
    add     x30, x30, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    add     w13, w13, #4

    cmp     w13, w12
    b.mi    LOAD_C_START


//-------------------------------------------------------------------    
PACKA_KERNEL:
    mov x19, x16                     // a_ptr = a_base
    
    mov x24, x5                     // packb

    mul x28, x12, x1        // SVLs * KC * 1
    lsl x29, x28, #1         // SVLs * KC * 2
    add x30, x28, x29       // SVLs * KC * 3

    

//---------------------KC LOOP PACKA------------------------------------------------
    lsr x23, x1, #4                 // KC/16
    and x13, x1, #0xF               // KC % 16
    
    cbz     x23, 1f
PACKA_M16xN64_LOOP_K16:
    PACKA_KERNEL_M16N64_K16
    subs  x23, x23, #1
    b.ne PACKA_M16xN64_LOOP_K16

1:
    cbz    x13, 2f
PACKA_M16xN64_LOOP_K1:
    PACKA_KERNEL_M16N64_K1
    subs    x13, x13, #1
    b.ne    PACKA_M16xN64_LOOP_K1       
    
2:
    //nop


//----------------STORE C-----------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr
    add     x28, x20, x27, lsl  #2     // XC_ptr + SVLs * ldc * 4      
    add     x29, x20, x27, lsl  #3     // XC_ptr + SVLs * ldc * 2 * 4
    add     x30, x28, x27, lsl  #3     // XC_ptr + SVLs * ldc * 3 * 4

STORE_C_START:

    mova    {z0.s-z3.s}, za0v.s[w13,0:3]
    mova    {z4.s-z7.s}, za1v.s[w13,0:3]
    mova    {z8.s-z11.s}, za2v.s[w13,0:3]
    mova    {z12.s-z15.s}, za3v.s[w13,0:3]
    psel    p5, p4, p0.s[w13, 0]
    psel    p6, p4, p0.s[w13, 1]
    psel    p7, p4, p0.s[w13, 2]
    st1w    {z0.s},  p5, [x11]               // c_ptr0 
    st1w    {z1.s},  p6, [x11, x8, lsl #2]   // c_ptr0 + ldc
    st1w    {z2.s},  p7, [x11, x25, lsl #2]   // c_ptr0 + ldc * 2
    psel    p5, p4, p0.s[w13, 3]
    st1w    {z3.s},  p5, [x11, x15, lsl #2]   // c_ptr0 + ldc * 3

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    psel    p5, p4, p1.s[w13, 0]
    psel    p6, p4, p1.s[w13, 1]
    psel    p7, p4, p1.s[w13, 2]
    st1w    {z4.s},  p5, [x28]               // c_ptr1
    st1w    {z5.s},  p6, [x28, x8, lsl #2]   // c_ptr1 + ldc
    st1w    {z6.s},  p7, [x28, x25, lsl #2]   // c_ptr1 + ldc * 2
    psel    p5, p4, p1.s[w13, 3]
    st1w    {z7.s},  p5, [x28, x15, lsl #2]   // c_ptr1 + ldc * 3

    add     x28, x28, x17, lsl #2         //c_ptr1 += 4*ldc FP32 bytes

    psel    p5, p4, p2.s[w13, 0]
    psel    p6, p4, p2.s[w13, 1]
    psel    p7, p4, p2.s[w13, 2]
    st1w    {z8.s},  p5, [x29]               // c_ptr2 
    st1w    {z9.s},  p6, [x29, x8, lsl #2]   // c_ptr2 + ldc
    st1w    {z10.s},  p7, [x29, x25, lsl #2]   // c_ptr2 + ldc * 2
    psel    p5, p4, p2.s[w13, 3]
    st1w    {z11.s},  p5, [x29, x15, lsl #2]   // c_ptr2 + ldc * 3

    add     x29, x29, x17, lsl #2         //c_ptr2 += 4*ldc FP32 bytes

    psel    p5, p4, p3.s[w13, 0]
    psel    p6, p4, p3.s[w13, 1]
    psel    p7, p4, p3.s[w13, 2]
    st1w    {z12.s},  p5, [x30]               // c_ptr2 
    st1w    {z13.s},  p6, [x30, x8, lsl #2]   // c_ptr2 + ldc
    st1w    {z14.s},  p7, [x30, x25, lsl #2]   // c_ptr2 + ldc * 2
    psel    p5, p4, p3.s[w13, 3]
    st1w    {z15.s},  p5, [x30, x15, lsl #2]   // c_ptr2 + ldc * 3

    add     x30, x30, x17, lsl #2         //c_ptr2 += 4*ldc FP32 bytes

    add     w13, w13, #4
    cmp     w13, w12
    b.mi    STORE_C_START


//----Jump to Loop_MR-------------------------
    addvl   x16, x16, #1            // a_base += SVLb (bytes)
    addvl   x20, x20, #1            // c_base += SVLb
    whilelt p4.b, x16, x21   // tile predicate (M dimension)
    b.first LOOP_MR

//-------------------------PACKA END--------------------------------------------------



//--------------------------NR1 : NC -> FMOPA --------------------------------------------------------
    mul     x22, x12, x1              // KC * SVLs
    mul     x26, x12, x8              // SVLs * ldc

    incw    x14, all, mul #4        // N loop counter +=  4 * SVLs
    whilelt pn9.s, x14, x2, vlx4    // tiles predicate (N dimension)

LOOP_NR1:
// NUM 1 NR START
    
    //mov     x10, x4                   // packa  MCxKC
    pext   {p0.s, p1.s}, pn9[0]      // tiles predicate (N dimension)
    pext   {p2.s, p3.s}, pn9[1]      // tiles predicate (N dimension)
    

    //ptrue   pn10.b

    add     x5, x5, x22, lsl #4      // packb +=  4*SVLs*KC
    add     x6, x6, x26, lsl #4      // c_base +=  4*SVLs*ldc

    mov     x20, x6                  // XC_ptr

    mov     x16, x4                  // packa

    mov     x21, #0
    whilelt p4.s, x21, x0   // tiles predicate (M dimension)

LOOP_MR_END:

    mov     x24, x5                  // packb_ptr
    mov     x10, x16                  // packa
    
    zero    {za} // beta = 0 -> zero {zero}
    //cmp     x9, x7   // KC
    //b.lt    KERNEL_START
//----------------LOAD  C---------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr
    add     x28, x20, x27, lsl  #2     // XC_ptr + SVLs * ldc * 4      
    add     x29, x20, x27, lsl  #3     // XC_ptr + SVLs * ldc * 2 * 4
    add     x30, x28, x27, lsl  #3     // XC_ptr + SVLs * ldc * 3 * 4

LOAD_C_END:
    psel    p5, p4, p0.s[w13, 0]
    psel    p6, p4, p0.s[w13, 1]
    psel    p7, p4, p0.s[w13, 2]
    ld1w    {z0.s}, p5/z, [x11]               // c_ptr0
    ld1w    {z1.s}, p6/z, [x11, x8, lsl #2]   // c_ptr0 + ldc
    ld1w    {z2.s}, p7/z, [x11, x25, lsl #2]  // c_ptr0 + ldc*2
    psel    p5, p4, p0.s[w13, 3]
    ld1w    {z3.s}, p5/z, [x11, x15, lsl #2]  // c_ptr0 + ldc*3
    mova    za0v.s[w13,0:3], {z0.s-z3.s}
    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    psel    p5, p4, p1.s[w13, 0]
    psel    p6, p4, p1.s[w13, 1]
    psel    p7, p4, p1.s[w13, 2]
    ld1w    {z4.s}, p5/z, [x28]               // c_ptr1
    ld1w    {z5.s}, p6/z, [x28, x8, lsl #2]   // c_ptr1 + ldc
    ld1w    {z6.s}, p7/z, [x28, x25, lsl #2]  // c_ptr1 + ldc*2
    psel    p5, p4, p1.s[w13, 3]
    ld1w    {z7.s}, p5/z, [x28, x15, lsl #2]  // c_ptr1 + ldc*3
    mova    za1v.s[w13,0:3], {z4.s-z7.s}
    add     x28, x28, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    psel    p5, p4, p2.s[w13, 0]
    psel    p6, p4, p2.s[w13, 1]
    psel    p7, p4, p2.s[w13, 2]
    ld1w    {z8.s}, p5/z, [x29]               // c_ptr2
    ld1w    {z9.s}, p6/z, [x29, x8, lsl #2]   // c_ptr2 + ldc
    ld1w    {z10.s}, p7/z, [x29, x25, lsl #2]  // c_ptr2 + ldc*2
    psel    p5, p4, p2.s[w13, 3]
    ld1w    {z11.s}, p5/z, [x29, x15, lsl #2]  // c_ptr2 + ldc*3
    mova    za2v.s[w13,0:3], {z8.s-z11.s}
    add     x29, x29, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    psel    p5, p4, p3.s[w13, 0]
    psel    p6, p4, p3.s[w13, 1]
    psel    p7, p4, p3.s[w13, 2]
    ld1w    {z12.s}, p5/z, [x30]               // c_ptr3
    ld1w    {z13.s}, p6/z, [x30, x8, lsl #2]   // c_ptr3 + ldc
    ld1w    {z14.s}, p7/z, [x30, x25, lsl #2]  // c_ptr3 + ldc*2
    psel    p5, p4, p3.s[w13, 3]
    ld1w    {z15.s}, p5/z, [x30, x15, lsl #2]  // c_ptr3 + ldc*3
    mova    za3v.s[w13,0:3], {z12.s-z15.s}
    add     x30, x30, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    add     w13, w13, #4

    cmp     w13, w12
    b.mi    LOAD_C_END

//-------------------------------------------------------------------  
KERNEL_START:

    mul x28, x12, x1        // SVLs * KC * 1
    lsl x29, x28, #1        // SVLs * KC * 2
    add x30, x28, x29       // SVLs * KC * 3


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

//----------------STORE C END-----------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr
    add     x28, x20, x27, lsl  #2     // XC_ptr + SVLs * ldc * 4      
    add     x29, x20, x27, lsl  #3     // XC_ptr + SVLs * ldc * 2 * 4
    add     x30, x28, x27, lsl  #3     // XC_ptr + SVLs * ldc * 3 * 4

STORE_C_END:

    mova    {z0.s-z3.s}, za0v.s[w13,0:3]
    mova    {z4.s-z7.s}, za1v.s[w13,0:3]
    mova    {z8.s-z11.s}, za2v.s[w13,0:3]
    mova    {z12.s-z15.s}, za3v.s[w13,0:3]
    psel    p5, p4, p0.s[w13, 0]
    psel    p6, p4, p0.s[w13, 1]
    psel    p7, p4, p0.s[w13, 2]
    st1w    {z0.s},  p5, [x11]               // c_ptr0 
    st1w    {z1.s},  p6, [x11, x8, lsl #2]   // c_ptr0 + ldc
    st1w    {z2.s},  p7, [x11, x25, lsl #2]   // c_ptr0 + ldc * 2
    psel    p5, p4, p0.s[w13, 3]
    st1w    {z3.s},  p5, [x11, x15, lsl #2]   // c_ptr0 + ldc * 3

    add     x11, x11, x17, lsl #2         //c_ptr0 += 4*ldc FP32 bytes

    psel    p5, p4, p1.s[w13, 0]
    psel    p6, p4, p1.s[w13, 1]
    psel    p7, p4, p1.s[w13, 2]
    st1w    {z4.s},  p5, [x28]               // c_ptr1
    st1w    {z5.s},  p6, [x28, x8, lsl #2]   // c_ptr1 + ldc
    st1w    {z6.s},  p7, [x28, x25, lsl #2]   // c_ptr1 + ldc * 2
    psel    p5, p4, p1.s[w13, 3]
    st1w    {z7.s},  p5, [x28, x15, lsl #2]   // c_ptr1 + ldc * 3

    add     x28, x28, x17, lsl #2         //c_ptr1 += 4*ldc FP32 bytes

    psel    p5, p4, p2.s[w13, 0]
    psel    p6, p4, p2.s[w13, 1]
    psel    p7, p4, p2.s[w13, 2]
    st1w    {z8.s},  p5, [x29]               // c_ptr2 
    st1w    {z9.s},  p6, [x29, x8, lsl #2]   // c_ptr2 + ldc
    st1w    {z10.s},  p7, [x29, x25, lsl #2]   // c_ptr2 + ldc * 2
    psel    p5, p4, p2.s[w13, 3]
    st1w    {z11.s},  p5, [x29, x15, lsl #2]   // c_ptr2 + ldc * 3

    add     x29, x29, x17, lsl #2         //c_ptr2 += 4*ldc FP32 bytes

    psel    p5, p4, p3.s[w13, 0]
    psel    p6, p4, p3.s[w13, 1]
    psel    p7, p4, p3.s[w13, 2]
    st1w    {z12.s},  p5, [x30]               // c_ptr2 
    st1w    {z13.s},  p6, [x30, x8, lsl #2]   // c_ptr2 + ldc
    st1w    {z14.s},  p7, [x30, x25, lsl #2]   // c_ptr2 + ldc * 2
    psel    p5, p4, p3.s[w13, 3]
    st1w    {z15.s},  p5, [x30, x15, lsl #2]   // c_ptr2 + ldc * 3

    add     x30, x30, x17, lsl #2         //c_ptr2 += 4*ldc FP32 bytes

    add     w13, w13, #4
    cmp     w13, w12
    b.mi    STORE_C_END

//--------Jump to LOOP_MR_END-----------------------

    add     x16, x16, x22, lsl #2     // packas += SVLs * KC (bytes)
    addvl   x20, x20, #1              // c_base += SVLb

    add     x21, x21, #16           // M loop counter += SVLs
    whilelt p4.s, x21, x0           // tile predicate (M dimension)
    b.first LOOP_MR_END

  

//----Jump to LOOP_NR1-----------------------
    incw    x14, all, mul #4     // N loop counter +=  4 * SVLs
    whilelt pn9.s, x14, x2, vlx4   // tiles predicate (N dimension)
    b.first LOOP_NR1



    smstop

    ldp     x29, x30, [sp, #80]
    ldp     x27, x28, [sp, #64]
    ldp     x25, x26, [sp, #48]
    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #96
    

    ret