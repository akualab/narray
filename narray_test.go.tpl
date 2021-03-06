// Copyright (c) 2015 AKUALAB INC., All rights reserved.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package {{.Package}}

import (
	"math"
	"math/rand"
	"os"
	"path/filepath"
	"testing"
)

type ar func(*NArray, *NArray) *NArray
type sc func(float64) float64

type F struct {
	name       string
	arrayFunc  ar
	scalarFunc sc
}

var testList = []F{
	{"Abs", Abs, math.Abs},
	{"Sqrt", Sqrt, math.Sqrt},
	{"Acosh", Acosh, math.Acosh},
	{"Asin", Asin, math.Asin},
	{"Acos", Acos, math.Acos},
	{"Asinh", Asinh, math.Asinh},
	{"Atan", Atan, math.Atan},
	{"Atanh", Atanh, math.Atanh},
	{"Cbrt", Cbrt, math.Cbrt},
	{"Erf", Erf, math.Erf},
	{"Erfc", Erfc, math.Erfc},
	{"Exp", Exp, math.Exp},
	{"Exp2", Exp2, math.Exp2},
	{"Expm1", Expm1, math.Expm1},
	{"Floor", Floor, math.Floor},
	{"Ceil", Ceil, math.Ceil},
	{"Trunc", Trunc, math.Trunc},
	{"Gamma", Gamma, math.Gamma},
	{"J0", J0, math.J0},
	{"Y0", Y0, math.Y0},
	{"J1", J1, math.J1},
	{"Y1", Y1, math.Y1},
	{"Log", Log, math.Log},
	{"Log10", Log10, math.Log10},
	{"Log2", Log2, math.Log2},
	{"Log1p", Log1p, math.Log1p},
	{"Logb", Logb, math.Logb},
	{"Cos", Cos, math.Cos},
	{"Sin", Sin, math.Sin},
	{"Sinh", Sinh, math.Sinh},
	{"Cosh", Cosh, math.Cosh},
	{"Tan", Tan, math.Tan},
	{"Tanh", Tanh, math.Tanh},
}

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
var randna []*NArray

func init() {
	x = New(3, 5)
	y = New(3, 5)
	for i := 0; i < 3; i++ {
		for j := 0; j < 5; j++ {
			x.Data[i*5+j] = {{.Format}}(i*5 + j)
			y.Data[i*5+j] = {{.Format}}(i*5 + j + 2)
		}
	}

	na234 = New(2, 3, 4)
	for i := 0; i < 2; i++ {
		for j := 0; j < 3; j++ {
			for k := 0; k < 4; k++ {
				v := {{.Format}}(9000 + i*100 + j*10 + k)
				na234.Set(v, i, j, k)
			}
		}
	}

	// create slice of random narrays
	r := rand.New(rand.NewSource(222))
	randna = make([]*NArray, 10, 10)
	for k := range randna {
		randna[k] = Norm(r, 0.0, 100.0, 11, 3, 8, 22)
	}
}

func TestF2(t *testing.T) {

	for _, v := range testList {
		testF2(t, v)
	}
}

func testF2(t *testing.T, item F) {

	z := item.arrayFunc(nil, randna[0])
	xx := randna[0].Copy()
	for k, v := range randna[0].Data {
		xx.Data[k] = {{.Format}}(item.scalarFunc(float64(v)))
	}
	if !EqualValues(z, xx, 0.00001) {
		t.Errorf("func %s failed", item.name)
		t.Errorf("expected %s", xx)
		t.Errorf("got %s", z)
		t.FailNow()
	}
}

