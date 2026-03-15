    .text
    .global _row_shpackb
    .align 4

_row_shpackb: 
// x0: K, x1: N, x2: matRight, x3: ldb, x4: packb
    smstart           

    
    cnth    x5            

    add     x14, x0, #1
    lsr     x10, x14, #1      // kc_mod/2 = ceil(kc/2)
    mul     x11, x10, x5      // ceil(kc/2)*SVLh
    lsl     x17, x11, #1      // 2*ceil(kc/2)* SVLh
    lsl     x13, x17, #1      // 2*ceil(kc/2)* SVLh * 2
    add     x11, x17, x13     // 2*ceil(kc/2)* SVLh * 3

    ptrue   pn9.b

    add     x8, x2, x1, lsl #1         // N dimension exit condition
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
    ld1h    {z0.h-z3.h}, pn10/z, [x7]                  //xb_ptr
    ld1h    {z4.h-z7.h}, pn11/z, [x7, x3, lsl #1]      //xb_ptr + ldb
    
    zip     {z8.h-z9.h}, z0.h, z4.h    // 2-way interleave from 2 vectors
    zip     {z10.h-z11.h}, z1.h, z5.h
    zip     {z12.h-z13.h}, z2.h, z6.h
    zip     {z14.h-z15.h}, z3.h, z7.h

    add     x7, x7, x3, lsl #2            // &xb_ptr += 2*ldb fp16 bytes

    st1h    {z8.h-z9.h}, pn9, [x9]                  // packb
    st1h    {z10.h-z11.h}, pn9, [x9, x17, lsl #1]   // packb + 2*ceil(kc/2) * SVLh fp16
    st1h    {z12.h-z13.h}, pn9, [x9, x13, lsl #1]   // packb + 2*ceil(kc/2) * 2 * SVLh fp16
    st1h    {z14.h-z15.h}, pn9, [x9, x11, lsl #1]   // packb + 2*ceil(kc/2) * 3 * SVLh fp16

    addvl   x9, x9, #2                    // &packb += 2*SVLb

    add     x6, x6, #2                    // Loop_K counter increment
    whilelt p0.b, x6, x0                  // K dimension predicate
    b.first Loop_K                        // k % 2 != 0 right

    add     x4, x4, x17, lsl #3           // &packb += 2*ceil(kc/2)* 4 * SVLh fp16
    addvl   x2, x2, #4                    // &XB += 4 * SVLb 
    whilelt pn8.b, x2, x8, vlx4           // N dimension predicate
    b.first Loop_N

    smstop

    ret