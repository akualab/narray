// Copyright (c) 2015 AKUALAB INC., All rights reserved.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package narray

import (
	"math"
	"math/rand"
	"os"
	"testing"
)

// copied from github.com/gonum/floats
func panics(fun func()) (b bool) {
	defer func() {
		err := recover()
		if err != nil {
			b = true
		}
	}()
	fun()
	return
}

var x, y, na234 *NArray

func TestMain(m *testing.M) {

	x = New(3, 5)
	y = New(3, 5)
	for i := 0; i < 3; i++ {
		for j := 0; j < 5; j++ {
			x.Data[i*5+j] = float64(i*5 + j)
			y.Data[i*5+j] = float64(i*5 + j + 2)
		}
	}

	na234 = New(2, 3, 4)
	for i := 0; i < 2; i++ {
		for j := 0; j < 3; j++ {
			for k := 0; k < 4; k++ {
				v := float64(9000 + i*100 + j*10 + k)
				na234.Set(v, i, j, k)
			}
		}
	}

	os.Exit(m.Run())
}

func TestNew(t *testing.T) {

	na := New(3, 5)
	for i := 0; i < 3; i++ {
		for j := 0; j < 5; j++ {
			na.Data[i*5+j] = float64(i*5 + j)
		}
	}

	if int(na.Data[11]) != 11 {
		t.Fatalf("expected 11, got %d", int(na.Data[11]))
	}
}

func TestSet(t *testing.T) {

	for x := 0; x < 1000; x++ {
		rank := rand.Intn(10)
		dims := make([]int, rank, rank)
		for k := range dims {
			dims[k] = rand.Intn(5) + 1
		}

		na := New(dims...)
		indices := make([]int, rank, rank)
		for i := 0; i < 1000; i++ {

			for j := range indices {
				indices[j] = rand.Intn(dims[j])
			}
			v := rand.Float64()
			na.Set(v, indices...)
			w := na.At(indices...)
			if v != w {
				t.Fatalf("values don't match - Set is [%f], At is [%f]", v, w)
			}
		}
	}

	dims := []int{3, 15, 7, 9}
	na := New(dims...)
	for i := 0; i < len(na.Data); i++ {

		na.Data[i] = float64(i)
	}

	for i := 0; i < dims[0]; i++ {
		for j := 0; j < dims[1]; j++ {
			for k := 0; k < dims[2]; k++ {
				for l := 0; l < dims[3]; l++ {
					v := na.At(i, j, k, l)
					if v != float64(na.Index(i, j, k, l)) {
						t.Fatalf("values don't match - na.At(%d,%d,%d,%d) is [%f], expected [%f]",
							i, j, k, l, v, float64(na.Index(i, j, k, l)))
					}
				}
			}
		}
	}
}

func TestVector(t *testing.T) {

	vec := na234.Vector(0, 1)
	t.Log(vec)
	checkVector(t, 0, 1, vec)
	vec = na234.Vector(1, 2)
	t.Log(vec)
	checkVector(t, 1, 2, vec)
	vec = na234.Vector(2, 0)
	t.Log(vec)
	checkVector(t, 2, 0, vec)

}

func checkVector(t *testing.T, dim, idx int, vec *NArray) {

	for _, v := range vec.Data {
		x := int(v - 9000)
		i := int(x / 100)
		x = x - (i * 100)
		j := int(x / 10)
		k := int(x - (j * 10))
		if v != na234.At(i, j, k) {
			t.Fatalf("vec values dont' match fir index (%d,%d,%d) v:%f, expected:%f", i, j, k, v, na234.At(i, j, k))
		}
	}
}

func TestCartesianProduct(t *testing.T) {

	cp := cartesianProduct([]int{2, 3, 4})
	t.Log(cp)
}

func TestQuerySubset(t *testing.T) {

	qs := querySubset([]int{-1, -1, 1}, []int{2, 3, 4})
	t.Log(qs)
}

