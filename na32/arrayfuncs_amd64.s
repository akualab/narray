
// func divSlice(out []float32, a []float32, b []float32)
TEXT ·divSlice(SB), 7, $0
    MOVQ    out+0(FP),SI        // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_div
loopback_div:
    MOVUPS  (R11),X0
    MOVUPS  (R9),X1
    DIVPS   X1,X0
    MOVUPS  16(R11),X2
    MOVUPS  16(R9),X3
    DIVPS   X3,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_div
remain_div:
    CMPQ    R10,$0
    JEQ     done_div
onemore_div:
    MOVSS   (R11),X0
    MOVSS   (R9),X1
    DIVSS   X1,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, R9
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_div
done_div:
    RET ,



// func mulSlice(out []float32, a []float32, b []float32)
TEXT ·mulSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_mul
loopback_mul:
    MOVUPS  (R11),X0
    MOVUPS  (R9),X1
    MULPS   X1,X0
    MOVUPS  16(R11),X2
    MOVUPS  16(R9),X3
    MULPS   X3,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_mul
remain_mul:
    CMPQ    R10,$0
    JEQ     done_mul
onemore_mul:
    MOVSS   (R11),X0
    MOVSS   (R9),X1
    MULSS   X1,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, R9
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_mul
done_mul:
    RET ,


// func addSlice(out []float32, a []float32, b []float32)
TEXT ·addSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_add
loopback_add:
    MOVUPS  (R11),X0
    MOVUPS  (R9),X1
    ADDPS   X1,X0
    MOVUPS  16(R11),X2
    MOVUPS  16(R9),X3
    ADDPS   X3,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_add
remain_add:
    CMPQ    R10,$0
    JEQ     done_add
onemore_add:
    MOVSS   (R11),X0
    MOVSS   (R9),X1
    ADDSS   X1,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, R9
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_add
done_add:
    RET ,

// func subSlice(out []float32, a []float32, b []float32)
TEXT ·subSlice(SB), 7, $0
    MOVQ    out+0(FP),SI        // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_sub
loopback_sub:
    MOVUPS  (R11),X0
    MOVUPS  (R9),X1
    SUBPS   X1,X0
    MOVUPS  16(R11),X2
    MOVUPS  16(R9),X3
    SUBPS   X3,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_sub
remain_sub:
    CMPQ    R10,$0
    JEQ     done_sub
onemore_sub:
    MOVSS   (R11),X0
    MOVSS   (R9),X1
    SUBSS   X1,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, R9
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_sub
done_sub:
    RET ,

// func minSlice(out []float32, a []float32, b []float32)
TEXT ·minSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_min
loopback_min:
    MOVUPS  (R11),X0
    MOVUPS  (R9),X1
    MINPS   X1,X0
    MOVUPS  16(R11),X2
    MOVUPS  16(R9),X3
    MINPS   X3,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_min
remain_min:
    CMPQ    R10,$0
    JEQ     done_min
onemore_min:
    MOVSS   (R11),X0
    MOVSS   (R9),X1
    MINSS   X1,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, R9
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_min
done_min:
    RET ,

// func maxSlice(out []float32, a []float32, b []float32)
TEXT ·maxSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_max
loopback_max:
    MOVUPS  (R11),X0
    MOVUPS  (R9),X1
    MAXPS   X1,X0
    MOVUPS  16(R11),X2
    MOVUPS  16(R9),X3
    MAXPS   X3,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_max
remain_max:
    CMPQ    R10,$0
    JEQ     done_max
onemore_max:
    MOVSS   (R11),X0
    MOVSS   (R9),X1
    MAXSS   X1,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, R9
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_max
done_max:
    RET ,


// func csignSlice(out []float64, a []float64, b []float64)
TEXT ·csignSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    b+48(FP),R9         // R9: &b
    MOVQ    DX, R10             // R10: len(out)
    MOVQ    $(1<<63), BX
    MOVQ    BX, X4             // X4: Sign
    SHUFPS  $0, X4, X4
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_csign
loopback_csign:
    MOVAPS  X4, X5
    MOVAPS  X4, X6
    MOVUPS  (R11),X0
    MOVUPS  (R9),X1
    MOVUPS  16(R11),X2
    MOVUPS  16(R9),X3
    ANDNPS  X0, X5
    ANDPS   X4, X1
    ORPS    X5, X1

    ANDNPS  X2, X6
    ANDPS   X4, X3
    ORPS    X6, X3
    MOVUPS  X1,(SI)
    MOVUPS  X3,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, R9
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_csign
remain_csign:
    CMPQ    R10,$0
    JEQ     done_csign
onemore_csign:
    MOVSS   X4, X5
    MOVSS   (R11),X0
    MOVSS   (R9),X1
    ANDNPS  X0, X5
    ANDPS   X4, X1
    ORPS    X5, X1
    MOVSS   X1,(SI)
    ADDQ    $4, R11
    ADDQ    $4, R9
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_csign
done_csign:
    RET ,

