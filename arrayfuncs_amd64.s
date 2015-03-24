
// func divSlice(out []float64, a []float64, b []float64) 
TEXT ·divSlice(SB), 7, $0
    MOVQ    out+0(FP),SI        // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_div
loopback_div:
    MOVUPD  (R11),X0
    MOVUPD  (R9),X1
    DIVPD   X1,X0
    MOVUPD  16(R11),X2
    MOVUPD  16(R9),X3
    DIVPD   X3,X2
    MOVUPD  X0,(SI)
    MOVUPD  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_div
remain_div:
    CMPQ    R10,$0
    JEQ     done_div
onemore_div:    
    MOVSD   (R11),X0
    MOVSD   (R9),X1
    DIVSD   X1,X0
    MOVSD   X0,(SI)
    ADDQ    $8, R11
    ADDQ    $8, R9
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_div
done_div:
    RET ,



// func mulSlice(out []float64, a []float64, b []float64) 
TEXT ·mulSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_mul
loopback_mul:
    MOVUPD  (R11),X0
    MOVUPD  (R9),X1
    MULPD   X1,X0
    MOVUPD  16(R11),X2
    MOVUPD  16(R9),X3
    MULPD   X3,X2
    MOVUPD  X0,(SI)
    MOVUPD  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_mul
remain_mul:
    CMPQ    R10,$0
    JEQ     done_mul
onemore_mul:    
    MOVSD   (R11),X0
    MOVSD   (R9),X1
    MULSD   X1,X0
    MOVSD   X0,(SI)
    ADDQ    $8, R11
    ADDQ    $8, R9
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_mul
done_mul:   
    RET ,


// func addSlice(out []float64, a []float64, b []float64) 
TEXT ·addSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_add
loopback_add:
    MOVUPD  (R11),X0
    MOVUPD  (R9),X1
    ADDPD   X1,X0
    MOVUPD  16(R11),X2
    MOVUPD  16(R9),X3
    ADDPD   X3,X2
    MOVUPD  X0,(SI)
    MOVUPD  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_add
remain_add:
    CMPQ    R10,$0
    JEQ     done_add
onemore_add:    
    MOVSD   (R11),X0
    MOVSD   (R9),X1
    ADDSD   X1,X0
    MOVSD   X0,(SI)
    ADDQ    $8, R11
    ADDQ    $8, R9
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_add
done_add:   
    RET ,

// func minSlice(out []float64, a []float64, b []float64) 
TEXT ·minSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_min
loopback_min:
    MOVUPD  (R11),X0
    MOVUPD  (R9),X1
    MINPD   X1,X0
    MOVUPD  16(R11),X2
    MOVUPD  16(R9),X3
    MINPD   X3,X2
    MOVUPD  X0,(SI)
    MOVUPD  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_min
remain_min:
    CMPQ    R10,$0
    JEQ     done_min
onemore_min:    
    MOVSD   (R11),X0
    MOVSD   (R9),X1
    MINSD   X1,X0
    MOVSD   X0,(SI)
    ADDQ    $8, R11
    ADDQ    $8, R9
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_min
done_min:   
    RET ,

// func maxSlice(out []float64, a []float64, b []float64) 
TEXT ·maxSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_max
loopback_max:
    MOVUPD  (R11),X0
    MOVUPD  (R9),X1
    MAXPD   X1,X0
    MOVUPD  16(R11),X2
    MOVUPD  16(R9),X3
    MAXPD   X3,X2
    MOVUPD  X0,(SI)
    MOVUPD  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_max
remain_max:
    CMPQ    R10,$0
    JEQ     done_max
onemore_max:    
    MOVSD   (R11),X0
    MOVSD   (R9),X1
    MAXSD   X1,X0
    MOVSD   X0,(SI)
    ADDQ    $8, R11
    ADDQ    $8, R9
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_max
done_max:   
    RET ,

// func cdivSlice(out []float64, a []float64, c float64) 
TEXT ·cdivSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVSD   c+48(FP),X4         // X4: c
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_cdiv
    UNPCKLPD X4, X4
loopback_cdiv:
    MOVAPD  X4, X1
    MOVAPD  X4, X3
    MOVUPD  (R11),X0
    DIVPD   X0,X1
    MOVUPD  16(R11),X2
    DIVPD   X2,X3
    MOVUPD  X1,(SI)
    MOVUPD  X3,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_cdiv
remain_cdiv:
    CMPQ    R10,$0
    JEQ     done_cdiv
onemore_cdiv:   
    MOVAPD  X4, X1
    MOVSD   (R11),X0
    DIVSD   X0,X1
    MOVSD   X1,(SI)
    ADDQ    $8, R11
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_cdiv
done_cdiv:  
    RET ,


// func cmulSlice(out []float64, a []float64, c float64) 
TEXT ·cmulSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVSD   c+48(FP),X4         // X4: c
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_cmul
    UNPCKLPD X4, X4
loopback_cmul:
    MOVUPD  (R11),X0
    MULPD   X4,X0
    MOVUPD  16(R11),X2
    MULPD   X4,X2
    MOVUPD  X0,(SI)
    MOVUPD  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_cmul
remain_cmul:
    CMPQ    R10,$0
    JEQ     done_cmul
onemore_cmul:   
    MOVSD   (R11),X0
    MULSD   X4,X0
    MOVSD   X0,(SI)
    ADDQ    $8, R11
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_cmul
done_cmul:  
    RET ,


