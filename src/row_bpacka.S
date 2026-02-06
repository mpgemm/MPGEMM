    .text
    .global _row_bpacka

_row_bpacka:  
// x0:mc, x1:kc, x2:matleft, x3:lda(K), x4:packa
    stp     x19, x20, [sp, #-48]! 
    stp     x21, x22, [sp, #16]
    stp     x23, x24, [sp, #32]

    smstart

    cntw    x5                       // SVLs

    mul     x11, x5, x3              // SVLs*lda

    lsl     x21, x3, #1              // 2*lda
    add     x22, x21, x3             // 3*lda

    add     x12, x1, #3
    lsr     x16, x12, #2             // ceil(kc/4)
    mul     x17, x16, x5             // SVLs*ceil(kc/4)
    lsl     x13, x17, #2             // SVLs*ceil(kc/4)*4

    mul     x14, x5, x5               // SVLs*SVLs
    lsl     x19, x14, #1              // 2*SVLs*SVLs
    add     x20, x19, x14             // 3*SVLs*SVLs

    mov     x8, #0                   // Loop_M counter
    whilelt p0.s, x8, x0             // M dimension predicate

Loop_M:
    mov     x7, x4                   // packa
    mov     x10, x2                  // XA

    add     x16, x7 , x13, lsl #2   // 32b Tile0 store predicate condition
    sub     x17, x16, x14, lsl #2   // 32b Tile1 store predicate condition
    sub     x23, x16, x19, lsl #2   // 32b Tile2 store predicate condition
    sub     x24, x16, x20, lsl #2   // 32b Tile3 store predicate condition

    add     x9, x2, x1              // Loop_K exit condition int8 bytes
    whilelt pn8.b, x2, x9, vlx4      // K dimension predicate-as-counter

Loop_K:
    mov     x6, x10                  // XA_ptr -> load
    mov     w12, #0                  // Loop_load counter
    mov     w15, #0
Loop_load:
    psel    pn10, pn8, p0.s[w15, #0]
    psel    pn11, pn8, p0.s[w15, #1]
    psel    pn12, pn8, p0.s[w15, #2]
    psel    pn13, pn8, p0.s[w15, #3]
    ld1b    {z0.b-z3.b}, pn10/z, [x6]      // a_ptr
    ld1b    {z4.b-z7.b}, pn11/z, [x6, x3]  // a_ptr + lda
    ld1b    {z8.b-z11.b}, pn12/z, [x6, x21] // a_ptr + 2*lda
    ld1b    {z12.b-z15.b}, pn13/z, [x6, x22] // a_ptr + 3*lda
    mova    za0h.b[w12, 0:3], {z0.b-z3.b}     //za0.s[0]-za3.s[0] 
    mova    za0h.b[w12, 4:7], {z4.b-z7.b}     //za0.s[1]-za3.s[1]
    mova    za0h.b[w12, 8:11], {z8.b-z11.b}   //za0.s[2]-za3.s[2]
    mova    za0h.b[w12, 12:15], {z12.b-z15.b}  //za0.s[3]-za3.s[3]

    add     w15, w15, #4                  // Loop_load counter increment
    add     w12, w12, #16
    add     x6, x6, x3, lsl #2            // a_ptr += 4*lda int8 elems 

    cmp     w15, w5
    b.mi    Loop_load


    mov     w12, #0                         // Loop_store counter

Loop_store:
    whilelt pn10.b, x7, x16, vlx4           // Tile0 
    whilelt pn11.b, x7, x17, vlx4           // Tile1 
    whilelt pn12.b, x7, x23, vlx4          // Tile2 
    whilelt pn13.b, x7, x24, vlx4          // Tile3 
    mova    {z0.s-z3.s}, za0v.s[w12, 0:3]
    mova    {z4.s-z7.s}, za1v.s[w12, 0:3]
    mova    {z8.s-z11.s}, za2v.s[w12, 0:3]
    mova    {z12.s-z15.s}, za3v.s[w12, 0:3]

    st1w    {z0.s-z3.s}, pn10, [x7]                 // matleft
    st1w    {z4.s-z7.s}, pn11, [x7, x14, lsl #2]    // matleft + svls*svls
    st1w    {z8.s-z11.s}, pn12, [x7, x19, lsl #2]  // matleft + 2*svls*svls
    st1w    {z12.s-z15.s}, pn13, [x7, x20, lsl #2] // matleft + 3*svls*svls
    
    addvl   x7, x7, #4           // a_mod += 4 * SVLs int32 elems
    add     w12, w12, #4  
    cmp     w12, w5
    b.mi    Loop_store


    addvl   x10, x10, #4          // a_base += 4*SVLb int8 elems
    add     x7, x7, x20, lsl #2   // a_mod += 3*SVLs*SVLs int32 elems
    
    whilelt pn8.b, x10, x9, vlx4  // K dimension predicate-as-counter
    b.first Loop_K
 
    add     x2, x2, x11            // &a += SVLs*lda int8 elems
    add     x4, x4, x13            // &a_mod += SVLs*ceil(kc/4)*4 int8 elems
    incw    x8
    whilelt p0.s, x8, x0
    b.first Loop_M

    smstop                    

    ldp     x23, x24, [sp, #32]
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #48
     
    ret