    .text 
    .global _row_dkernel_32x8
    .align  4

.macro PACKB_KERNEL_M32N8_K1
    ld1d    {z0.d}, p4/z, [x19]       //b_ptr
    ld1d    {z1.d}, p0/z, [x24]       //packa
    ld1d    {z2.d}, p1/z, [x24, x28, lsl #3]       //packa + SVLd * KC 
    ld1d    {z3.d}, p2/z, [x24, x29, lsl #3]       //packa + SVLd * KC * 2 
    ld1d    {z4.d}, p3/z, [x24, x30, lsl #3]       //packa + SVLd * KC * 3 

    fmopa   za0.d, p0/m, p4/m, z1.d, z0.d
    fmopa   za1.d, p1/m, p4/m, z2.d, z0.d
    fmopa   za2.d, p2/m, p4/m, z3.d, z0.d
    fmopa   za3.d, p3/m, p4/m, z4.d, z0.d

    st1d    {z0.d}, p4, [x10]        //packb

    add     x19, x19, x8, lsl #3    // b_ptr+= ldb
    addvl   x24, x24, #1            // packa += SVLd
    addvl   x10, x10, #1            // packb += SVLd (bytes)

.endm


.macro PACKB_KERNEL_M32N8_K16
    // K = 8
    ld1d    {z20.d}, p4/z, [x19]       //1 b_ptr
    ld1d    {z0.d-z3.d}, pn10/z, [x24]       //4-1 packa
    fmopa   za0.d, p0/m, p4/m, z0.d, z20.d

    ld1d    {z4.d-z7.d}, pn10/z, [x24, x28, lsl #3]       //4-2 packa = x24 + SVLs * KC 
    fmopa   za1.d, p1/m, p4/m, z4.d, z20.d

    ld1d    {z8.d-z11.d}, pn10/z, [x24, x29, lsl #3]       //4-3 packa = x24 + SVLs * KC * 2 
    fmopa   za2.d, p2/m, p4/m, z8.d, z20.d

    ld1d    {z12.d-z15.d}, pn10/z, [x24, x30, lsl #3]       //4-4 packa = x24 + SVLs * KC * 3 
    fmopa   za3.d, p3/m, p4/m, z12.d, z20.d

    st1d    {z20.d}, p4, [x10]              //1 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z21.d}, p4/z, [x19]            //2 b_ptr

    fmopa   za0.d, p0/m, p4/m, z1.d, z21.d
    fmopa   za1.d, p1/m, p4/m, z5.d, z21.d
    fmopa   za2.d, p2/m, p4/m, z9.d, z21.d
    fmopa   za3.d, p3/m, p4/m, z13.d, z21.d

    addvl   x24, x24, #4            // packa += 4 * SVLb
    ld1d    {z0.d, z4.d, z8.d, z12.d}, pn10/z, [x24]       //8-1 packa

    st1d    {z21.d}, p4, [x10, #1, MUL VL]   //2 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z22.d}, p4/z, [x19]            //3 b_ptr

    fmopa   za0.d, p0/m, p4/m, z2.d, z22.d
    fmopa   za1.d, p1/m, p4/m, z6.d, z22.d
    fmopa   za2.d, p2/m, p4/m, z10.d, z22.d
    fmopa   za3.d, p3/m, p4/m, z14.d, z22.d

    ld1d    {z1.d, z5.d, z9.d, z13.d}, pn10/z, [x24, x28, lsl #3]       //8-2 packa
    st1d    {z22.d}, p4, [x10, #2, MUL VL]   //3 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z23.d}, p4/z, [x19]            //4 b_ptr

    fmopa   za0.d, p0/m, p4/m, z3.d, z23.d
    fmopa   za1.d, p1/m, p4/m, z7.d, z23.d
    fmopa   za2.d, p2/m, p4/m, z11.d, z23.d
    fmopa   za3.d, p3/m, p4/m, z15.d, z23.d

//----------- 4 ----------

    ld1d    {z2.d, z6.d, z10.d, z14.d}, pn10/z, [x24, x29, lsl #3]       //8-3 packa
    
    st1d    {z23.d}, p4, [x10, #3, MUL VL]   //4 packb
    add     x19, x19, x8, lsl #3           //b_ptr+= ldb
    ld1d    {z24.d}, p4/z, [x19]            //5 b_ptr

    ld1d    {z3.d, z7.d, z11.d, z15.d}, pn10/z, [x24, x30, lsl #3]       //8-4 packa

    fmopa   za0.d, p0/m, p4/m, z0.d, z24.d
    fmopa   za1.d, p1/m, p4/m, z1.d, z24.d
    fmopa   za2.d, p2/m, p4/m, z2.d, z24.d
    fmopa   za3.d, p3/m, p4/m, z3.d, z24.d

    st1d    {z24.d}, p4, [x10, #4, MUL VL]   //5 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z25.d}, p4/z, [x19]            //6 b_ptr

    fmopa   za0.d, p0/m, p4/m, z4.d, z25.d
    fmopa   za1.d, p1/m, p4/m, z5.d, z25.d
    fmopa   za2.d, p2/m, p4/m, z6.d, z25.d
    fmopa   za3.d, p3/m, p4/m, z7.d, z25.d

    addvl   x24, x24, #4            // packa += 4 * SVLb
    ld1d    {z0.d-z3.d}, pn10/z, [x24]  //12-1

    st1d    {z25.d}, p4, [x10, #5, MUL VL]   //6 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z26.d}, p4/z, [x19]            //7 b_ptr

    fmopa   za0.d, p0/m, p4/m, z8.d, z26.d
    fmopa   za1.d, p1/m, p4/m, z9.d, z26.d
    fmopa   za2.d, p2/m, p4/m, z10.d, z26.d
    fmopa   za3.d, p3/m, p4/m, z11.d, z26.d

    ld1d    {z4.d-z7.d}, pn10/z, [x24, x28, lsl #3]  //12-2

    st1d    {z26.d}, p4, [x10, #6, MUL VL]   //7 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z27.d}, p4/z, [x19]            //8 b_ptr
    fmopa   za0.d, p0/m, p4/m, z12.d, z27.d
    fmopa   za1.d, p1/m, p4/m, z13.d, z27.d
    fmopa   za2.d, p2/m, p4/m, z14.d, z27.d
    fmopa   za3.d, p3/m, p4/m, z15.d, z27.d

    ld1d    {z8.d-z11.d}, pn10/z, [x24, x29, lsl #3]  //12-3

    st1d    {z27.d}, p4, [x10, #7, MUL VL]   //8 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    
//----------- 8 ----------
    ld1d    {z28.d}, p4/z, [x19]            //9 b_ptr

    ld1d    {z12.d-z15.d}, pn10/z, [x24, x30, lsl #3]  //12-4
    fmopa   za0.d, p0/m, p4/m, z0.d, z28.d
    fmopa   za1.d, p1/m, p4/m, z4.d, z28.d
    fmopa   za2.d, p2/m, p4/m, z8.d, z28.d
    fmopa   za3.d, p3/m, p4/m, z12.d, z28.d

    add     x10, x10, #512          //packb +=  8 * SVLd  fp64 (bytes)
    st1d    {z28.d}, p4, [x10]      //9 packb
    
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z29.d}, p4/z, [x19]            //10 b_ptr

    fmopa   za0.d, p0/m, p4/m, z1.d, z29.d
    fmopa   za1.d, p1/m, p4/m, z5.d, z29.d
    fmopa   za2.d, p2/m, p4/m, z9.d, z29.d
    fmopa   za3.d, p3/m, p4/m, z13.d, z29.d

    addvl   x24, x24, #4            // packa += 4 * SVLb
    ld1d    {z0.d, z4.d, z8.d, z12.d}, pn10/z, [x24]  //16-1 packa

    st1d    {z29.d}, p4, [x10, #1, MUL VL]   //10 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z30.d}, p4/z, [x19]            //11 b_ptr

    fmopa   za0.d, p0/m, p4/m, z2.d, z30.d
    fmopa   za1.d, p1/m, p4/m, z6.d, z30.d
    fmopa   za2.d, p2/m, p4/m, z10.d, z30.d
    fmopa   za3.d, p3/m, p4/m, z14.d, z30.d

    ld1d    {z1.d, z5.d, z9.d, z13.d}, pn10/z, [x24, x28, lsl #3]  //16-2 packa

    st1d    {z30.d}, p4, [x10, #2, MUL VL]   //11 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z16.d}, p4/z, [x19]            //12 b_ptr

    fmopa   za0.d, p0/m, p4/m, z3.d, z16.d
    fmopa   za1.d, p1/m, p4/m, z7.d, z16.d
    fmopa   za2.d, p2/m, p4/m, z11.d, z16.d
    fmopa   za3.d, p3/m, p4/m, z15.d, z16.d

    ld1d    {z2.d, z6.d, z10.d, z14.d}, pn10/z, [x24, x29, lsl #3]  //16-3 packa

    st1d    {z16.d}, p4, [x10, #3, MUL VL]   //12 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z17.d}, p4/z, [x19]            //13 b_ptr

    ld1d    {z3.d, z7.d, z11.d, z15.d}, pn10/z, [x24, x30, lsl #3]  //16-3 packa
//----------- 12 ----------
    fmopa   za0.d, p0/m, p4/m, z0.d, z17.d
    fmopa   za1.d, p1/m, p4/m, z1.d, z17.d
    fmopa   za2.d, p2/m, p4/m, z2.d, z17.d
    fmopa   za3.d, p3/m, p4/m, z3.d, z17.d

    st1d    {z17.d}, p4, [x10, #4, MUL VL]   //13 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z18.d}, p4/z, [x19]            //14 b_ptr

    fmopa   za0.d, p0/m, p4/m, z4.d, z18.d
    fmopa   za1.d, p1/m, p4/m, z5.d, z18.d
    fmopa   za2.d, p2/m, p4/m, z6.d, z18.d
    fmopa   za3.d, p3/m, p4/m, z7.d, z18.d

    st1d    {z18.d}, p4, [x10, #5, MUL VL]   //14 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z19.d}, p4/z, [x19]            //15 b_ptr

    fmopa   za0.d, p0/m, p4/m, z8.d, z19.d
    fmopa   za1.d, p1/m, p4/m, z9.d, z19.d
    fmopa   za2.d, p2/m, p4/m, z10.d, z19.d
    fmopa   za3.d, p3/m, p4/m, z11.d, z19.d

    st1d    {z19.d}, p4, [x10, #6, MUL VL]   //15 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z20.d}, p4/z, [x19]            //16 b_ptr

    fmopa   za0.d, p0/m, p4/m, z12.d, z20.d
    fmopa   za1.d, p1/m, p4/m, z13.d, z20.d
    fmopa   za2.d, p2/m, p4/m, z14.d, z20.d
    fmopa   za3.d, p3/m, p4/m, z15.d, z20.d

    st1d    {z20.d}, p4, [x10, #7, MUL VL]   //16 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    addvl   x24, x24, #4            //packa += 4 * SVLd
    add     x10, x10, #512         //packb +=  8 * SVLd fp64
.endm


.macro KERNEL_M32N8_K1
    ld1d    {z0.d}, p4/z,   [x10]    //packb b_ptr
    ld1d    {z1.d}, p0/z,   [x24]    //packa 
    ld1d    {z2.d}, p1/z,   [x24, x28, lsl #3]       //packa + SVLd * KC fp64
    ld1d    {z3.d}, p2/z,   [x24, x29, lsl #3]       //packa + SVLd * KC * 2 
    ld1d    {z4.d}, p3/z,   [x24, x30, lsl #3]       //packa + SVLd * KC * 3 

    fmopa   za0.d, p0/m, p4/m, z1.d, z0.d
    fmopa   za1.d, p1/m, p4/m, z2.d, z0.d
    fmopa   za2.d, p2/m, p4/m, z3.d, z0.d
    fmopa   za3.d, p3/m, p4/m, z4.d, z0.d

    addvl x10, x10, #1      // packb += svls
    addvl x24, x24, #1      // packa += svls 
.endm 


.macro KERNEL_M32N8_K16    
    // K = 8
    ld1d    {z0.d-z3.d}, pn10/z,   [x10]    //4 b_ptr
    ld1d    {z4.d-z7.d}, pn10/z,   [x24]    //4-1 a_ptr 
    fmopa   za0.d, p0/m, p4/m, z4.d, z0.d
    fmopa   za0.d, p0/m, p4/m, z5.d, z1.d
    fmopa   za0.d, p0/m, p4/m, z6.d, z2.d
    fmopa   za0.d, p0/m, p4/m, z7.d, z3.d

    ld1d    {z8.d-z11.d}, pn10/z,   [x24, x28, lsl #3]    //4-2 aptr   packa + SVLd * KC
    fmopa   za1.d, p1/m, p4/m, z8.d, z0.d
    fmopa   za1.d, p1/m, p4/m, z9.d, z1.d
    fmopa   za1.d, p1/m, p4/m, z10.d, z2.d
    fmopa   za1.d, p1/m, p4/m, z11.d, z3.d

    ld1d    {z12.d-z15.d}, pn10/z,   [x24, x29, lsl #3]    //4-3 aptr
    fmopa   za2.d, p2/m, p4/m, z12.d, z0.d
    fmopa   za2.d, p2/m, p4/m, z13.d, z1.d
    fmopa   za2.d, p2/m, p4/m, z14.d, z2.d
    fmopa   za2.d, p2/m, p4/m, z15.d, z3.d

    ld1d    {z16.d-z19.d}, pn10/z,   [x24, x30, lsl #3]    //4-4 aptr
    fmopa   za3.d, p3/m, p4/m, z16.d, z0.d
    fmopa   za3.d, p3/m, p4/m, z17.d, z1.d
    fmopa   za3.d, p3/m, p4/m, z18.d, z2.d
    fmopa   za3.d, p3/m, p4/m, z19.d, z3.d

    addvl   x24, x24, #4        // packa += 4 * SVLb
    
    ld1d    {z20.d-z23.d}, pn10/z,   [x10, #4, MUL VL]    //8 bptr
    ld1d    {z24.d-z27.d}, pn10/z,   [x24]    //8-1 a_ptr
    fmopa   za0.d, p0/m, p4/m, z24.d, z20.d
    fmopa   za0.d, p0/m, p4/m, z25.d, z21.d
    fmopa   za0.d, p0/m, p4/m, z26.d, z22.d
    fmopa   za0.d, p0/m, p4/m, z27.d, z23.d

    ld1d    {z28.d-z31.d}, pn10/z,   [x24, x28, lsl #3]    //8-2 a_ptr
    fmopa   za1.d, p1/m, p4/m, z28.d, z20.d
    fmopa   za1.d, p1/m, p4/m, z29.d, z21.d
    fmopa   za1.d, p1/m, p4/m, z30.d, z22.d
    fmopa   za1.d, p1/m, p4/m, z31.d, z23.d

    ld1d    {z0.d-z3.d}, pn10/z,   [x24, x29, lsl #3]    //8-3 a_ptr
    fmopa   za2.d, p2/m, p4/m, z0.d, z20.d
    fmopa   za2.d, p2/m, p4/m, z1.d, z21.d
    fmopa   za2.d, p2/m, p4/m, z2.d, z22.d
    fmopa   za2.d, p2/m, p4/m, z3.d, z23.d

    ld1d    {z4.d-z7.d}, pn10/z,  [x24, x30, lsl #3]    //8-3 a_ptr
    fmopa   za3.d, p3/m, p4/m, z4.d, z20.d
    fmopa   za3.d, p3/m, p4/m, z5.d, z21.d
    fmopa   za3.d, p3/m, p4/m, z6.d, z22.d
    fmopa   za3.d, p3/m, p4/m, z7.d, z23.d

//--------------------------------------------------------------------
    addvl   x24, x24, #4   // packa += 4 * SVLb

    ld1d    {z8.d-z11.d}, pn10/z,   [x10, #8, MUL VL]    //12 b_ptr
    ld1d    {z12.d-z15.d}, pn10/z,  [x24]       //12 aptr
    fmopa   za0.d, p0/m, p4/m, z12.d, z8.d
    fmopa   za0.d, p0/m, p4/m, z13.d, z9.d
    fmopa   za0.d, p0/m, p4/m, z14.d, z10.d
    fmopa   za0.d, p0/m, p4/m, z15.d, z11.d

    ld1d    {z16.d-z19.d}, pn10/z,   [x24, x28, lsl #3] 
    fmopa   za1.d, p1/m, p4/m, z16.d, z8.d
    fmopa   za1.d, p1/m, p4/m, z17.d, z9.d
    fmopa   za1.d, p1/m, p4/m, z18.d, z10.d
    fmopa   za1.d, p1/m, p4/m, z19.d, z11.d

    ld1d    {z20.d-z23.d}, pn10/z,   [x24, x29, lsl #3]   
    fmopa   za2.d, p2/m, p4/m, z20.d, z8.d
    fmopa   za2.d, p2/m, p4/m, z21.d, z9.d
    fmopa   za2.d, p2/m, p4/m, z22.d, z10.d
    fmopa   za2.d, p2/m, p4/m, z23.d, z11.d

    ld1d    {z24.d-z27.d}, pn10/z,   [x24, x30, lsl #3]   
    fmopa   za3.d, p3/m, p4/m, z24.d, z8.d
    fmopa   za3.d, p3/m, p4/m, z25.d, z9.d
    fmopa   za3.d, p3/m, p4/m, z26.d, z10.d
    fmopa   za3.d, p3/m, p4/m, z27.d, z11.d

    addvl   x24, x24, #4   // packa += 4 * SVLb

    ld1d    {z28.d-z31.d}, pn10/z,   [x10, #12, MUL VL]    //16 b_ptr
    ld1d    {z0.d-z3.d}, pn10/z,  [x24]  //16 aptr
    fmopa   za0.d, p0/m, p4/m, z0.d, z28.d
    fmopa   za0.d, p0/m, p4/m, z1.d, z29.d
    fmopa   za0.d, p0/m, p4/m, z2.d, z30.d
    fmopa   za0.d, p0/m, p4/m, z3.d, z31.d

    ld1d    {z4.d-z7.d}, pn10/z,   [x24, x28, lsl #3]    
    fmopa   za1.d, p1/m, p4/m, z4.d, z28.d
    fmopa   za1.d, p1/m, p4/m, z5.d, z29.d
    fmopa   za1.d, p1/m, p4/m, z6.d, z30.d
    fmopa   za1.d, p1/m, p4/m, z7.d, z31.d

    ld1d    {z8.d-z11.d}, pn10/z,   [x24, x29, lsl #3]   
    fmopa   za2.d, p2/m, p4/m, z8.d, z28.d
    fmopa   za2.d, p2/m, p4/m, z9.d, z29.d
    fmopa   za2.d, p2/m, p4/m, z10.d, z30.d
    fmopa   za2.d, p2/m, p4/m, z11.d, z31.d

    ld1d    {z12.d-z15.d}, pn10/z,   [x24, x30, lsl #3]   
    fmopa   za3.d, p3/m, p4/m, z12.d, z28.d
    fmopa   za3.d, p3/m, p4/m, z13.d, z29.d
    fmopa   za3.d, p3/m, p4/m, z14.d, z30.d
    fmopa   za3.d, p3/m, p4/m, z15.d, z31.d

    add x10, x10, #1024     // 16* 8 * 8  packb
    addvl  x24, x24, #4    // packa += 4 * SVLb 

.endm


_row_dkernel_32x8:
//x0:mc, x1:kc, x2:nc, x3: XB, x4: packa, x5: packb, x6:c, x7:KC, x8:ldc, x9:pc

    ldr     w8,  [sp]        // ldc = ldb = n
    ldr     w9,  [sp, #4]    // pc

    stp     x19, x20, [sp, #-96]!
    stp     x21, x22, [sp, #16]
    stp     x23, x24, [sp, #32]
    stp     x25, x26, [sp, #48]
    stp     x27, x28, [sp, #64]
    stp     x29, x30, [sp, #80]


    smstart


    cntd    x12                     //   SVLd -> 8

    mov     x20, x6                  // c_base

    lsl     x25, x8, #1   // ldc * 2
    add     x17, x25, x8   // ldc * 3
    mul     x27, x12, x8   // SVLd * ldc

    mov     x14, #0
    whilelt pn9.d, x14, x0, vlx4          // tiles predicate (M dimension)

    pext   {p0.d, p1.d}, pn9[0]      // tiles predicate (M dimension)
    pext   {p2.d, p3.d}, pn9[1]      // tiles predicate (M dimension)

    ptrue pn10.b

    mov     x21, #0
    whilelt p4.d, x21, x2   // tiles predicate (N dimension)
//--------------------NR : NC LOOP -> PACKB + FMOPA ------------------------------------
    mov    x10, x5                      // packb

LOOP_NR:

    zero {za}   // beta = 0 -> zero {zero}
    
    cmp     x9, x7
    b.lt    PACKB_KERNEL

//----------------LOAD  C---------------------
    mov     w13, #0
    mov     w15, #0
    mov     x11, x20      // XC_ptr
    add     x28, x20, x27, lsl  #3     // XC_ptr + SVLs * ldc  fp64      
    add     x29, x20, x27, lsl  #4     // XC_ptr + SVLs * ldc * 2  fp64
    add     x30, x28, x27, lsl  #4     // XC_ptr + SVLs * ldc * 3  fp64

LOAD_C_START:
    psel    p5, p4, p0.d[w13, 0]
    psel    p6, p4, p0.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p0.d[w13, 0]
    ld1d    {z0.d}, p5/z, [x11]               // c_ptr0
    ld1d    {z1.d}, p6/z, [x11, x8, lsl #3]   // c_ptr0 + ldc
    ld1d    {z2.d}, p7/z, [x11, x25, lsl #3]  // c_ptr0 + ldc*2
    psel    p5, p4, p0.d[w13, 1]
    ld1d    {z3.d}, p5/z, [x11, x17, lsl #3]  // c_ptr0 + ldc*3
    mova    za0h.d[w15,0:3], {z0.d-z3.d}
    add     x11, x11, x8, lsl #5         //c_ptr0 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p1.d[w13, 0]
    psel    p6, p4, p1.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p1.d[w13, 0]
    ld1d    {z4.d}, p5/z, [x28]               // c_ptr1
    ld1d    {z5.d}, p6/z, [x28, x8, lsl #3]   // c_ptr1 + ldc
    ld1d    {z6.d}, p7/z, [x28, x25, lsl #3]  // c_ptr1 + ldc*2
    psel    p5, p4, p1.d[w13, 1]
    ld1d    {z7.d}, p5/z, [x28, x17, lsl #3]  // c_ptr1 + ldc*3
    mova    za1h.d[w15,0:3], {z4.d-z7.d}
    add     x28, x28, x8, lsl #5         //c_ptr1 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p2.d[w13, 0]
    psel    p6, p4, p2.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p2.d[w13, 0]
    ld1d    {z8.d}, p5/z, [x29]               // c_ptr2
    ld1d    {z9.d}, p6/z, [x29, x8, lsl #3]   // c_ptr2 + ldc
    ld1d    {z10.d}, p7/z, [x29, x25, lsl #3]  // c_ptr2 + ldc*2
    psel    p5, p4, p2.d[w13, 1]
    ld1d    {z11.d}, p5/z, [x29, x17, lsl #3]  // c_ptr2 + ldc*3
    mova    za2h.d[w15,0:3], {z8.d-z11.d}
    add     x29, x29, x8, lsl #5         //c_ptr2 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p3.d[w13, 0]
    psel    p6, p4, p3.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p3.d[w13, 0]
    ld1d    {z12.d}, p5/z, [x30]               // c_ptr3
    ld1d    {z13.d}, p6/z, [x30, x8, lsl #3]   // c_ptr3 + ldc
    ld1d    {z14.d}, p7/z, [x30, x25, lsl #3]  // c_ptr3 + ldc*2
    psel    p5, p4, p3.d[w13, 1]
    ld1d    {z15.d}, p5/z, [x30, x17, lsl #3]  // c_ptr3 + ldc*3
    mova    za3h.d[w15,0:3], {z12.d-z15.d}
    add     x30, x30, x8, lsl #5         //c_ptr3 += 4*ldc FP64 bytes
    add     w13, w13, #2
    add     w15, w15, #4

    cmp     w13, w12
    b.mi    LOAD_C_START

//-------------------------------------------------------------------    
PACKB_KERNEL:
    mov x19, x3                     // b_ptr = b_base
    
    mov x24, x4                     // packa

    mul x28, x12, x1        // SVLd * KC * 1
    lsl x29, x28, #1         // SVLd * KC * 2
    add x30, x28, x29       // SVLd * KC * 3

//---------------------KC LOOP PACKA------------------------------------------------
    lsr x23, x1, #4                 // KC/16
    and x13, x1, #0xF               // KC % 16
    
    cbz     x23, 1f
PACKB_M32xN8_LOOP_K16:
    PACKB_KERNEL_M32N8_K16
    subs  x23, x23, #1
    b.ne PACKB_M32xN8_LOOP_K16

1:
    cbz    x13, 2f
PACKB_M32xN8_LOOP_K1:
    PACKB_KERNEL_M32N8_K1
    subs    x13, x13, #1
    b.ne    PACKB_M32xN8_LOOP_K1       
    
2:
    //nop


//----------------STORE C-----------------------
    mov     w13, #0
    mov     w15, #0
    mov     x11, x20      // XC_ptr
    add     x28, x20, x27, lsl  #3     // XC_ptr + SVLd * ldc  fp64 bytes      
    add     x29, x20, x27, lsl  #4     // XC_ptr + SVLd * ldc * 2  fp64
    add     x30, x28, x27, lsl  #4     // XC_ptr + SVLd * ldc * 3  fp64

STORE_C_START:
    mova    {z0.d-z3.d}, za0h.d[w15,0:3]
    mova    {z4.d-z7.d}, za1h.d[w15,0:3]
    mova    {z8.d-z11.d}, za2h.d[w15,0:3]
    mova    {z12.d-z15.d}, za3h.d[w15,0:3]
    
    psel    p5, p4, p0.d[w13, 0]
    psel    p6, p4, p0.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p0.d[w13, 0]
    st1d    {z0.d},  p5, [x11]               // c_ptr0 
    st1d    {z1.d},  p6, [x11, x8, lsl #3]   // c_ptr0 + ldc
    st1d    {z2.d},  p7, [x11, x25, lsl #3]   // c_ptr0 + ldc * 2
    psel    p5, p4, p0.d[w13, 1]
    st1d    {z3.d},  p5, [x11, x17, lsl #3]   // c_ptr0 + ldc * 3
    add     x11, x11, x8, lsl #5         //c_ptr0 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p1.d[w13, 0]
    psel    p6, p4, p1.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p1.d[w13, 0]
    st1d    {z4.d},  p5, [x28]               // c_ptr1
    st1d    {z5.d},  p6, [x28, x8, lsl #3]   // c_ptr1 + ldc
    st1d    {z6.d},  p7, [x28, x25, lsl #3]   // c_ptr1 + ldc * 2
    psel    p5, p4, p1.d[w13, 1]
    st1d    {z7.d},  p5, [x28, x17, lsl #3]   // c_ptr1 + ldc * 3
    add     x28, x28, x8, lsl #5         //c_ptr1 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p2.d[w13, 0]
    psel    p6, p4, p2.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p2.d[w13, 0]
    st1d    {z8.d},  p5, [x29]               // c_ptr2 
    st1d    {z9.d},  p6, [x29, x8, lsl #3]   // c_ptr2 + ldc
    st1d    {z10.d},  p7, [x29, x25, lsl #3]   // c_ptr2 + ldc * 2
    psel    p5, p4, p2.d[w13, 1]
    st1d    {z11.d},  p5, [x29, x17, lsl #3]   // c_ptr2 + ldc * 3
    add     x29, x29, x8, lsl #5         //c_ptr2 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p3.d[w13, 0]
    psel    p6, p4, p3.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p3.d[w13, 0]
    st1d    {z12.d},  p5, [x30]               // c_ptr3 
    st1d    {z13.d},  p6, [x30, x8, lsl #3]   // c_ptr3 + ldc
    st1d    {z14.d},  p7, [x30, x25, lsl #3]   // c_ptr3 + ldc * 2
    psel    p5, p4, p3.d[w13, 1]
    st1d    {z15.d},  p5, [x30, x17, lsl #3]   // c_ptr3 + ldc * 3
    add     x30, x30, x8, lsl #5         //c_ptr3 += 4*ldc FP64 bytes
    add     w13, w13, #2
    add     w15, w15, #4

    cmp     w13, w12
    b.mi    STORE_C_START


//----Jump to Loop_NR-------------------------
    addvl   x3, x3, #1            // b_base += SVLd (bytes)
    addvl   x20, x20, #1            // c_base += SVLd


    incd    x21
    whilelt p4.d, x21, x2          // tile predicate (N dimension)
    b.first LOOP_NR

//-------------------------PACKA END--------------------------------------------------



//--------------------------MR1 : MC -> FMOPA --------------------------------------------------------
    mul     x22, x12, x1              // KC * SVLd
    mul     x26, x12, x8              // SVLd * ldc

    incd    x14, all, mul #4        // M loop counter +=  4 * SVLd
    whilelt pn9.d, x14, x0, vlx4    // tiles predicate (M dimension)

LOOP_MR1:
// NUM 1 MR START
    
    pext   {p0.d, p1.d}, pn9[0]      // tiles predicate (M dimension)
    pext   {p2.d, p3.d}, pn9[1]      // tiles predicate (M dimension)
    
    add     x4, x4, x22, lsl #5      // packa +=  4*SVLd*KC  fp64
    add     x6, x6, x26, lsl #5      // c_base +=  4*SVLd*ldc  fp64

    mov     x20, x6                  // XC_ptr

    mov     x16, x5                  // packb

    mov     x21, #0
    whilelt p4.d, x21, x2   // tiles predicate (N dimension)

LOOP_NR_END:

    mov     x24, x4                  // packa_ptr
    mov     x10, x16                  // packb
    
    zero    {za} // beta = 0 -> zero {zero}
    
    cmp     x9, x7
    b.lt    KERNEL_START
//----------------LOAD  C---------------------
    mov     w13, #0
    mov     w15, #0
    mov     x11, x20      // XC_ptr
    add     x28, x20, x27, lsl  #3     // XC_ptr + SVLd * ldc  fp64      
    add     x29, x20, x27, lsl  #4     // XC_ptr + SVLd * ldc * 2  
    add     x30, x28, x27, lsl  #4     // XC_ptr + SVLd * ldc * 3

LOAD_C_END:
    psel    p5, p4, p0.d[w13, 0]
    psel    p6, p4, p0.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p0.d[w13, 0]
    ld1d    {z0.d}, p5/z, [x11]               // c_ptr0
    ld1d    {z1.d}, p6/z, [x11, x8, lsl #3]   // c_ptr0 + ldc
    ld1d    {z2.d}, p7/z, [x11, x25, lsl #3]  // c_ptr0 + ldc*2
    psel    p5, p4, p0.d[w13, 1]
    ld1d    {z3.d}, p5/z, [x11, x17, lsl #3]  // c_ptr0 + ldc*3
    mova    za0h.d[w15,0:3], {z0.d-z3.d}
    add     x11, x11, x8, lsl #5         //c_ptr0 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p1.d[w13, 0]
    psel    p6, p4, p1.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p1.d[w13, 0]
    ld1d    {z4.d}, p5/z, [x28]               // c_ptr1
    ld1d    {z5.d}, p6/z, [x28, x8, lsl #3]   // c_ptr1 + ldc
    ld1d    {z6.d}, p7/z, [x28, x25, lsl #3]  // c_ptr1 + ldc*2
    psel    p5, p4, p1.d[w13, 1]
    ld1d    {z7.d}, p5/z, [x28, x17, lsl #3]  // c_ptr1 + ldc*3
    mova    za1h.d[w15,0:3], {z4.d-z7.d}
    add     x28, x28, x8, lsl #5         //c_ptr1 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p2.d[w13, 0]
    psel    p6, p4, p2.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p2.d[w13, 0]
    ld1d    {z8.d}, p5/z, [x29]               // c_ptr2
    ld1d    {z9.d}, p6/z, [x29, x8, lsl #3]   // c_ptr2 + ldc
    ld1d    {z10.d}, p7/z, [x29, x25, lsl #3]  // c_ptr2 + ldc*2
    psel    p5, p4, p2.d[w13, 1]
    ld1d    {z11.d}, p5/z, [x29, x17, lsl #3]  // c_ptr2 + ldc*3
    mova    za2h.d[w15,0:3], {z8.d-z11.d}
    add     x29, x29, x8, lsl #5         //c_ptr2 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p3.d[w13, 0]
    psel    p6, p4, p3.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p3.d[w13, 0]
    ld1d    {z12.d}, p5/z, [x30]               // c_ptr3
    ld1d    {z13.d}, p6/z, [x30, x8, lsl #3]   // c_ptr3 + ldc
    ld1d    {z14.d}, p7/z, [x30, x25, lsl #3]  // c_ptr3 + ldc*2
    psel    p5, p4, p3.d[w13, 1]
    ld1d    {z15.d}, p5/z, [x30, x17, lsl #3]  // c_ptr3 + ldc*3
    mova    za3h.d[w15,0:3], {z12.d-z15.d}
    add     x30, x30, x8, lsl #5         //c_ptr3 += 4*ldc FP32 bytes
    add     w13, w13, #2
    add     w15, w15, #4

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
KERNEL_M32xN8_LOOP_K16:
    KERNEL_M32N8_K16
    subs x23, x23, #1
    b.ne KERNEL_M32xN8_LOOP_K16

3:
    cbz  x13, 4f
KERNEL_M32xN8_LOOP_K1:
    KERNEL_M32N8_K1
    subs  x13, x13, #1
    b.ne  KERNEL_M32xN8_LOOP_K1
    
4:
    //nop

//----------------STORE C-----------------------
    mov     w13, #0
    mov     w15, #0
    mov     x11, x20      // XC_ptr
    add     x28, x20, x27, lsl  #3     // XC_ptr + SVLd * ldc  fp64 bytes      
    add     x29, x20, x27, lsl  #4     // XC_ptr + SVLs * ldc * 2  fp64
    add     x30, x28, x27, lsl  #4     // XC_ptr + SVLs * ldc * 3  fp64

STORE_C_END:
    mova    {z0.d-z3.d}, za0h.d[w15,0:3]
    mova    {z4.d-z7.d}, za1h.d[w15,0:3]
    mova    {z8.d-z11.d}, za2h.d[w15,0:3]
    mova    {z12.d-z15.d}, za3h.d[w15,0:3]
    
    psel    p5, p4, p0.d[w13, 0]
    psel    p6, p4, p0.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p0.d[w13, 0]
    st1d    {z0.d},  p5, [x11]               // c_ptr0 
    st1d    {z1.d},  p6, [x11, x8, lsl #3]   // c_ptr0 + ldc
    st1d    {z2.d},  p7, [x11, x25, lsl #3]   // c_ptr0 + ldc * 2
    psel    p5, p4, p0.d[w13, 1]
    st1d    {z3.d},  p5, [x11, x17, lsl #3]   // c_ptr0 + ldc * 3
    add     x11, x11, x8, lsl #5         //c_ptr0 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p1.d[w13, 0]
    psel    p6, p4, p1.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p1.d[w13, 0]
    st1d    {z4.d},  p5, [x28]               // c_ptr1
    st1d    {z5.d},  p6, [x28, x8, lsl #3]   // c_ptr1 + ldc
    st1d    {z6.d},  p7, [x28, x25, lsl #3]   // c_ptr1 + ldc * 2
    psel    p5, p4, p1.d[w13, 1]
    st1d    {z7.d},  p5, [x28, x17, lsl #3]   // c_ptr1 + ldc * 3
    add     x28, x28, x8, lsl #5         //c_ptr1 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p2.d[w13, 0]
    psel    p6, p4, p2.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p2.d[w13, 0]
    st1d    {z8.d},  p5, [x29]               // c_ptr2 
    st1d    {z9.d},  p6, [x29, x8, lsl #3]   // c_ptr2 + ldc
    st1d    {z10.d},  p7, [x29, x25, lsl #3]   // c_ptr2 + ldc * 2
    psel    p5, p4, p2.d[w13, 1]
    st1d    {z11.d},  p5, [x29, x17, lsl #3]   // c_ptr2 + ldc * 3
    add     x29, x29, x8, lsl #5         //c_ptr2 += 4*ldc FP64 bytes

    sub     w13, w13, #2
    psel    p5, p4, p3.d[w13, 0]
    psel    p6, p4, p3.d[w13, 1]
    add     w13, w13, #2
    psel    p7, p4, p3.d[w13, 0]
    st1d    {z12.d},  p5, [x30]               // c_ptr3 
    st1d    {z13.d},  p6, [x30, x8, lsl #3]   // c_ptr3 + ldc
    st1d    {z14.d},  p7, [x30, x25, lsl #3]   // c_ptr3 + ldc * 2
    psel    p5, p4, p3.d[w13, 1]
    st1d    {z15.d},  p5, [x30, x17, lsl #3]   // c_ptr3 + ldc * 3
    add     x30, x30, x8, lsl #5         //c_ptr3 += 4*ldc FP64 bytes
    add     w13, w13, #2
    add     w15, w15, #4

    cmp     w13, w12
    b.mi    STORE_C_END

//--------Jump to LOOP_NR_END-----------------------

    add     x16, x16, x22, lsl #3     // packb += SVLd * KC (bytes)
    addvl   x20, x20, #1              // c_base += SVLd

    incd    x21         
    whilelt p4.d, x21, x2           // tile predicate (N dimension)
    b.first LOOP_NR_END

  

//----Jump to LOOP_MR1-----------------------
    incd    x14, all, mul #4     // M loop counter +=  4 * SVLd
    whilelt pn9.d, x14, x0, vlx4   // tiles predicate (M dimension)
    b.first LOOP_MR1



    smstop

    ldp     x29, x30, [sp, #80]
    ldp     x27, x28, [sp, #64]
    ldp     x25, x26, [sp, #48]
    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #96
    

    ret