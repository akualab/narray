
// func divSlice(out []float64, a []float64, b []float64) 
TEXT    ·divSlice(SB), 7, $0
    MOVQ    out(FP),SI      // SI: &out
    MOVQ    out+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11    // R11: &a
    MOVQ    b+48(FP),R9     // R9: &b
    MOVQ    DX, R10         // R10: len(out)
    SHRQ    $2, DX          // DX: len(out) / 4
    ANDQ    $3, R10         // R10: len(out) % 4
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
TEXT    ·mulSlice(SB), 7, $0
    MOVQ    out(FP),SI      // SI: &out
    MOVQ    out+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11    // R11: &a
    MOVQ    b+48(FP),R9     // R9: &b
    MOVQ    DX, R10         // R10: len(out)
    SHRQ    $2, DX          // DX: len(out) / 4
    ANDQ    $3, R10         // R10: len(out) % 4
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


// func cdivSlice(out []float64, a []float64, c float64) 
TEXT    ·cdivSlice(SB), 7, $0
    MOVQ    out(FP),SI      // SI: &out
    MOVQ    out+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11    // R11: &a
    MOVSD   b+48(FP),X4     // X4: c
    MOVQ    DX, R10         // R10: len(out)
    SHRQ    $2, DX          // DX: len(out) / 4
    ANDQ    $3, R10         // R10: len(out) % 4
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
TEXT    ·cmulSlice(SB), 7, $0
    MOVQ    out(FP),SI      // SI: &out
    MOVQ    out+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11    // R11: &a
    MOVSD   b+48(FP),X4     // X4: c
    MOVQ    DX, R10         // R10: len(out)
    SHRQ    $2, DX          // DX: len(out) / 4
    ANDQ    $3, R10         // R10: len(out) % 4
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