func TestNew(t *testing.T) {

	na := New(3, 5)
	for i := 0; i < 3; i++ {
		for j := 0; j < 5; j++ {
			na.Data[i*5+j] = {{.Format}}(i*5 + j)
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
 {{if .Float64}}v := rand.Float64(){{end}} {{if .Float32}}v := rand.Float32(){{end}}
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

		na.Data[i] = {{.Format}}(i)
	}

	for i := 0; i < dims[0]; i++ {
		for j := 0; j < dims[1]; j++ {
			for k := 0; k < dims[2]; k++ {
				for l := 0; l < dims[3]; l++ {
					v := na.At(i, j, k, l)
					if v != {{.Format}}(na.Index(i, j, k, l)) {
						t.Fatalf("values don't match - na.At(%d,%d,%d,%d) is [%f], expected [%f]",
							i, j, k, l, v, {{.Format}}(na.Index(i, j, k, l)))
					}
				}
			}
		}
	}
}

func TestVector(t *testing.T) {

	vec := na234.Vector(1, 2, -1)
	t.Log(vec)
	checkVector(t, vec, 1, 2, -1)
	vec = na234.Vector(-1, 2, 2)
	t.Log(vec)
	checkVector(t, vec, -1, 2, 2)
	vec = na234.Vector(0, -1, 3)
	t.Log(vec)
	checkVector(t, vec, 0, -1, 3)
}

func checkVector(t *testing.T, vec *Vector, query ...int) {

	sa := na234.SubArray(query...)
	if !EqualValues((*NArray)(vec), sa, 0.0001) {
		t.Fatalf("vec values dont' match expected:%s, got:%s", vec, sa)
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
		na.Data[i] = {{.Format}}(i)
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
		out.Data[k] = {{.Format}}(math.Log(float64(in.Data[k])))
	}
	return out
}

func TestLog(t *testing.T) {

	na := y

	loga := loga(nil, na)
	if {{.Format}}(math.Log(float64(na.At(1, 1)))) != loga.At(1, 1) {
		t.Fatalf("expected %f, got %f", math.Log(float64(na.At(1, 1))), loga.At(1, 1))
	}

	// use the genarated code
	log := Log(nil, na)
	if {{.Format}}(math.Log(float64(na.At(1, 1)))) != log.At(1, 1) {
		t.Fatalf("expected %f, got %f", math.Log(float64(na.At(1, 1))), log.At(1, 1))
	}

	aa := randna[0].Copy()
	bb := Exp(nil, Log(aa, aa))
	if !EqualValues(randna[0], bb, 0.00001) {
		t.Fatalf("expected same values")
	}
}

func scaleFunc(a {{.Format}}) ApplyFunc {
	return func(x {{.Format}}) {{.Format}} { return x * a }
}

func TestApply(t *testing.T) {

	in := x
	fn := scaleFunc(2.0)
	out := Apply(nil, in, fn)

	if out.At(1, 1) != 12.0 {
		t.Fatalf("expected 12.0, got %f", out.At(1, 1))
	}

	xx := New(x.Shape...)
	for k, v := range x.Data {
		xx.Data[k] = v * 2.0
	}
	if !EqualValues(out, xx, 0) {
		t.Fatalf("expected same values")
	}
}

func TestEqualShape(t *testing.T) {
	a1 := New(2, 3, 4, 5)
	a2 := New(2, 3)
	if EqualShape(a1, a2) {
		t.Fatalf("expected false got true")
	}
}

func TestEqualValues(t *testing.T) {

	if !EqualValues(randna[0], randna[0], 0.0) {
		t.Fatalf("expected same values")
	}
	if EqualValues(randna[0], randna[1], 0.5) {
		t.Fatalf("expected different values")
	}
	xx := Scale(nil, randna[0], 1.05)     // 5%
	if !EqualValues(randna[0], xx, 0.1) { // 10% tol
		t.Fatalf("expected same values")
	}
	if EqualValues(randna[0], xx, 0.01) { // 1% tol
		t.Fatalf("expected different values")
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

	z := Add(nil, randna...)
	xx := New(z.Shape...)
	for i, _ := range randna {
		for k, v := range randna[i].Data {
			xx.Data[k] += v
		}
	}
	if !EqualValues(z, xx, 0) {
		t.Fatalf("expected same values")
	}
}

func TestAddConst(t *testing.T) {

	out := AddConst(nil, randna[0], 2.0)

	for k, v := range out.Data {
		w := randna[0].Data[k] + 2.0
		if v != w {
			t.Fatalf("expected %f, got %f for index %d", v, w, k)
		}
	}
}

func TestAddScaled(t *testing.T) {

	out := randna[0].Copy()
	AddScaled(out, randna[1], 2.0)

	for k, v := range out.Data {
		w := randna[0].Data[k] + randna[1].Data[k]*2.0
		if v != w {
			t.Fatalf("expected %f, got %f for index %d", v, w, k)
		}
	}
}

func TestSub(t *testing.T) {

	z := Sub(nil, randna[1], randna[0])

	xx := New(z.Shape...)
	for k, v := range randna[0].Data {
		xx.Data[k] = randna[1].Data[k] - v
	}
	if !EqualValues(z, xx, 0) {
		t.Fatalf("expected same values")
	}
}

func TestDiv(t *testing.T) {

	z := Div(nil, randna[1], randna[0])

	xx := New(z.Shape...)
	for k, v := range randna[0].Data {
		xx.Data[k] = randna[1].Data[k] / v
	}
	if !EqualValues(z, xx, 0.0001) {
		t.Fatalf("expected same values")
	}
}

func TestMul(t *testing.T) {
	z := Mul(nil, randna...)
	xx := New(z.Shape...)
	xx.SetValue(1)
	for i, _ := range randna {
		for k, v := range randna[i].Data {
			xx.Data[k] *= v
		}
	}
	if !EqualValues(z, xx, 0) {
		t.Fatalf("expected same values")
	}
}

func TestScale(t *testing.T) {
	z := Scale(nil, randna[0], 2.0)
	xx := randna[0].Copy()
	for k, v := range randna[0].Data {
		xx.Data[k] = v * 2
	}
	if !EqualValues(z, xx, 0) {
		t.Fatalf("expected same values")
	}
}

func TestAbs(t *testing.T) {
	z := Abs(nil, randna[0])
	xx := randna[0].Copy()
	for k, v := range randna[0].Data {
		xx.Data[k] = {{.Format}}(math.Abs(float64(v)))
	}
	if !EqualValues(z, xx, 0) {
		t.Fatalf("expected same values")
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

func TestDot(t *testing.T) {

   	z := Dot(randna[0],randna[1])
	xx := New(randna[0].Shape...)
	xx.SetValue(1)
	for i, _ := range randna[:2] {
		for k, v := range randna[i].Data {
			xx.Data[k] *= v
		}
	}
    sum := {{.Format}}(0.0)
    for _, v := range xx.Data {
		sum += v
	}

	if math.Abs(float64(z -sum)) / float64(z) > 0.001 {
		t.Fatalf("expected %f, got %f", z, sum)
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

func TestMaxArray(t *testing.T) {

	out := MaxArray(nil, randna...)

	for k, v := range out.Data {
		for q, na := range randna {
			if v < na.Data[k] {
				t.Fatalf("expected %f > %f in input %d", out.Data[k], na.Data[k], q)
			}
		}
	}
}

func TestMinArray(t *testing.T) {

	out := MinArray(nil, randna...)

	for k, v := range out.Data {
		for q, na := range randna {
			if v > na.Data[k] {
				t.Fatalf("expected %f > %f in input %d", out.Data[k], na.Data[k], q)
			}
		}
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

func TestString(t *testing.T) {

	s := randna[0].Sprint(func(na *NArray, k int) bool {
		if na.Data[k] > 80 {
			return true
		}
		return false
	})

	// TODO: parse string and verify value...not the highest priority...

	t.Log(s)
}

func TestWrite(t *testing.T) {

	fn := filepath.Join(os.TempDir(), "narray.json")
	x.WriteFile(fn)
	t.Logf("Wrote to temp file: %s\n", fn)

	// Read back.
	x1, e := ReadFile(fn)
	if e != nil {
		t.Fatal(e)
	}

	t.Logf("Original narray:%s", x)
	t.Logf("Read back from file:%s", x1)

	// compare
	if !EqualValues(x, x1, 0.001) {
		t.Fatal("write/read failed")
	}
}

func TestEncode(t *testing.T) {

	xx := x.Copy()
	xx.Set({{.Format}}(math.Inf(-1)), 1, 1)
	xx.Set({{.Format}}(math.Inf(-1)), 1, 4)
	xx.Set({{.Format}}(math.Inf(1)), 1, 3)
	xx.Set({{.Format}}(math.NaN()), 1, 2)
	xx.Decode(xx.Encode())
	if !EqualValues(x, xx, 0) {
		t.Fatal("encode/decode failed")
	}

	fn := filepath.Join(os.TempDir(), "narray.json")
	xx.WriteFile(fn)
	t.Logf("Wrote to temp file: %s\n", fn)

	// Read back.
	x1, e := ReadFile(fn)
	if e != nil {
		t.Fatal(e)
	}

	t.Logf("Original narray:%s", x)
	t.Logf("Read back from file:%s", x1)

	// compare
	if !EqualValues(x, x1, 0.001) {
		t.Fatal("write/read failed")
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

	var w {{.Format}}
	for i := 0; i < b.N; i++ {
		w = na.At(indices...)
	}
	_ = w
}

func BenchmarkProd(b *testing.B) {

	N := 1000
	na := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	var p {{.Format}}
	for i := 0; i < b.N; i++ {
		p = na.Prod()
	}
	_ = p

}

func BenchmarkAdd10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Add(dst, na, nb)
	}
}

func BenchmarkSub10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Sub(dst, na, nb)
	}
}

func BenchmarkSubScaleMul10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Add(dst, na, Scale(dst, nb, -1.0))
	}
}

func BenchmarkMul10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Mul(dst, na, nb)
	}
}

func BenchmarkDiv10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Div(dst, na, nb)
	}
}