func TestSubArray(t *testing.T) {
	sa := na234.SubArray(-1, -1, 1)
	t.Log(sa)

	for i := 0; i < 2; i++ {
		for j := 0; j < 3; j++ {
			k := 1
			if na234.At(i, j, k) != sa.At(i, j) {
				t.Fatalf("element mismatch got %f expected %f", na234.At(i, j, k), sa.At(i, j))
			}
		}
	}
	{
		sa = na234.SubArray(0, -1, 2)
		i := 0
		k := 2
		for j := 0; j < 3; j++ {
			if na234.At(i, j, k) != sa.At(j) {
				t.Fatalf("element mismatch got %f expected %f", na234.At(i, j, k), sa.At(j))
			}
		}
	}
	{
		sa = na234.SubArray(0, 2, 2)
		i := 0
		j := 2
		k := 2
		if na234.At(i, j, k) != sa.At() {
			t.Fatalf("element mismatch got %f expected %f", na234.At(i, j, k), sa.At())
		}
	}
	sa = na234.SubArray(-1, -1, -1)
	for i := 0; i < 2; i++ {
		for j := 0; j < 3; j++ {
			for k := 0; k < 4; k++ {
				if na234.At(i, j, k) != sa.At(i, j, k) {
					t.Fatalf("element mismatch got %f expected %f", na234.At(i, j, k), sa.At(i, j, k))
				}
			}
		}
	}
}

func TestScalar(t *testing.T) {

	na := New()
	na.Set(1.0)
	if na.At() != 1.0 {
		t.Fatal("can't read scalar")
	}
}

func TestCopy(t *testing.T) {

	dims := []int{3, 15, 7, 9}
	na := New(dims...)
	for i := 0; i < len(na.Data); i++ {
		na.Data[i] = float64(i)
	}
	newna := na.Copy()

	for i := 0; i < dims[0]; i++ {
		for j := 0; j < dims[1]; j++ {
			for k := 0; k < dims[2]; k++ {
				for l := 0; l < dims[3]; l++ {
					v := na.At(i, j, k, l)
					w := newna.At(i, j, k, l)
					if v != w {
						t.Fatalf("values don't match - newna.At(%d,%d,%d,%d) is [%f], expected [%f]",
							i, j, k, l, w, v)
					}
				}
			}
		}
	}
}

// Sample math function.
func loga(out, in *NArray) *NArray {

	if out == nil {
		out = New(in.Shape...)
	}
	for k := range in.Data {
		out.Data[k] = math.Log(in.Data[k])
	}
	return out
}

func TestLog(t *testing.T) {

	na := y

	loga := loga(nil, na)
	if math.Log(na.At(1, 1)) != loga.At(1, 1) {
		t.Fatalf("expected %f, got %f", math.Log(na.At(1, 1)), loga.At(1, 1))
	}

	// use the genarated code
	log := Log(nil, na)
	if math.Log(na.At(1, 1)) != log.At(1, 1) {
		t.Fatalf("expected %f, got %f", math.Log(na.At(1, 1)), log.At(1, 1))
	}
}

func scaleFunc(a float64) ApplyFunc {
	return func(x float64) float64 { return x * a }
}

func TestApply(t *testing.T) {

	in := x
	fn := scaleFunc(2.0)
	out := Apply(nil, in, fn)

	if out.At(1, 1) != 12.0 {
		t.Fatalf("expected 12.0, got %f", out.At(1, 1))
	}
}

func TestEqualShape(t *testing.T) {
	a1 := New(2, 3, 4, 5)
	a2 := New(2, 3)
	if EqualShape(a1, a2) {
		t.Fatalf("expected false got true")
	}
}

func TestAdd(t *testing.T) {

	in := x
	in2 := in.Copy()
	in3 := in.Copy()
	out := Add(nil, in, in3, in2)

	if out.At(1, 1) != 18.0 {
		t.Fatalf("expected 18.0, got %f", out.At(1, 1))
	}

	in4 := New(3, 5, 66)

	if !panics(func() { Add(nil, in, in3, in2, in4) }) {
		t.Errorf("did not panic with shape mismatch")
	}
}

func TestSub(t *testing.T) {
	out := Sub(nil, y, x)
	if out.At(1, 1) != 2.0 {
		t.Fatalf("expected 2.0, got %f", out.At(1, 1))
	}
}

func TestDiv(t *testing.T) {
	out := Div(nil, y, x)
	if out.At(1, 1) != 4.0/3.0 {
		t.Fatalf("expected 4/3, got %f", out.At(1, 1))
	}
}

func TestMul(t *testing.T) {
	out := Mul(nil, y, x)
	if out.At(1, 1) != 48.0 {
		t.Fatalf("expected 48, got %f", out.At(1, 1))
	}

	y1 := y.Copy()
	Mul(y1, y1, x)
	if y1.At(1, 1) != 48.0 {
		t.Fatalf("expected 48, got %f", y1.At(1, 1))
	}

}

func TestScale(t *testing.T) {
	out := Scale(nil, x, 2.0)
	if out.At(1, 1) != 12.0 {
		t.Fatalf("expected 12, got %f", out.At(1, 1))
	}
}

