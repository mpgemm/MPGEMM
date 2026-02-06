    .text
    .global _col_packb

_col_packb:  
// x0:kc, x1:nc, x2:matright, x3:ldb, x4:packB
    stp     x19, x20, [sp, #-32]! 
    stp     x21, x22, [sp, #16]

    smstart

    cntw    x5                      // SVLs
    mul     x11, x5, x3             //SVLs*ldb
    mul     x21, x5, x0             //SVLs*KC

    lsl     x14, x3, #1             // 2*ldb
    add     x15, x14, x3            // 3*ldb          
 
    mul     x16, x5, x5             // SVLs*SVLs
    lsl     x19, x16, #1            // 2*SVLs*SVLs
    add     x20, x19, x16            // 3*SVLs*SVLs
     
    mov     x7, #0
    whilelt p0.s, x7, x1            // Tile predicate (N dimension)
 
LOOP_NC:
    mov     x8, x2                  // matRight load base address
    mov     x9, x4                  // matRight_mod store base address
    add     x5, x2, x0, lsl #2
 
    add     x10, x9 , x21, lsl #2   // 32b Tile0 store predicate condition
    sub     x13, x10, x16, lsl #2   // 32b Tile1 store predicate condition
    sub     x17, x10, x19, lsl #2   // 32b Tile2 store predicate condition
    sub     x22, x10, x20, lsl #2   // 32b Tile3 store predicate condition

    whilelt pn8.b, x8, x5, vlx4     // Tile predicate-as-counter (K dimension)
     
LOOP_KC:
    mov     x6, x8                  // matRight
    
    mov     w12, #0                 // Load_loop counter
    psel    pn10, pn8, p0.s[w12, 0]
    psel    pn11, pn8, p0.s[w12, 1]
    psel    pn12, pn8, p0.s[w12, 2]
    psel    pn13, pn8, p0.s[w12, 3]
    ld1w    {z0.s, z4.s, z8.s, z12.s}, pn10/z, [x6]               // matRight
    ld1w    {z1.s, z5.s, z9.s, z13.s}, pn11/z, [x6, x3, lsl #2]   // matRight + ldb
    ld1w    {z2.s, z6.s, z10.s, z14.s}, pn12/z, [x6, x14, lsl #2]  // matRight + ldb*2
    ld1w    {z3.s, z7.s, z11.s, z15.s}, pn13/z, [x6, x15, lsl #2]  // matRight + ldb*3
    mova    za0v.s[w12,0:3], {z0.s-z3.s}
    mova    za1v.s[w12,0:3], {z4.s-z7.s}
    mova    za2v.s[w12,0:3], {z8.s-z11.s}
    mova    za3v.s[w12,0:3], {z12.s-z15.s}

    add     x6, x6, x3, lsl #4      //matRight+= 4*ldb
    add     w12, w12, #4            // Increment counter

    psel    pn10, pn8, p0.s[w12, 0]
    psel    pn11, pn8, p0.s[w12, 1]
    psel    pn12, pn8, p0.s[w12, 2]
    psel    pn13, pn8, p0.s[w12, 3]
    ld1w    {z16.s, z20.s, z24.s, z28.s}, pn10/z, [x6]               // matRight + 4*ldb
    ld1w    {z17.s, z21.s, z25.s, z29.s}, pn11/z, [x6, x3, lsl #2]   // matRight + 5*ldb
    ld1w    {z18.s, z22.s, z26.s, z30.s}, pn12/z, [x6, x14, lsl #2]  // matRight + ldb*6
    ld1w    {z19.s, z23.s, z27.s, z31.s}, pn13/z, [x6, x15, lsl #2]  // matRight + ldb*7
    mova    za0v.s[w12,0:3], {z16.s-z19.s}
    mova    za1v.s[w12,0:3], {z20.s-z23.s}
    mova    za2v.s[w12,0:3], {z24.s-z27.s}
    mova    za3v.s[w12,0:3], {z28.s-z31.s}

    add     x6, x6, x3, lsl #4      //matRight+= 4*ldb
    add     w12, w12, #4            // Increment counter

//------------------------------------------------------------- 
    psel    pn10, pn8, p0.s[w12, 0]
    psel    pn11, pn8, p0.s[w12, 1]
    psel    pn12, pn8, p0.s[w12, 2]
    psel    pn13, pn8, p0.s[w12, 3]
    ld1w    {z0.s, z4.s, z8.s, z12.s}, pn10/z, [x6]               // matRight
    ld1w    {z1.s, z5.s, z9.s, z13.s}, pn11/z, [x6, x3, lsl #2]   // matRight + ldb
    ld1w    {z2.s, z6.s, z10.s, z14.s}, pn12/z, [x6, x14, lsl #2]  // matRight + ldb*2
    ld1w    {z3.s, z7.s, z11.s, z15.s}, pn13/z, [x6, x15, lsl #2]  // matRight + ldb*3
    mova    za0v.s[w12,0:3], {z0.s-z3.s}
    mova    za1v.s[w12,0:3], {z4.s-z7.s}
    mova    za2v.s[w12,0:3], {z8.s-z11.s}
    mova    za3v.s[w12,0:3], {z12.s-z15.s}

    add     x6, x6, x3, lsl #4      //matRight+= 4*ldb
    add     w12, w12, #4            // Increment counter


    psel    pn10, pn8, p0.s[w12, 0]
    psel    pn11, pn8, p0.s[w12, 1]
    psel    pn12, pn8, p0.s[w12, 2]
    psel    pn13, pn8, p0.s[w12, 3]
    ld1w    {z16.s, z20.s, z24.s, z28.s}, pn10/z, [x6]               // matRight + 4*ldb
    ld1w    {z17.s, z21.s, z25.s, z29.s}, pn11/z, [x6, x3, lsl #2]   // matRight + 5*ldb
    ld1w    {z18.s, z22.s, z26.s, z30.s}, pn12/z, [x6, x14, lsl #2]  // matRight + ldb*6
    ld1w    {z19.s, z23.s, z27.s, z31.s}, pn13/z, [x6, x15, lsl #2]  // matRight + ldb*7
    mova    za0v.s[w12,0:3], {z16.s-z19.s}
    mova    za1v.s[w12,0:3], {z20.s-z23.s}
    mova    za2v.s[w12,0:3], {z24.s-z27.s}
    mova    za3v.s[w12,0:3], {z28.s-z31.s}

    //add     x6, x6, x4, lsl #4      //matRight+= 4*ldb
    //add     w12, w12, #4            // Increment counter

    mov     w12, #0                 // Store_loop counter

//------------STORE packB-----------------     

    whilelt pn10.b, x9, x10, vlx4
    whilelt pn11.b, x9, x13, vlx4
    whilelt pn12.b, x9, x17, vlx4
    whilelt pn13.b, x9, x22, vlx4

    mova    {z0.s-z3.s}, za0h.s[w12, 0:3]
    mova    {z4.s-z7.s}, za1h.s[w12, 0:3]    
    mova    {z8.s-z11.s}, za2h.s[w12, 0:3]
    mova    {z12.s-z15.s}, za3h.s[w12, 0:3]
    st1w    {z0.s-z3.s}, pn10, [x9] // Store 4 row vectors to matRight_mod
    st1w    {z4.s-z7.s}, pn11, [x9, x16, lsl #2]  // matRight_mod+SVLs*SVLs
    st1w    {z8.s-z11.s}, pn12, [x9, x19, lsl #2]  // matRight_mod+SVLs*SVLs*2
    st1w    {z12.s-z15.s}, pn13, [x9, x20, lsl #2]  // matRight_mod+SVLs*SVLs*3

    addvl   x9, x9, #4              // matLeft_mod += 4*SVLb (bytes)
    add     w12, w12, #4            // Increment counter

    whilelt pn10.b, x9, x10, vlx4
    whilelt pn11.b, x9, x13, vlx4
    whilelt pn12.b, x9, x17, vlx4
    whilelt pn13.b, x9, x22, vlx4

    mova    {z0.s-z3.s}, za0h.s[w12, 0:3]
    mova    {z4.s-z7.s}, za1h.s[w12, 0:3]    
    mova    {z8.s-z11.s}, za2h.s[w12, 0:3]
    mova    {z12.s-z15.s}, za3h.s[w12, 0:3]
    st1w    {z0.s-z3.s}, pn10, [x9] // Store 4 row vectors to matRight_mod
    st1w    {z4.s-z7.s}, pn11, [x9, x16, lsl #2]  // matRight_mod+SVLs*SVLs
    st1w    {z8.s-z11.s}, pn12, [x9, x19, lsl #2]  // matRight_mod+SVLs*SVLs*2
    st1w    {z12.s-z15.s}, pn13, [x9, x20, lsl #2]  // matRight_mod+SVLs*SVLs*3

    addvl   x9, x9, #4              // matLeft_mod += 4*SVLb (bytes)
    add     w12, w12, #4            // Increment counter

    whilelt pn10.b, x9, x10, vlx4
    whilelt pn11.b, x9, x13, vlx4
    whilelt pn12.b, x9, x17, vlx4
    whilelt pn13.b, x9, x22, vlx4

    mova    {z0.s-z3.s}, za0h.s[w12, 0:3]
    mova    {z4.s-z7.s}, za1h.s[w12, 0:3]    
    mova    {z8.s-z11.s}, za2h.s[w12, 0:3]
    mova    {z12.s-z15.s}, za3h.s[w12, 0:3]
    st1w    {z0.s-z3.s}, pn10, [x9] // Store 4 row vectors to matRight_mod
    st1w    {z4.s-z7.s}, pn11, [x9, x16, lsl #2]  // matRight_mod+SVLs*SVLs
    st1w    {z8.s-z11.s}, pn12, [x9, x19, lsl #2]  // matRight_mod+SVLs*SVLs*2
    st1w    {z12.s-z15.s}, pn13, [x9, x20, lsl #2]  // matRight_mod+SVLs*SVLs*3

    addvl   x9, x9, #4              // matLeft_mod += 4*SVLb (bytes)
    add     w12, w12, #4            // Increment counter

    whilelt pn10.b, x9, x10, vlx4
    whilelt pn11.b, x9, x13, vlx4
    whilelt pn12.b, x9, x17, vlx4
    whilelt pn13.b, x9, x22, vlx4

    mova    {z0.s-z3.s}, za0h.s[w12, 0:3]
    mova    {z4.s-z7.s}, za1h.s[w12, 0:3]    
    mova    {z8.s-z11.s}, za2h.s[w12, 0:3]
    mova    {z12.s-z15.s}, za3h.s[w12, 0:3]
    st1w    {z0.s-z3.s}, pn10, [x9] // Store 4 row vectors to matRight_mod
    st1w    {z4.s-z7.s}, pn11, [x9, x16, lsl #2]  // matRight_mod+SVLs*SVLs
    st1w    {z8.s-z11.s}, pn12, [x9, x19, lsl #2]  // matRight_mod+SVLs*SVLs*2
    st1w    {z12.s-z15.s}, pn13, [x9, x20, lsl #2]  // matRight_mod+SVLs*SVLs*3

    addvl   x9, x9, #4              // packb += 4*SVLb (bytes)

//-------------------------------------------
    add     x9, x9, x20, lsl #2     // matRight_mod+= SVLs*SVLs*3 FP32 elms (bytes)

    addvl   x8, x8, #4              // matRight += 4*SVLb (bytes)
    whilelt pn8.b, x8, x5, vlx4
    b.first LOOP_KC
 
    add     x4, x4, x21, lsl #2     // packb += SVLs*KC FP32 elms (bytes)
    add     x2, x2, x11, lsl #2     // matright += SVLs*ldb FP32 elms (bytes)
    incw    x7
    whilelt p0.s, x7, x1
    b.first LOOP_NC

    smstop

     
    ldp     x21, x22, [sp, #16]
    ldp     x19, x20, [sp], #32
     
    ret