func BenchmarkDivRcpMul10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Mul(dst, na, Rcp(dst, nb))
	}
}

func BenchmarkAddScaled10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		na = AddScaled(na, nb, 1.1)
	}
}

func BenchmarkMin10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = MinArray(dst, na, nb)
	}
}

func BenchmarkMax10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = MaxArray(dst, na, nb)
	}
}

func BenchmarkCopySign10001(b *testing.B) {
	N := 10001
	na := New(N)
	nb := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
		nb.Data[i] = {{.Format}}(i) * 0.5
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Copysign(dst, na, nb)
	}
}

func BenchmarkMinValue10001(b *testing.B) {
	N := 10001
	na := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		_ = na.Min()
	}
}

func BenchmarkMaxValue10001(b *testing.B) {
	N := 10001
	na := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		_ = na.Max()
	}
}

func BenchmarkSum10001(b *testing.B) {
	N := 10001
	na := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		_ = na.Sum()
	}
}

func BenchmarkRcp10001(b *testing.B) {
	N := 10001
	na := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Rcp(dst, na)
	}
}

func BenchmarkSqrt10001(b *testing.B) {
	N := 10001
	na := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Sqrt(dst, na)
	}
}

func BenchmarkAbs10001(b *testing.B) {
	N := 10001
	na := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Abs(dst, na)
	}
}

func BenchmarkScale10001(b *testing.B) {
	N := 10001
	na := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = Scale(dst, na, 20.0)
	}
}

func BenchmarkConstAdd10001(b *testing.B) {
	N := 10001
	na := New(N)
	dst := New(N)
	for i := 0; i < N; i++ {
		na.Data[i] = {{.Format}}(i)
	}

	b.ResetTimer()
	b.SetBytes(int64(N * 8))
	for i := 0; i < b.N; i++ {
		dst = AddConst(dst, na, 20.0)
	}
}
