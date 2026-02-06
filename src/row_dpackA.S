    .text
    .global _row_dpacka

_row_dpacka:  
// x0:mc, x1:kc, x2:matleft, x3:lda(k), x4:packa
    stp     x19, x20, [sp, #-48]! 
    stp     x21, x22, [sp, #16]
    stp     x23, x24, [sp, #32]

    smstart

    cntd    x5                       // SVLd
    
    mul     x11, x5, x3              // SVLd*lda

    mul     x24, x5, x1              // SVLd*kc
    
    lsl     x16, x3, #1              // 2*lda
    add     x17, x16, x3             // 3*lda

    mul     x14, x5, x5               // SVLd*SVLd
    lsl     x19, x14, #1              // 2*SVLd*SVLd
    add     x20, x19, x14             // 3*SVLd*SVLd
    
    mov     x8, #0                   // Loop_M counter
    whilelt p0.d, x8, x0             // M dimension predicate

Loop_M:
    mov     x7, x4                   // packa
    mov     x10, x2                  // XA

    add     x15, x7 , x24, lsl #3   // 64b Tile0 store predicate condition
    sub     x21, x15, x14, lsl #3   // 64b Tile1 store predicate condition
    sub     x22, x15, x19, lsl #3   // 64b Tile2 store predicate condition
    sub     x23, x15, x20, lsl #3   // 64b Tile3 store predicate condition

    mov     x9, #0                   // Loop_K counter
    whilelt pn8.d, x9, x1, vlx4      // K dimension predicate-as-counter

Loop_K:
    mov     x6, x10                  // XA_ptr -> load
    mov     w12, #0                  // Loop_load counter
    mov     w13, #0

Loop_load:
    psel    pn10, pn8, p0.d[w12, #0]
    psel    pn11, pn8, p0.d[w12, #1]
    ld1d    {z0.d,z4.d,z8.d,z12.d}, pn10/z, [x6]      // a_ptr      
    ld1d    {z1.d,z5.d,z9.d,z13.d}, pn11/z, [x6, x3, lsl #3]  // a_ptr + lda

    add     w12, w12, #2
    psel    pn12, pn8, p0.d[w12, #0]
    psel    pn13, pn8, p0.d[w12, #1]
    ld1d    {z2.d,z6.d,z10.d,z14.d}, pn12/z, [x6, x16, lsl #3] // a_ptr + lda*2
    ld1d    {z3.d,z7.d,z11.d,z15.d}, pn13/z, [x6, x17, lsl #3] // a_ptr + lda*3

    mova    za0h.d[w13, 0:3], {z0.d-z3.d}       
    mova    za1h.d[w13, 0:3], {z4.d-z7.d}      
    mova    za2h.d[w13, 0:3], {z8.d-z11.d}      
    mova    za3h.d[w13, 0:3], {z12.d-z15.d}     

    add     w12, w12, #2                  // Loop_load counter increment
    add     w13, w13, #4
    add     x6, x6, x3, lsl #5            // a_ptr += 4*lda fp64 elems 

    cmp     w12, w5     //8
    b.mi    Loop_load

    mov     w12, #0                         // Loop_store counter
Loop_store:
    whilelt pn10.d, x7, x15, vlx4
    whilelt pn11.d, x7, x21, vlx4
    whilelt pn12.d, x7, x22, vlx4
    whilelt pn13.d, x7, x23, vlx4
  
    mova    {z0.d-z3.d}, za0v.d[w12, 0:3]
    mova    {z4.d-z7.d}, za1v.d[w12, 0:3]
    mova    {z8.d-z11.d}, za2v.d[w12, 0:3]
    mova    {z12.d-z15.d}, za3v.d[w12, 0:3]

    st1d    {z0.d-z3.d}, pn10, [x7]                 // packa
    st1d    {z4.d-z7.d}, pn11, [x7, x14, lsl #3]    // packa + svld*svld
    st1d    {z8.d-z11.d}, pn12, [x7, x19, lsl #3]   // packa + 2*svld*svld
    st1d    {z12.d-z15.d}, pn13, [x7, x20, lsl #3]  // packa + 3*svld*svld
    
    addvl   x7, x7, #4           // packa += 4 * SVLd fp64 elems
    add     w12, w12, #4  
    cmp     w12, w5
    b.mi    Loop_store

    addvl   x10, x10, #4          // a_base += 4*SVLd f64 elems
    add     x7, x7, x20, lsl #3   // packa += 3*SVLd*SVLd fp64 elems
    
    add     x9, x9, #32
    whilelt pn8.d, x9, x1, vlx4   // K dimension predicate-as-counter
    b.first Loop_K
 

    add     x2, x2, x11, lsl #3           // &a += SVLd*lda fp64 elems
    add     x4, x4, x24, lsl #3           // &packa += SVLd*kc fp64 elems
    incd    x8
    whilelt p0.d, x8, x0
    b.first Loop_M

    smstop                    

    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #48
     
    ret