func TestReverseIndex(t *testing.T) {

	na := New(7, 3, 2, 14, 1, 7)
	for i := 0; i < 7*3*2*14*7; i++ {
		rev := na.ReverseIndex(i)
		ind := na.Index(rev...)
		if i != ind {
			t.Fatalf("expected %d, got %d", i, ind)
		}
	}
}

func TestMax(t *testing.T) {

	na := x.Copy()
	na.Set(9999, 1, 1)
	max := na.Max()
	max2, i := na.MaxIdx()
	if max != max2 {
		t.Fatalf("expected %f, got %f", max, max2)
	}
	if i[0] != 1 {
		t.Fatalf("expected i[0]=1, got %d", i[0])
	}
	if i[1] != 1 {
		t.Fatalf("expected i[1]=1, got %d", i[1])
	}
}

func TestMin(t *testing.T) {

	na := x.Copy()
	na.Set(-9999, 1, 1)
	min := na.Min()
	min2, i := na.MinIdx()
	if min != min2 {
		t.Fatalf("expected %f, got %f", min, min2)
	}
	if i[0] != 1 {
		t.Fatalf("expected i[0]=1, got %d", i[0])
	}
	if i[1] != 1 {
		t.Fatalf("expected i[1]=1, got %d", i[1])
	}
}

func TestSum(t *testing.T) {
	xx := New(3, 3)
	xx.Set(1, 1, 1)
	xx.Set(2, 1, 2)
	xx.Set(3, 2, 2)
	if xx.Sum() != 6.0 {
		t.Fatalf("expected 6, got %f", xx.Sum())
	}
}

func TestProd(t *testing.T) {
	xx := New(2, 2)
	xx.Set(1, 0, 0)
	xx.Set(2, 0, 1)
	xx.Set(3, 1, 0)
	xx.Set(4, 1, 1)
	if xx.Prod() != 24.0 {
		t.Fatalf("expected 24, got %f", x.Prod())
	}
}

func TestMinElem(t *testing.T) {

	na := x.Copy()
	t.Log(na)
	na.MinElem(-9999, 1, 1)
	na.MinElem(9999, 2, 2)

	if na.At(1, 1) != -9999 {
		t.Fatalf("expected %f, got %f", -9999.0, na.At(1, 1))
	}
	if na.At(2, 2) != x.At(2, 2) {
		t.Fatalf("expected %f, got %f", x.At(2, 2), na.At(2, 2))
	}

}

func TestMaxElem(t *testing.T) {

	na := x.Copy()
	t.Log(na)
	na.MaxElem(-9999, 1, 1)
	na.MaxElem(9999, 2, 2)

	if na.At(2, 2) != 9999 {
		t.Fatalf("expected %f, got %f", -9999.0, na.At(2, 2))
	}
	if na.At(1, 1) != x.At(1, 1) {
		t.Fatalf("expected %f, got %f", x.At(1, 1), na.At(1, 1))
	}

}

func TestRcp(t *testing.T) {
	out := Rcp(nil, x)
	for i := 0; i < 3; i++ {
		for j := 0; j < 5; j++ {
			if out.At(i, j) != 1.0/x.At(i, j) {
				t.Fatalf("expected %f, got %f", 1.0/x.At(i, j), out.At(i, j))
			}

		}
	}
	z := New(2)
	if !panics(func() { Rcp(z, x) }) {
		t.Errorf("did not panic with shape mismatch")
	}
}

func BenchmarkRead(b *testing.B) {

	rank := rand.Intn(10)
	dims := make([]int, rank, rank)
	for k := range dims {
		dims[k] = rand.Intn(5) + 1
	}
	na := New(dims...)
	indices := make([]int, rank, rank)
	for j := range indices {
		indices[j] = rand.Intn(dims[j])
	}

	var w float64
	for i := 0; i < b.N; i++ {
		w = na.At(indices...)
	}
	_ = w
}

func BenchmarkProd(b *testing.B) {

	N := 1000
	na := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = float64(i)
	}

	var p float64
	for i := 0; i < b.N; i++ {
		p = na.Prod()
	}
	_ = p

}

func BenchmarkDiv10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = float64(i)
		nb.Data[i] = float64(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Div(dst, na, nb)
	}
}

func BenchmarkMul10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = float64(i)
		nb.Data[i] = float64(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Mul(dst, na, nb)
	}
}

func BenchmarkRcp10001(b *testing.B) {
	N := 10001
	na := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = float64(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Rcp(dst, na)
	}
}

func BenchmarkScale10001(b *testing.B) {
	N := 10001
	na := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = float64(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Scale(dst, na, 20.0)
	}
}
