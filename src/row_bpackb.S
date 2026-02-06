    .text
    .global _row_bpackb
    .align 4

_row_bpackb:  //int8
// x0: K, x1: N, x2: matRight, x3: ldb, x4: packb
    smstart           

    
    cntb    x5              // SVLb -> 64

    add     x14, x0, #3
    lsr     x10, x14, #2      // kc_mod/4 = ceil(kc/4)
    mul     x11, x10, x5      // ceil(kc/4)*SVLb
    lsl     x17, x11, #2      // 4*ceil(kc/4)* SVLb
    lsl     x13, x17, #1      // 4*ceil(kc/4)* SVLb * 2
    add     x11, x17, x13     // 4*ceil(kc/4)* SVLb * 3

    lsl     x15, x3, #1              // 2*ldb
    add     x16, x15, x3             // 3*ldb

    ptrue   pn9.b

    dup     z31.b, #0

    add     x8, x2, x1               // N dimension exit condition   int8
    whilelt pn8.b, x2, x8, vlx4        // N dimension predicate
Loop_N:
    mov     x7, x2          // xb
    mov     x9, x4          // packb

    mov     x6, #0
    whilelt p0.b, x6, x0   // K dimension predicate   
Loop_K:
    mov     x12, #0
    psel    pn10, pn8, p0.b[w12, 0] 
    psel    pn11, pn8, p0.b[w12, 1] 
    psel    pn12, pn8, p0.b[w12, 2] 
    psel    pn13, pn8, p0.b[w12, 3] 
    ld1b    {z0.b-z3.b}, pn10/z, [x7]                  //xb_ptr
    ld1b    {z4.b-z7.b}, pn11/z, [x7, x3]              //xb_ptr + ldb
    ld1b    {z8.b-z11.b}, pn12/z, [x7, x15]             //xb_ptr + 2*ldb
    ld1b    {z12.b-z15.b}, pn13/z, [x7, x16]            //xb_ptr + 3*ldb

    orr     z16.b, z0.b, z31.b
    orr     z17.b, z4.b, z31.b
    orr     z18.b, z8.b, z31.b
    orr     z19.b, z12.b, z31.b

    zip     {z20.b-z23.b}, {z16.b-z19.b}  // 4-way interleave from 4 vectors

    st1b    {z20.b-z23.b}, pn9, [x9]                  // packb

    orr     z24.b, z1.b, z31.b
    orr     z25.b, z5.b, z31.b
    orr     z26.b, z9.b, z31.b
    orr     z27.b, z13.b, z31.b

    zip     {z16.b-z19.b}, {z24.b-z27.b}  

    st1b    {z16.b-z19.b}, pn9, [x9, x17]            // packb + 4*ceil(kc/4) * SVLb int8

    //
    orr     z20.b, z2.b, z31.b
    orr     z21.b, z6.b, z31.b
    orr     z22.b, z10.b, z31.b
    orr     z23.b, z14.b, z31.b

    zip     {z24.b-z27.b}, {z20.b-z23.b}  // 4-way interleave from 4 vectors

    st1b    {z24.b-z27.b}, pn9, [x9, x13]                  // packb + 4*ceil(kc/4) * 2 * SVLb int8

    orr     z16.b, z3.b, z31.b
    orr     z17.b, z7.b, z31.b
    orr     z18.b, z11.b, z31.b
    orr     z19.b, z15.b, z31.b

    zip     {z20.b-z23.b}, {z16.b-z19.b}  

    st1b    {z20.b-z23.b}, pn9, [x9, x11]            // packb + 4*ceil(kc/4) * 3 * SVLb int8
    

    add     x7, x7, x3, lsl #2            // &xb_ptr += 4*ldb int8 bytes

    addvl   x9, x9, #4                    // &packb += 4*SVLb

    add     x6, x6, #4                    // Loop_K counter increment
    whilelt p0.b, x6, x0                  // K dimension predicate
    b.first Loop_K                        // k % 4 != 0 right

    add     x4, x4, x17, lsl #2           // &packb += 4*ceil(kc/4)* 4 * SVLb int8
    addvl   x2, x2, #4                    // &XB += 4 * SVLb 
    whilelt pn8.b, x2, x8, vlx4           // N dimension predicate
    b.first Loop_N

    smstop

    ret