// func caddSlice(out []float64, a []float64, c float64) 
TEXT ·caddSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVSD   c+48(FP),X4         // X4: c
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_cadd
    UNPCKLPD X4, X4
loopback_cadd:
    MOVUPD  (R11),X0
    ADDPD   X4,X0
    MOVUPD  16(R11),X2
    ADDPD   X4,X2
    MOVUPD  X0,(SI)
    MOVUPD  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_cadd
remain_cadd:
    CMPQ    R10,$0
    JEQ     done_cadd
onemore_cadd:   
    MOVSD   (R11),X0
    ADDSD   X4,X0
    MOVSD   X0,(SI)
    ADDQ    $8, R11
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_cadd
done_cadd:  
    RET ,

// func sqrtSlice(out []float64, a []float64) 
TEXT ·sqrtSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $2, DX              // DX: len(out) / 4
    ANDQ    $3, R10             // R10: len(out) % 4
    CMPQ    DX ,$0
    JEQ     remain_sqrt
loopback_sqrt:
    MOVUPD  (R11),X0
    SQRTPD  X0,X0
    MOVUPD  16(R11),X2
    SQRTPD  X2,X2
    MOVUPD  X0,(SI)
    MOVUPD  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_sqrt
remain_sqrt:
    CMPQ    R10,$0
    JEQ     done_sqrt
onemore_sqrt:   
    MOVSD   (R11),X0
    SQRTSD  X0,X0
    MOVSD   X0,(SI)
    ADDQ    $8, R11
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     onemore_sqrt
done_sqrt:  
    RET ,


// func minSliceElement(a []float64) float64
TEXT ·minSliceElement(SB), 7, $0
    MOVQ    a(FP),SI          // SI: &a
    MOVQ    a_len+8(FP),DX    // DX: len(a)
    MOVSD   (SI), X0          // Initial value
    ADDQ    $8, SI
    SUBQ    $1, DX

    UNPCKLPD X0, X0
    MOVQ    DX, R10             // R10: len(out) -1
    SHRQ    $2, DX              // DX: (len(out) - 1) / 4
    ANDQ    $3, R10             // R10: (len(out) -1 ) % 4
    MOVAPD  X0, X1
    CMPQ    DX ,$0
    JEQ     remain_min_e
next_min_e:
    MOVUPD  (SI), X2
    MOVUPD  16(SI), X3
    MINPD   X2, X0
    MINPD   X3, X1
    ADDQ    $32, SI
    SUBQ    $1, DX
    JNZ next_min_e
    CMPQ    R10, $0
    JZ      done_min_e
remain_min_e:
    MOVSD   (SI), X2
    MINSD   X2, X0
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     remain_min_e
done_min_e:    
    MINPD   X1, X0
    MOVAPD  X0, X2
    UNPCKHPD X0, X2
    MINSD   X2, X0
    MOVSD X0, ret+24(FP)
    RET ,


// func maxSliceElement(a []float64) float64
TEXT ·maxSliceElement(SB), 7, $0
    MOVQ    a(FP),SI          // SI: &a
    MOVQ    a_len+8(FP),DX    // DX: len(a)
    MOVSD   (SI), X0          // Initial value
    ADDQ    $8, SI
    SUBQ    $1, DX

    UNPCKLPD X0, X0
    MOVQ    DX, R10             // R10: len(out) -1
    SHRQ    $2, DX              // DX: (len(out) - 1) / 4
    ANDQ    $3, R10             // R10: (len(out) -1 ) % 4
    MOVAPD  X0, X1
    CMPQ    DX ,$0
    JEQ     remain_max_e
next_max_e:
    MOVUPD  (SI), X2
    MOVUPD  16(SI), X3
    MAXPD   X2, X0
    MAXPD   X3, X1
    ADDQ    $32, SI
    SUBQ    $1, DX
    JNZ next_max_e
    CMPQ    R10, $0
    JZ      done_max_e
remain_max_e:
    MOVSD   (SI), X2
    MAXSD   X2, X0
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     remain_max_e
done_max_e:    
    MAXPD   X1, X0
    MOVAPD  X0, X2
    UNPCKHPD X0, X2
    MAXSD   X2, X0
    MOVSD X0, ret+24(FP)
    RET ,



// func sliceSum(a []float64) float64
TEXT ·sliceSum(SB), 7, $0
    MOVQ    a(FP),SI          // SI: &a
    MOVQ    a_len+8(FP),DX    // DX: len(a)
    XORPD   X0, X0            // Initial value
    XORPD   X1, X1            // Initial value

    MOVQ    DX, R10             // R10: len(out) -1
    SHRQ    $2, DX              // DX: (len(out) - 1) / 4
    ANDQ    $3, R10             // R10: (len(out) -1 ) % 4
    CMPQ    DX ,$0
    JEQ     remain_sum
next_sum:
    MOVUPD  (SI), X2
    MOVUPD  16(SI), X3
    ADDPD   X2, X0
    ADDPD   X3, X1
    ADDQ    $32, SI
    SUBQ    $1, DX
    JNZ     next_sum
    CMPQ    R10, $0
    JZ      done_sum
remain_sum:
    MOVSD   (SI), X2
    ADDSD   X2, X0
    ADDQ    $8, SI
    SUBQ    $1, R10
    JNZ     remain_sum
done_sum:    
    ADDPD   X1, X0
    MOVAPD  X0, X2
    UNPCKHPD X0, X2
    ADDSD   X2, X0
    MOVSD   X0, ret+24(FP)
    RET ,