// func cdivSlice(out []float32, a []float32, c float32)
TEXT ·cdivSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVSS   c+48(FP),X4         // X4: c
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_cdiv
    SHUFPS  $0, X4, X4
loopback_cdiv:
    MOVAPS  X4, X1
    MOVAPS  X4, X3
    MOVUPS  (R11),X0
    DIVPS   X0,X1
    MOVUPS  16(R11),X2
    DIVPS   X2,X3
    MOVUPS  X1,(SI)
    MOVUPS  X3,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_cdiv
remain_cdiv:
    CMPQ    R10,$0
    JEQ     done_cdiv
onemore_cdiv:
    MOVAPS  X4, X1
    MOVSS   (R11),X0
    DIVSS   X0,X1
    MOVSS   X1,(SI)
    ADDQ    $4, R11
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_cdiv
done_cdiv:
    RET ,


// func cmulSlice(out []float32, a []float32, c float32)
TEXT ·cmulSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVSS   c+48(FP),X4         // X4: c
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_cmul
    SHUFPS  $0, X4, X4
loopback_cmul:
    MOVUPS  (R11),X0
    MULPS   X4,X0
    MOVUPS  16(R11),X2
    MULPS   X4,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_cmul
remain_cmul:
    CMPQ    R10,$0
    JEQ     done_cmul
onemore_cmul:
    MOVSS   (R11),X0
    MULSS   X4,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_cmul
done_cmul:
    RET ,


// func caddSlice(out []float32, a []float32, c float32)
TEXT ·caddSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVSS   c+48(FP),X4         // X4: c
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_cadd
    SHUFPS  $0, X4, X4
loopback_cadd:
    MOVUPS  (R11),X0
    ADDPS   X4,X0
    MOVUPS  16(R11),X2
    ADDPS   X4,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_cadd
remain_cadd:
    CMPQ    R10,$0
    JEQ     done_cadd
onemore_cadd:
    MOVSS   (R11),X0
    ADDSS   X4,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_cadd
done_cadd:
    RET ,


// func addScaledSlice(y []float32, x []float32, a float32)
TEXT ·addScaledSlice(SB), 7, $0
    MOVQ    y(FP),SI            // SI: &y
    MOVQ    y_len+8(FP),DX      // DX: len(y)
    MOVQ    x+24(FP),R11        // R11: &x
    MOVSS   a+48(FP),X4         // X4: a
    MOVQ    DX, R10             // R10: len(y)
    SHRQ    $3, DX              // DX: len(y) / 8
    ANDQ    $7, R10             // R10: len(y) % 8
    CMPQ    DX ,$0
    JEQ     remain_madd
    SHUFPS  $0, X4, X4
loopback_madd:
    MOVUPS  (R11),X0
    MOVUPS  (SI), X5
    MULPS   X4, X0
    ADDPS   X5, X0
    MOVUPS  16(R11),X2
    MOVUPS  16(SI), X6
    MULPS   X4, X2
    ADDPS   X6, X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_madd
remain_madd:
    CMPQ    R10,$0
    JEQ     done_madd
onemore_madd:
    MOVSS   (R11),X0
    MOVSS   (SI),X1
    MULSS   X4,X0
    ADDSS   X1,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_madd
done_madd:
    RET ,

// func sqrtSlice(out []float32, a []float32)
TEXT ·sqrtSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_sqrt
loopback_sqrt:
    MOVUPS  (R11),X0
    SQRTPS  X0,X0
    MOVUPS  16(R11),X2
    SQRTPS  X2,X2
    MOVUPS  X0,(SI)
    MOVUPS  X2,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_sqrt
remain_sqrt:
    CMPQ    R10,$0
    JEQ     done_sqrt
onemore_sqrt:
    MOVSS   (R11),X0
    SQRTSS  X0,X0
    MOVSS   X0,(SI)
    ADDQ    $4, R11
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_sqrt
done_sqrt:
    RET ,

// func absSlice(out []float32, a []float32)
TEXT ·absSlice(SB), 7, $0
    MOVQ    out(FP),SI          // SI: &out
    MOVQ    out_len+8(FP),DX    // DX: len(out)
    MOVQ    a+24(FP),R11        // R11: &a
    MOVQ    $(1<<31), BX
    MOVQ    BX, X5             // X1: Sign
    SHUFPS  $0, X5, X5
    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: len(out) / 8
    ANDQ    $7, R10             // R10: len(out) % 8
    CMPQ    DX ,$0
    JEQ     remain_abs
loopback_abs:
    MOVAPS  X5, X3
    MOVAPS  X5, X4
    MOVUPS  (R11),X0
    ANDNPS  X0, X3
    MOVUPS  16(R11),X1
    ANDNPS  X1, X4
    MOVUPS  X3,(SI)
    MOVUPS  X4,16(SI)
    ADDQ    $32, R11
    ADDQ    $32, SI
    SUBQ    $1,DX
    JNZ     loopback_abs
remain_abs:
    CMPQ    R10,$0
    JEQ     done_abs
onemore_abs:
    MOVAPS  X5, X1
    MOVSS   (R11),X0
    ANDNPS  X0, X1
    MOVSS   X1,(SI)
    ADDQ    $4, R11
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     onemore_abs
done_abs:
    RET ,

