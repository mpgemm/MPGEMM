    .text
    .global _row_packa

_row_packa:  
// x0:mc, x1:kc, x2:matleft, x3:lda(k), x4:packa
    stp     x19, x20, [sp, #-48]! 
    stp     x21, x22, [sp, #16]
    stp     x23, x24, [sp, #32]

    smstart

    cntw    x5                          // SVLs
    
    mul     x11, x5, x3              // SVLs*lda

    mul     x13, x5, x1             // SVLs*kc
    

    lsl     x16, x3, #1              // 2*lda
    add     x17, x16, x3             // 3*lda

    mul     x14, x5, x5               // SVLs*SVLs
    lsl     x19, x14, #1              // 2*SVLs*SVLs
    add     x20, x19, x14             // 3*SVLs*SVLs
    
    mov     x8, #0                   // Loop_M counter
    whilelt p0.s, x8, x0             // M dimension predicate

Loop_M:
    mov     x7, x4                   // packa
    mov     x10, x2                  // XA


    add     x15, x7 , x13, lsl #2   // 32b Tile0 store predicate condition
    sub     x21, x15, x14, lsl #2   // 32b Tile1 store predicate condition
    sub     x22, x15, x19, lsl #2   // 32b Tile2 store predicate condition
    sub     x23, x15, x20, lsl #2   // 32b Tile3 store predicate condition


    add     x9, x2, x1, lsl #2       // Loop_K exit condition fp32 bytes
    whilelt pn8.b, x10, x9, vlx4      // K dimension predicate-as-counter

Loop_K:
    mov     x6, x10                  // XA_ptr -> load
    mov     w12, #0                  // Loop_load counter

Loop_load:
    psel    pn10, pn8, p0.s[w12, #0]
    psel    pn11, pn8, p0.s[w12, #1]
    psel    pn12, pn8, p0.s[w12, #2]
    psel    pn13, pn8, p0.s[w12, #3]
    ld1w    {z0.s,z4.s,z8.s,z12.s}, pn10/z, [x6]      // a_ptr
    ld1w    {z1.s,z5.s,z9.s,z13.s}, pn11/z, [x6, x3, lsl #2]  // a_ptr + lda
    ld1w    {z2.s,z6.s,z10.s,z14.s}, pn12/z, [x6, x16, lsl #2] // a_ptr + lda*2
    ld1w    {z3.s,z7.s,z11.s,z15.s}, pn13/z, [x6, x17, lsl #2] // a_ptr + lda*3
    mova    za0h.s[w12, 0:3], {z0.s-z3.s} 
    mova    za1h.s[w12, 0:3], {z4.s-z7.s}
    mova    za2h.s[w12, 0:3], {z8.s-z11.s}
    mova    za3h.s[w12, 0:3], {z12.s-z15.s}


    add     w12, w12, #4                  // Loop_load counter increment
    add     x6, x6, x3, lsl #4            // a_ptr += 4*lda fp32 elems 

    cmp     w12, w5
    b.mi    Loop_load


    mov     w12, #0                         // Loop_store counter
Loop_store:
    whilelt pn10.b, x7, x15, vlx4
    whilelt pn11.b, x7, x21, vlx4
    whilelt pn12.b, x7, x22, vlx4
    whilelt pn13.b, x7, x23, vlx4
  
    mova    {z0.s-z3.s}, za0v.s[w12, 0:3]
    mova    {z4.s-z7.s}, za1v.s[w12, 0:3]
    mova    {z8.s-z11.s}, za2v.s[w12, 0:3]
    mova    {z12.s-z15.s}, za3v.s[w12, 0:3]

    st1w    {z0.s-z3.s}, pn10, [x7]                 // packa
    st1w    {z4.s-z7.s}, pn11, [x7, x14, lsl #2]    // packa + svls*svls
    st1w    {z8.s-z11.s}, pn12, [x7, x19, lsl #2]   // packa + 2*svls*svls
    st1w    {z12.s-z15.s}, pn13, [x7, x20, lsl #2]  // packa + 3*svls*svls
    
    addvl   x7, x7, #4           // packa += 4 * SVLs fp32 elems
    add     w12, w12, #4  
    cmp     w12, w5
    b.mi    Loop_store


    addvl   x10, x10, #4          // a_base += 4*SVLb fp32 elems
    add     x7, x7, x20, lsl #2   // packa += 3*SVLs*SVLs fp32 elems
    
    whilelt pn8.b, x10, x9, vlx4  // K dimension predicate-as-counter
    b.first Loop_K
 
    add     x2, x2, x11, lsl #2           // &a += SVLs*lda fp32 elems
    add     x4, x4, x13, lsl #2           // &packa += SVLs*kc fp32 elems
    incw    x8
    whilelt p0.s, x8, x0
    b.first Loop_M

    smstop                    

    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #48
     
    ret