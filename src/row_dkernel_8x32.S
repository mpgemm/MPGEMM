    .text 
    .global _row_dkernel_8x32
    .align  4

.macro PACKB_KERNEL_M8N32_K1
    ld1d    {z0.d-z3.d}, pn9/z, [x19]       //b_ptr
    ld1d    {z4.d}, p4/z, [x24]       //packa

    fmopa   za0.d, p4/m, p0/m, z4.d, z0.d
    fmopa   za1.d, p4/m, p1/m, z4.d, z1.d
    fmopa   za2.d, p4/m, p2/m, z4.d, z2.d
    fmopa   za3.d, p4/m, p3/m, z4.d, z3.d

    st1d    {z0.d-z3.d}, pn9, [x10]        //packb

    add     x19, x19, x8, lsl #3    // b_ptr+= ldb
    addvl   x24, x24, #1            // packa += SVLd
    addvl   x10, x10, #4            // packb += 4*SVLd (bytes)

.endm


.macro PACKB_KERNEL_M8N32_K16
    // K = 8
    ld1d    {z0.d-z3.d}, pn9/z, [x19]       //1 b_ptr
    ld1d    {z4.d-z7.d}, pn10/z, [x24]       //4 packa
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    ld1d    {z8.d-z11.d}, pn9/z, [x19]      //2 b_ptr
    fmopa   za0.d, p4/m, p0/m, z4.d, z0.d
    fmopa   za1.d, p4/m, p1/m, z4.d, z1.d
    fmopa   za2.d, p4/m, p2/m, z4.d, z2.d
    fmopa   za3.d, p4/m, p3/m, z4.d, z3.d

    st1d    {z0.d-z3.d}, pn9, [x10]         //1 packb
    
    
    add     x19, x19, x8, lsl #3           
    ld1d    {z12.d-z15.d}, pn9/z, [x19]      //3 b_ptr
    fmopa   za0.d, p4/m, p0/m, z5.d, z8.d
    fmopa   za1.d, p4/m, p1/m, z5.d, z9.d
    fmopa   za2.d, p4/m, p2/m, z5.d, z10.d
    fmopa   za3.d, p4/m, p3/m, z5.d, z11.d

    st1d    {z8.d-z11.d}, pn9, [x10, #4, MUL VL]   //2 packb
   
    add     x19, x19, x8, lsl #3         
    ld1d    {z16.d-z19.d}, pn9/z, [x19]      //4 b_ptr
    fmopa   za0.d, p4/m, p0/m, z6.d, z12.d
    fmopa   za1.d, p4/m, p1/m, z6.d, z13.d
    fmopa   za2.d, p4/m, p2/m, z6.d, z14.d
    fmopa   za3.d, p4/m, p3/m, z6.d, z15.d

    st1d    {z12.d-z15.d}, pn9, [x10, #8, MUL VL]       //3 packb
    
    add     x19, x19, x8, lsl #3      
    ld1d    {z24.d-z27.d}, pn10/z, [x24, #4, MUL VL]       //8 packa      
    ld1d    {z20.d-z23.d}, pn9/z, [x19]      //5 b_ptr
    fmopa   za0.d, p4/m, p0/m, z7.d, z16.d
    fmopa   za1.d, p4/m, p1/m, z7.d, z17.d
    fmopa   za2.d, p4/m, p2/m, z7.d, z18.d
    fmopa   za3.d, p4/m, p3/m, z7.d, z19.d

    st1d    {z16.d-z19.d}, pn9, [x10, #12, MUL VL]      //4 packb
   
    add     x19, x19, x8, lsl #3           
    ld1d    {z28.d-z31.d}, pn9/z, [x19]      //6 b_ptr
    fmopa   za0.d, p4/m, p0/m, z24.d, z20.d
    fmopa   za1.d, p4/m, p1/m, z24.d, z21.d
    fmopa   za2.d, p4/m, p2/m, z24.d, z22.d
    fmopa   za3.d, p4/m, p3/m, z24.d, z23.d

    st1d    {z20.d-z23.d}, pn9, [x10, #16, MUL VL]      //5 packb
    
    add     x19, x19, x8, lsl #3           
    ld1d    {z0.d-z3.d}, pn9/z, [x19]      //7 b_ptr
    fmopa   za0.d, p4/m, p0/m, z25.d, z28.d
    fmopa   za1.d, p4/m, p1/m, z25.d, z29.d
    fmopa   za2.d, p4/m, p2/m, z25.d, z30.d
    fmopa   za3.d, p4/m, p3/m, z25.d, z31.d

    st1d    {z28.d-z31.d}, pn9, [x10, #20, MUL VL]      //6 packb
    
    add     x19, x19, x8, lsl #3           
    ld1d    {z4.d-z7.d}, pn9/z, [x19]      //8 b_ptr

    fmopa   za0.d, p4/m, p0/m, z26.d, z0.d
    fmopa   za1.d, p4/m, p1/m, z26.d, z1.d
    fmopa   za2.d, p4/m, p2/m, z26.d, z2.d
    fmopa   za3.d, p4/m, p3/m, z26.d, z3.d

    st1d    {z0.d-z3.d}, pn9, [x10, #24, MUL VL]      //7 packb
    
    add     x19, x19, x8, lsl #3  
    ld1d    {z12.d-z15.d}, pn10/z, [x24, #8, MUL VL]       //12 packa          
    ld1d    {z8.d-z11.d}, pn9/z, [x19]      //9 b_ptr
    fmopa   za0.d, p4/m, p0/m, z27.d, z4.d
    fmopa   za1.d, p4/m, p1/m, z27.d, z5.d
    fmopa   za2.d, p4/m, p2/m, z27.d, z6.d
    fmopa   za3.d, p4/m, p3/m, z27.d, z7.d
 
//----------------------------------------------------------------------
    st1d    {z4.d-z7.d}, pn9, [x10, #28, MUL VL]      //8 packb
   
    add     x19, x19, x8, lsl #3  
    ld1d    {z16.d-z19.d}, pn9/z, [x19]      //10 b_ptr
    fmopa   za0.d, p4/m, p0/m, z12.d, z8.d
    fmopa   za1.d, p4/m, p1/m, z12.d, z9.d
    fmopa   za2.d, p4/m, p2/m, z12.d, z10.d
    fmopa   za3.d, p4/m, p3/m, z12.d, z11.d

        
    add     x10, x10, #2048         //packb += 4 * 8 * SVLd  
   
    st1d    {z8.d-z11.d}, pn9, [x10]         //9 packb

    add     x19, x19, x8, lsl #3            
    ld1d    {z20.d-z23.d}, pn9/z, [x19]      //11 b_ptr

    fmopa   za0.d, p4/m, p0/m, z13.d, z16.d
    fmopa   za1.d, p4/m, p1/m, z13.d, z17.d
    fmopa   za2.d, p4/m, p2/m, z13.d, z18.d
    fmopa   za3.d, p4/m, p3/m, z13.d, z19.d

    st1d    {z16.d-z19.d}, pn9, [x10, #4, MUL VL]      //10 packb
    
    add     x19, x19, x8, lsl #3            
    ld1d    {z24.d-z27.d}, pn9/z, [x19]      //12 b_ptr
    fmopa   za0.d, p4/m, p0/m, z14.d, z20.d
    fmopa   za1.d, p4/m, p1/m, z14.d, z21.d
    fmopa   za2.d, p4/m, p2/m, z14.d, z22.d
    fmopa   za3.d, p4/m, p3/m, z14.d, z23.d

    st1d    {z20.d-z23.d}, pn9, [x10, #8, MUL VL]      //11 packb
    
    add     x19, x19, x8, lsl #3       
    ld1d    {z0.d-z3.d}, pn10/z, [x24, #12, MUL VL]       //16 packa 
    ld1d    {z28.d-z31.d}, pn9/z, [x19]      //13 b_ptr

    fmopa   za0.d, p4/m, p0/m, z15.d, z24.d
    fmopa   za1.d, p4/m, p1/m, z15.d, z25.d
    fmopa   za2.d, p4/m, p2/m, z15.d, z26.d
    fmopa   za3.d, p4/m, p3/m, z15.d, z27.d

    st1d    {z24.d-z27.d}, pn9, [x10, #12, MUL VL]      //12 packb
    
    add     x19, x19, x8, lsl #3
    ld1d    {z4.d-z7.d}, pn9/z, [x19]      //14 b_ptr

    fmopa   za0.d, p4/m, p0/m, z0.d, z28.d
    fmopa   za1.d, p4/m, p1/m, z0.d, z29.d
    fmopa   za2.d, p4/m, p2/m, z0.d, z30.d
    fmopa   za3.d, p4/m, p3/m, z0.d, z31.d

    st1d    {z28.d-z31.d}, pn9, [x10, #16, MUL VL]      //13 packb
    add     x19, x19, x8, lsl #3
    ld1d    {z8.d-z11.d}, pn9/z, [x19]      //15 b_ptr

    fmopa   za0.d, p4/m, p0/m, z1.d, z4.d
    fmopa   za1.d, p4/m, p1/m, z1.d, z5.d  
    fmopa   za2.d, p4/m, p2/m, z1.d, z6.d
    fmopa   za3.d, p4/m, p3/m, z1.d, z7.d

    st1d    {z4.d-z7.d}, pn9, [x10, #20, MUL VL]      //14 packb
    add     x19, x19, x8, lsl #3
    ld1d    {z12.d-z15.d}, pn9/z, [x19]      //16 b_ptr

    fmopa   za0.d, p4/m, p0/m, z2.d, z8.d  
    fmopa   za1.d, p4/m, p1/m, z2.d, z9.d
    fmopa   za2.d, p4/m, p2/m, z2.d, z10.d
    fmopa   za3.d, p4/m, p3/m, z2.d, z11.d

    st1d    {z8.d-z11.d}, pn9, [x10, #24, MUL VL]      //15 packb
   
    fmopa   za0.d, p4/m, p0/m, z3.d, z12.d
    fmopa   za1.d, p4/m, p1/m, z3.d, z13.d
    fmopa   za2.d, p4/m, p2/m, z3.d, z14.d
    fmopa   za3.d, p4/m, p3/m, z3.d, z15.d

    st1d    {z12.d-z15.d}, pn9, [x10, #28, MUL VL]      //16 packb
    add     x19, x19, x8, lsl #3            //b_ptr+= ldb
    add     x24, x24, #1024         //packa += 16 * SVLd
    add     x10, x10, #2048         //packb += 4 * 8 * SVLd (bytes)
.endm


.macro KERNEL_M8N32_K1
    ld1d    {z0.d-z3.d}, pn9/z,   [x10]    //packb b_ptr
    ld1d    {z4.d}, p4/z,   [x24]    //packa 

    fmopa   za0.d, p4/m, p0/m, z4.d, z0.d
    fmopa   za1.d, p4/m, p1/m, z4.d, z1.d
    fmopa   za2.d, p4/m, p2/m, z4.d, z2.d
    fmopa   za3.d, p4/m, p3/m, z4.d, z3.d
    addvl x10, x10, #4                     // packb += 4*svld
    addvl x24, x24, #1                     // packa += 1*svld 
.endm 


.macro KERNEL_M8N32_K16    
    //---------------
    // K = 16
    ld1d    {z0.d-z3.d}, pn9/z,   [x10]    //1 b_ptr
    ld1d    {z4.d-z7.d}, pn10/z,   [x24]    //4 a_ptr  
    ld1d    {z8.d-z11.d}, pn9/z,   [x10, #4, MUL VL]    //2 b_ptr

    fmopa   za0.d, p4/m, p0/m, z4.d, z0.d
    fmopa   za1.d, p4/m, p1/m, z4.d, z1.d
    fmopa   za2.d, p4/m, p2/m, z4.d, z2.d
    fmopa   za3.d, p4/m, p3/m, z4.d, z3.d

    ld1d    {z12.d-z15.d}, pn9/z,   [x10, #8, MUL VL]    //3 b_ptr
    fmopa   za0.d, p4/m, p0/m, z5.d, z8.d
    fmopa   za1.d, p4/m, p1/m, z5.d, z9.d
    fmopa   za2.d, p4/m, p2/m, z5.d, z10.d
    fmopa   za3.d, p4/m, p3/m, z5.d, z11.d

    ld1d    {z16.d-z19.d}, pn9/z,   [x10, #12, MUL VL]    //4 b_ptr
    fmopa   za0.d, p4/m, p0/m, z6.d, z12.d
    fmopa   za1.d, p4/m, p1/m, z6.d, z13.d
    fmopa   za2.d, p4/m, p2/m, z6.d, z14.d
    fmopa   za3.d, p4/m, p3/m, z6.d, z15.d

    ld1d    {z20.d-z23.d}, pn9/z,   [x10, #16, MUL VL]    //5 b_ptr
    ld1d    {z24.d-z27.d}, pn10/z,   [x24, #4, MUL VL]    //8 a_ptr
    fmopa   za0.d, p4/m, p0/m, z7.d, z16.d
    fmopa   za1.d, p4/m, p1/m, z7.d, z17.d
    fmopa   za2.d, p4/m, p2/m, z7.d, z18.d
    fmopa   za3.d, p4/m, p3/m, z7.d, z19.d

    ld1d    {z28.d-z31.d}, pn9/z,   [x10, #20, MUL VL]    //6 b_ptr
    fmopa   za0.d, p4/m, p0/m, z24.d, z20.d
    fmopa   za1.d, p4/m, p1/m, z24.d, z21.d
    fmopa   za2.d, p4/m, p2/m, z24.d, z22.d
    fmopa   za3.d, p4/m, p3/m, z24.d, z23.d

    ld1d    {z0.d-z3.d}, pn9/z,   [x10, #24, MUL VL]    //7 b_ptr
    fmopa   za0.d, p4/m, p0/m, z25.d, z28.d
    fmopa   za1.d, p4/m, p1/m, z25.d, z29.d
    fmopa   za2.d, p4/m, p2/m, z25.d, z30.d
    fmopa   za3.d, p4/m, p3/m, z25.d, z31.d

    ld1d    {z4.d-z7.d}, pn9/z,   [x10, #28, MUL VL]    //8 b_ptr
    fmopa   za0.d, p4/m, p0/m, z26.d, z0.d
    fmopa   za1.d, p4/m, p1/m, z26.d, z1.d
    fmopa   za2.d, p4/m, p2/m, z26.d, z2.d
    fmopa   za3.d, p4/m, p3/m, z26.d, z3.d

    add   x10, x10, #2048  // NR 4 * SVLd * 8 fp64 bytes

    ld1d    {z8.d-z11.d}, pn9/z,   [x10]    //9 b_ptr
    ld1d    {z12.d-z15.d}, pn10/z,  [x24, #8, MUL VL]  //12 a_ptr
    fmopa   za0.d, p4/m, p0/m, z27.d, z4.d
    fmopa   za1.d, p4/m, p1/m, z27.d, z5.d
    fmopa   za2.d, p4/m, p2/m, z27.d, z6.d
    fmopa   za3.d, p4/m, p3/m, z27.d, z7.d

//--------------------------------------------------------------------
    ld1d    {z16.d-z19.d}, pn9/z,   [x10, #4, MUL VL]    //10 b_ptr
    fmopa   za0.d, p4/m, p0/m, z12.d, z8.d
    fmopa   za1.d, p4/m, p1/m, z12.d, z9.d
    fmopa   za2.d, p4/m, p2/m, z12.d, z10.d
    fmopa   za3.d, p4/m, p3/m, z12.d, z11.d

    ld1d    {z20.d-z23.d}, pn9/z,   [x10, #8, MUL VL]    //11 b_ptr
    fmopa   za0.d, p4/m, p0/m, z13.d, z16.d
    fmopa   za1.d, p4/m, p1/m, z13.d, z17.d
    fmopa   za2.d, p4/m, p2/m, z13.d, z18.d
    fmopa   za3.d, p4/m, p3/m, z13.d, z19.d

    ld1d    {z24.d-z27.d}, pn9/z,   [x10, #12, MUL VL]    //12 b_ptr
    fmopa   za0.d, p4/m, p0/m, z14.d, z20.d
    fmopa   za1.d, p4/m, p1/m, z14.d, z21.d
    fmopa   za2.d, p4/m, p2/m, z14.d, z22.d
    fmopa   za3.d, p4/m, p3/m, z14.d, z23.d

    ld1d    {z28.d-z31.d}, pn9/z,   [x10, #16, MUL VL]    //13 b_ptr
    ld1d    {z0.d-z3.d}, pn10/z,  [x24, #12, MUL VL]  //16 a_ptr
    fmopa   za0.d, p4/m, p0/m, z15.d, z24.d
    fmopa   za1.d, p4/m, p1/m, z15.d, z25.d
    fmopa   za2.d, p4/m, p2/m, z15.d, z26.d
    fmopa   za3.d, p4/m, p3/m, z15.d, z27.d

    ld1d    {z4.d-z7.d}, pn9/z,   [x10, #20, MUL VL]    //14 b_ptr
    fmopa   za0.d, p4/m, p0/m, z0.d, z28.d
    fmopa   za1.d, p4/m, p1/m, z0.d, z29.d
    fmopa   za2.d, p4/m, p2/m, z0.d, z30.d
    fmopa   za3.d, p4/m, p3/m, z0.d, z31.d

    ld1d    {z8.d-z11.d}, pn9/z,   [x10, #24, MUL VL]    //15 b_ptr
    fmopa   za0.d, p4/m, p0/m, z1.d, z4.d
    fmopa   za1.d, p4/m, p1/m, z1.d, z5.d
    fmopa   za2.d, p4/m, p2/m, z1.d, z6.d
    fmopa   za3.d, p4/m, p3/m, z1.d, z7.d

    ld1d    {z12.d-z15.d}, pn9/z,   [x10, #28, MUL VL]    //16 b_ptr
    fmopa   za0.d, p4/m, p0/m, z2.d, z8.d
    fmopa   za1.d, p4/m, p1/m, z2.d, z9.d
    fmopa   za2.d, p4/m, p2/m, z2.d, z10.d
    fmopa   za3.d, p4/m, p3/m, z2.d, z11.d

   
    fmopa   za0.d, p4/m, p0/m, z3.d, z12.d
    fmopa   za1.d, p4/m, p1/m, z3.d, z13.d
    fmopa   za2.d, p4/m, p2/m, z3.d, z14.d
    fmopa   za3.d, p4/m, p3/m, z3.d, z15.d

    add x10, x10, #2048 // packb

    add x24, x24, #1024 //16*SVLd fp64  packa

.endm


_row_dkernel_8x32:
//x0:mc, x1:kc, x2:nc, x3: XB, x4: packa, x5: packb, x6:c, x7:KC, x8:ldc, x9:pc

    ldr     w8,  [sp]        // ldc = ldb = n
    ldr     w9,  [sp, #4]    // pc

    stp     x19, x20, [sp, #-80]!
    stp     x21, x22, [sp, #16]
    stp     x23, x24, [sp, #32]
    stp     x25, x26, [sp, #48]
    stp     x27, x28, [sp, #64]


    smstart


    cntd    x12                     //   SVLd -> 8

    mov    x20, x6                  // c_base

    lsl     x25, x8, #1   // ldc * 2
    lsl     x17, x8, #2   // ldc * 4
    add     x27, x25, x8  // ldc * 3

    mov     x14, #0
    whilelt p4.d, x14, x0           // tiles predicate (M dimension)


    mov     x21, #0                 
    whilelt pn9.d, x21, x2, vlx4   // tiles predicate (N dimension)

//--------------------NR : NC LOOP -> PACKB + FMOPA ------------------------------------
    mov x10, x5                      // packb

LOOP_NR:

    pext   {p0.d, p1.d}, pn9[0]      // tiles predicate (N dimension)
    pext   {p2.d, p3.d}, pn9[1]      // tiles predicate (N dimension)

    zero {za}

    cmp     x9, x7
    b.lt    PACKB_KERNEL

//----------------LOAD  C---------------------
    mov     w13, #0
    mov     w15, #0
    mov     x11, x20      // XC_ptr

LOAD_C_START:
    psel    pn10, pn9, p4.d[w13, #0]
    psel    pn11, pn9, p4.d[w13, #1]

    add     w13, w13, #2
    psel    pn12, pn9, p4.d[w13, #0]
    psel    pn13, pn9, p4.d[w13, #1]
    ld1d    {z0.d, z4.d, z8.d, z12.d}, pn10/z, [x11]               // c_ptr0
    ld1d    {z1.d, z5.d, z9.d, z13.d}, pn11/z, [x11, x8, lsl #3]   // c_ptr0 + ldc
    ld1d    {z2.d, z6.d, z10.d, z14.d}, pn12/z, [x11, x25, lsl #3]  // c_ptr0 + ldc*2
    ld1d    {z3.d, z7.d, z11.d, z15.d}, pn13/z, [x11, x27, lsl #3]  // c_ptr0 + ldc*3

    mova    za0h.d[w15,0:3], {z0.d-z3.d}
    mova    za1h.d[w15,0:3], {z4.d-z7.d}
    mova    za2h.d[w15,0:3], {z8.d-z11.d}
    mova    za3h.d[w15,0:3], {z12.d-z15.d}

    add     x11, x11, x17, lsl #3         //c_ptr0 += 4*ldc FP64 bytes
    add     w13, w13, #2
    add     w15, w15, #4

    cmp     w13, w12
    b.mi    LOAD_C_START


//-------------------------------------------------------------------    
PACKB_KERNEL:
    mov x19, x3                     // b_ptr = b_base
    
    mov x24, x4                     // packa

    ptrue pn10.b

//---------------------KC LOOP PACKB------------------------------------------------
    lsr x23, x1, #4                 // KC/16
    and x13, x1, #0xF               // KC%16
    
    cbz     x23, 1f
PACKB_M8xN32_LOOP_K16:
    PACKB_KERNEL_M8N32_K16
    subs  x23, x23, #1
    b.ne PACKB_M8xN32_LOOP_K16

1:
    cbz    x13, 2f
PACKB_M8xN32_LOOP_K1:
    PACKB_KERNEL_M8N32_K1
    subs    x13, x13, #1
    b.ne    PACKB_M8xN32_LOOP_K1       
    
2:
    //nop

//----------------STORE C-----------------------
    mov     w13, #0
    mov     w15, #0
    mov     x11, x20      // XC_ptr

STORE_C_START:
    psel    pn10, pn9, p4.d[w13, 0]
    psel    pn11, pn9, p4.d[w13, 1]

    add     w13, w13, #2
    psel    pn12, pn9, p4.d[w13, 0]
    psel    pn13, pn9, p4.d[w13, 1]
    mova    {z0.d-z3.d}, za0h.d[w15,0:3]
    mova    {z4.d-z7.d}, za1h.d[w15,0:3]
    mova    {z8.d-z11.d}, za2h.d[w15,0:3]
    mova    {z12.d-z15.d}, za3h.d[w15,0:3]

    st1d    {z0.d, z4.d, z8.d, z12.d},  pn10, [x11]               // c_ptr0 
    st1d    {z1.d, z5.d, z9.d, z13.d},  pn11, [x11, x8, lsl #3]   // c_ptr0 + ldc
    st1d    {z2.d, z6.d, z10.d, z14.d},  pn12, [x11, x25, lsl #3]  // c_ptr0 + ldc*2
    st1d    {z3.d, z7.d, z11.d, z15.d},  pn13, [x11, x27, lsl #3]   // c_ptr0 + ldc*3

    add     x11, x11, x17, lsl #3         //c_ptr0 += 4 * ldc FP64 bytes
    add     w13, w13, #2
    add     w15, w15, #4

    cmp     w13, w12
    b.mi    STORE_C_START


//----Jump to Loop_NR-------------------------
    addvl   x3, x3, #4            // b_base += 4*SVLd (bytes)
    addvl   x20, x20, #4            // c_base += 4*SVLd

    add     x21, x21, #32
    whilelt pn9.d, x21, x2, vlx4   // tile predicate (N dimension)
    b.first LOOP_NR

//-------------------------PACKB END--------------------------------------------------



//--------------------------MR1 : MC -> FMOPA --------------------------------------------------------
    mul     x22, x12, x1              // KC * MR(SVLd)
    mul     x26, x12, x8              // SVLd * ldc

    incd    x14              // M loop counter +=  SVLs
    whilelt p4.d, x14, x0    // tiles predicate (M dimension)

LOOP_MR1:
// NUM 1 MR START

    add     x4, x4, x22, lsl #3      // packa +=  SVLd*KC
    add     x6, x6, x26, lsl #3      // c_base +=  SVLd*ldc

    
    mov     x20, x6                  // XC_ptr

    mov     x16, x5                  // packb

    mov     x21, #0
    whilelt pn9.d, x21, x2, vlx4   // tiles predicate (N dimension)

LOOP_NR_END:

    mov     x24, x4                  // packa_ptr
    mov     x10, x16                  // packb

    pext   {p0.d, p1.d}, pn9[0]      // tiles predicate (N dimension)
    pext   {p2.d, p3.d}, pn9[1]      // tiles predicate (N dimension)
    
    zero    {za}

    cmp     x9, x7
    b.lt    KERNEL_START
//----------------LOAD  C---------------------
    mov     w13, #0
    mov     w15, #0
    mov     x11, x20      // XC_ptr

LOAD_C_END:
    psel    pn10, pn9, p4.d[w13, 0]
    psel    pn11, pn9, p4.d[w13, 1]

    add     w13, w13, #2
    psel    pn12, pn9, p4.d[w13, 0]
    psel    pn13, pn9, p4.d[w13, 1]
    ld1d    {z0.d, z4.d, z8.d, z12.d}, pn10/z, [x11]               // c_ptr0
    ld1d    {z1.d, z5.d, z9.d, z13.d}, pn11/z, [x11, x8, lsl #3]   // c_ptr0 + ldc
    ld1d    {z2.d, z6.d, z10.d, z14.d}, pn12/z, [x11, x25, lsl #3]  // c_ptr0 + ldc*2
    ld1d    {z3.d, z7.d, z11.d, z15.d}, pn13/z, [x11, x27, lsl #3]  // c_ptr0 + ldc*3

    mova    za0h.d[w15,0:3], {z0.d-z3.d}
    mova    za1h.d[w15,0:3], {z4.d-z7.d}
    mova    za2h.d[w15,0:3], {z8.d-z11.d}
    mova    za3h.d[w15,0:3], {z12.d-z15.d}

    add     x11, x11, x17, lsl #3         //c_ptr0 += 4*ldc FP64 bytes
    add     w13, w13, #2
    add     w15, w15, #4

    cmp     w13, w12
    b.mi    LOAD_C_END

//-------------------------------------------------------------------  
KERNEL_START:

    ptrue   pn10.b

    lsr x23, x1, #4                 // KC/16
    and x13, x1, #0xF               // KC % 16

    cbz  x23, 3f
KERNEL_M8xN32_LOOP_K16:
    KERNEL_M8N32_K16
    subs x23, x23, #1
    b.ne KERNEL_M8xN32_LOOP_K16

3:
    cbz  x13, 4f
KERNEL_M8xN32_LOOP_K1:
    KERNEL_M8N32_K1
    subs  x13, x13, #1
    b.ne  KERNEL_M8xN32_LOOP_K1
    
4:
    //nop

//----------------STORE C-----------------------
    mov     w13, #0
    mov     x11, x20      // XC_ptr
    mov     w15, #0

STORE_C_END:
    psel    pn10, pn9, p4.d[w13, 0]
    psel    pn11, pn9, p4.d[w13, 1]

    add     w13, w13, #2
    psel    pn12, pn9, p4.d[w13, 0]
    psel    pn13, pn9, p4.d[w13, 1]
    mova    {z0.d-z3.d}, za0h.d[w15,0:3]
    mova    {z4.d-z7.d}, za1h.d[w15,0:3]
    mova    {z8.d-z11.d}, za2h.d[w15,0:3]
    mova    {z12.d-z15.d}, za3h.d[w15,0:3]

    st1d    {z0.d, z4.d, z8.d, z12.d},  pn10, [x11]               // c_ptr0 
    st1d    {z1.d, z5.d, z9.d, z13.d},  pn11, [x11, x8, lsl #3]   // c_ptr0 + ldc
    st1d    {z2.d, z6.d, z10.d, z14.d},  pn12, [x11, x25, lsl #3]  // c_ptr0 + ldc*2
    st1d    {z3.d, z7.d, z11.d, z15.d},  pn13, [x11, x27, lsl #3]   // c_ptr0 + ldc*3

    add     x11, x11, x17, lsl #3         //c_ptr0 += 4 * ldc FP64 bytes
    add     w13, w13, #2
    add     w15, w15, #4

    cmp     w13, w12
    b.mi    STORE_C_END

//--------Jump to LOOP_NR_END-----------------------

    add     x16, x16, x22, lsl #5             // packb += 4 * SVLd * KC (bytes)
    addvl   x20, x20, #4              // c_base += 4*SVLb

    add     x21, x21, #32           // 
    whilelt pn9.d, x21, x2, vlx4   // tile predicate (N dimension)
    b.first LOOP_NR_END

  

//----Jump to LOOP_MR1-----------------------
    incd    x14        // M loop counter += SVLd
    whilelt p4.d, x14, x0   // tiles predicate (M dimension)
    b.first LOOP_MR1



    smstop


    ldp     x27, x28, [sp, #64]
    ldp     x25, x26, [sp, #48]
    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #80
    

    ret