// func minSliceElement(a []float32) float32
TEXT ·minSliceElement(SB), 7, $0
    MOVQ    a(FP),SI          // SI: &a
    MOVQ    a_len+8(FP),DX    // DX: len(a)
    MOVSS   (SI), X0          // Initial value
    ADDQ    $4, SI
    SUBQ    $1, DX

    SHUFPS  $0, X0, X0
    MOVQ    DX, R10             // R10: len(out) -1
    SHRQ    $3, DX              // DX: (len(out) - 1) / 8
    ANDQ    $7, R10             // R10: (len(out) -1 ) % 8
    MOVAPS  X0, X1
    CMPQ    DX ,$0
    JEQ     remain_min_e
next_min_e:
    MOVUPS  (SI), X2
    MOVUPS  16(SI), X3
    MINPS   X2, X0
    MINPS   X3, X1
    ADDQ    $32, SI
    SUBQ    $1, DX
    JNZ next_min_e
    CMPQ    R10, $0
    JZ      done_min_e
remain_min_e:
    MOVSS   (SI), X2
    MINSS   X2, X0
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     remain_min_e
done_min_e:
    MINPS    X1, X0
    MOVAPS   X0, X1
    MOVAPS   X0, X2
    MOVAPS   X0, X3
    SHUFPS   $1, X1, X1        // Put Element 1 into lower X1
    SHUFPS   $2, X2, X2        // Put Element 2 into lower X2
    SHUFPS   $3, X3, X3        // Put Element 3 into lower X3

    MINSS    X1, X0
    MINSS    X3, X2
    MINSS    X2, X0
    MOVSS    X0, ret+24(FP)
    RET ,


// func maxSliceElement(a []float32) float32
TEXT ·maxSliceElement(SB), 7, $0
    MOVQ    a(FP),SI          // SI: &a
    MOVQ    a_len+8(FP),DX    // DX: len(a)
    MOVSS   (SI), X0          // Initial value
    ADDQ    $4, SI
    SUBQ    $1, DX

    SHUFPS  $0, X0, X0
    MOVQ    DX, R10             // R10: len(out) -1
    SHRQ    $3, DX              // DX: (len(out) - 1) / 8
    ANDQ    $7, R10             // R10: (len(out) -1 ) % 8
    MOVAPS  X0, X1
    CMPQ    DX ,$0
    JEQ     remain_max_e
next_max_e:
    MOVUPS  (SI), X2
    MOVUPS  16(SI), X3
    MAXPS   X2, X0
    MAXPS   X3, X1
    ADDQ    $32, SI
    SUBQ    $1, DX
    JNZ next_max_e
    CMPQ    R10, $0
    JZ      done_max_e
remain_max_e:
    MOVSS   (SI), X2
    MAXSS   X2, X0
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     remain_max_e
done_max_e:
    MAXPS    X1, X0
    MOVAPS   X0, X1
    MOVAPS   X0, X2
    MOVAPS   X0, X3
    SHUFPS   $1, X1, X1        // Put Element 1 into lower X1
    SHUFPS   $2, X2, X2        // Put Element 2 into lower X2
    SHUFPS   $3, X3, X3        // Put Element 3 into lower X3

    MAXSS    X1, X0
    MAXSS    X3, X2
    MAXSS    X2, X0
    MOVSS    X0, ret+24(FP)
    RET ,



// func sliceSum(a []float32) float32
TEXT ·sliceSum(SB), 7, $0
    MOVQ    a(FP),SI          // SI: &a
    MOVQ    a_len+8(FP),DX    // DX: len(a)
    XORPS   X0, X0            // Sum 1
    XORPS   X1, X1            // Sum 2

    MOVQ    DX, R10             // R10: len(out)
    SHRQ    $3, DX              // DX: (len(out)) / 8
    ANDQ    $7, R10             // R10: (len(out)) % 8
    CMPQ    DX ,$0
    JEQ     remain_sum
next_sum:
    MOVUPS  (SI), X2
    MOVUPS  16(SI), X3
    ADDPS   X2, X0
    ADDPS   X3, X1
    ADDQ    $32, SI
    SUBQ    $1, DX
    JNZ     next_sum
    CMPQ    R10, $0
    JZ      done_sum
remain_sum:
    MOVSS   (SI), X2
    ADDSS   X2, X0
    ADDQ    $4, SI
    SUBQ    $1, R10
    JNZ     remain_sum
done_sum:
    ADDPS   X1, X0
    MOVAPS  X0, X1
    MOVAPS  X0, X2
    MOVAPS  X0, X3
    SHUFPS  $1, X1, X1        // Put Element 1 into lower X1
    SHUFPS  $2, X2, X2        // Put Element 2 into lower X2
    SHUFPS  $3, X3, X3        // Put Element 3 into lower X3

    ADDSS   X1, X0
    ADDSS   X3, X2
    ADDSS   X2, X0

    MOVSS   X0, ret+24(FP)
    RET ,
