// Copyright (c) 2015 AKUALAB INC., All rights reserved.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

/*
Package narray provides functions to opearate with multidimensional arrays of type float64. The NArray object is a dense, fixed-size, array of rank n.

The shape is a vector with the size of each dimension. Typical cases:

  type      rank   example
  --------------------------------
  scalar    0      na := New()
  vector    1      na := New(12)
  matrix    2      na := New(5,17)
  cube      3      na := New(2,3,5)

*/
package narray

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"math"
	"math/rand"
	"os"
	"path/filepath"
	"strconv"
)

// The NArray object.
type NArray struct {
	// The rank or order or degree of the narray is the dimensionality required to represent it. (eg. The rank of a vector is 1)
	Rank int `json:"rank"`
	// The shape is an int slice that contains the size of each dimension. Subscripts range from zero to s-1. Where s is the size of a dimension.
	Shape []int `json:"shape"`
	// The data is stored as a slice of float64 numbers.
	Data []float64 `json:"data"`
	// Strides for each dimension.
	Strides []int `json:"strides"`
}

// New creates a new n-dimensional array.
func New(shape ...int) *NArray {

	size := 1
	rank := len(shape)
	for _, v := range shape {
		size *= v
	}
	strides := make([]int, rank, rank)
	s := 1
	for i := (rank - 1); i >= 0; i-- {
		strides[i] = s
		s *= shape[i]
	}

	return &NArray{
		Rank:    rank,
		Shape:   shape,
		Data:    make([]float64, size, size),
		Strides: strides,
	}
}

// Norm creates a new n-dimensional array whose
// elements are drawn from a Normal probability density function.
func Norm(r *rand.Rand, mean, sd float64, shape ...int) *NArray {

	na := New(shape...)
	for i := range na.Data {
		na.Data[i] = r.NormFloat64()*sd + mean
	}
	return na
}

// Rand creates a new n-dimensional array whose
// elements are set using the rand.Float64 function.
// Values are pseudo-random numbers in [0.0,1.0).
func Rand(r *rand.Rand, shape ...int) *NArray {

	na := New(shape...)
	for i := range na.Data {
		na.Data[i] = r.Float64()
	}
	return na
}

// At returns the value for indices.
func (na *NArray) At(indices ...int) float64 {

	if len(indices) != na.Rank {
		fmt.Errorf("inconsistent number of indices for narray - [%d] vs [%d]", len(indices), na.Rank)
	}

	//	return na.Data[na.Index(indices...)]
	return na.Data[na.Index(indices...)]
}

// Set value for indices.
func (na *NArray) Set(v float64, indices ...int) {

	na.Data[na.Index(indices...)] = v
}

// Index transforms a set of subscripts to a an index in the underlying one-dimensional slice.
func (na *NArray) Index(indices ...int) int {

	idx := 0
	for k, v := range indices {
		idx += v * na.Strides[k]
	}
	return idx
}

// ReverseIndex converts a linear index to narray indices.
func (na *NArray) ReverseIndex(idx int) []int {

	res := make([]int, na.Rank, na.Rank)
	temp := idx
	p := 1
	for k := 1; k < na.Rank; k++ {
		p *= na.Shape[k]
	}
	for i := 0; i < na.Rank; i++ {
		res[i] = temp / p
		temp = temp % p
		if (i + 1) < na.Rank {
			p /= na.Shape[i+1]
		}
	}
	return res
}

// Copy returns a copy on the narray.
func (na *NArray) Copy() *NArray {

	newna := New(na.Shape...)
	copy(newna.Data, na.Data)
	return newna
}

// ApplyFunc is a type for creating custom functions.
type ApplyFunc func(x float64) float64

// Apply function of type ApplyFunc to a multidimensional array.
// If out is nil, a new object is allocated.
func Apply(out, in *NArray, fn ApplyFunc) *NArray {

	if out == nil {
		out = New(in.Shape...)
	}
	for i := 0; i < len(in.Data); i++ {
		out.Data[i] = fn(in.Data[i])
	}
	return out
}

// EqualShape returns true if all the arrays have equal length,
// and false otherwise. Returns true if there is only one input array.
func EqualShape(x *NArray, ys ...*NArray) bool {
	shape := x.Shape
	l := len(shape)
	for _, y := range ys {
		if len(y.Shape) != l {
			return false
		}
		for j, d := range shape {
			if y.Shape[j] != d {
				return false
			}
		}
	}
	return true
}

// Inc increments the value of an narray element.
func (na *NArray) Inc(v float64, indices ...int) {

	na.Data[na.Index(indices...)] += v
}

// MaxElem compares value to element and replaces element if
// value is greater than element.
func (na *NArray) MaxElem(v float64, indices ...int) {

	idx := na.Index(indices...)
	if v > na.Data[idx] {
		na.Data[idx] = v
	}
}

// MinElem compares value to element and replaces element if
// value is less than element.
func (na *NArray) MinElem(v float64, indices ...int) {

	idx := na.Index(indices...)
	if v < na.Data[idx] {
		na.Data[idx] = v
	}
}

// Add adds narrays elementwise.
//   out = sum_i(in[i])
// Will panic if there are not at least two input narrays
// or if narray shapes don't match.
// If out is nil a new array is created.
func Add(out *NArray, in ...*NArray) *NArray {

	if len(in) < 2 {
		return nil
	}
	if out == nil {
		out = New(in[0].Shape...)
	}
	if !EqualShape(out, in...) {
		panic("narrays must have equal shape.")
	}
	for i := 0; i < len(out.Data); i++ {
		for _, a := range in {
			out.Data[i] += a.Data[i]
		}
	}
	return out
}

// Mul multiplies narrays elementwise.
//   out = prod_i(in[i])
// Will panic if there are not at least two input narrays
// or if narray shapes don't match.
// If out is nil a new array is created.
func Mul(out *NArray, in ...*NArray) *NArray {

	if len(in) < 2 {
		panic("not in enough arguments")
	}
	if out == nil {
		out = New(in[0].Shape...)
	}
	if !EqualShape(out, in...) {
		panic("narrays must have equal shape.")
	}

	for i := 0; i < len(out.Data); i++ {
		out.Data[i] = in[0].Data[i] * in[1].Data[i]
	}

	// Case with more than two arguments.
	for k := 2; k < len(in); k++ {
		for i := 0; i < len(out.Data); i++ {
			out.Data[i] *= in[k].Data[i]
		}
	}
	return out
}

// AddConst adds const to an narray elementwise.
// out = in + c
// If out is nil a new array is created.
func AddConst(out *NArray, in *NArray, c float64) *NArray {

	if out == nil {
		out = New(in.Shape...)
	} else {
		if !EqualShape(out, in) {
			panic("narrays must have equal shape.")
		}
	}
	for i, v := range in.Data {
		out.Data[i] = v + c
	}
	return out
}

// AddScaled adds a scaled narray elementwise.
// y = y + a * x
// If y is nil a new array is created.
func AddScaled(y *NArray, x *NArray, a float64) *NArray {

	if y == nil {
		y = New(x.Shape...)
	} else {
		if !EqualShape(y, x) {
			panic("narrays must have equal shape.")
		}
	}
	for i, v := range x.Data {
		y.Data[i] += v * a
	}
	return y
}

// Scale multiplies an narray by a factor elementwise.
// out = c * in
// If out is nil a new array is created.
func Scale(out *NArray, in *NArray, c float64) *NArray {

	if out == nil {
		out = New(in.Shape...)
	} else {
		if !EqualShape(out, in) {
			panic("narrays must have equal shape.")
		}
	}
	for i, v := range in.Data {
		out.Data[i] = v * c
	}
	return out
}

// Rcp returns reciprocal values of narrays elementwise.
// out = 1.0 / in
// If out is nil a new array is created.
func Rcp(out, in *NArray) *NArray {
	if out == nil {
		out = New(in.Shape...)
	} else {
		if !EqualShape(out, in) {
			panic("narrays must have equal shape.")
		}
	}
	for k, v := range in.Data {
		out.Data[k] = 1.0 / v
	}
	return out
}

// Max returns the max value in the narray.
func (na *NArray) Max() float64 {

	max := -math.MaxFloat64
	for i := 0; i < len(na.Data); i++ {
		if na.Data[i] > max {
			max = na.Data[i]
		}
	}
	return max
}

// MaxIdx returns the max value and corresponding indices.
func (na *NArray) MaxIdx() (float64, []int) {

	var offset int
	max := -math.MaxFloat64
	for i := 0; i < len(na.Data); i++ {
		if na.Data[i] > max {
			max = na.Data[i]
			offset = i
		}
	}
	return max, na.ReverseIndex(offset)
}

// MaxArray compare input narrays and returns an narray containing
// the element-wise maxima.
//   out[i,j,k,...] = max(in0[i,j,k,...], in1[i,j,k,...], ...)
// Will panic if there are not at least two input narray
// or if narray shapes don't match.
// If out is nil a new array is created.
func MaxArray(out *NArray, in ...*NArray) *NArray {

	if len(in) < 2 {
		panic("not in enough input narrays")
	}
	if out == nil {
		out = New(in[0].Shape...)
	}
	if !EqualShape(out, in...) {
		panic("narrays must have equal shape.")
	}

	for i := 0; i < len(out.Data); i++ {
		max := math.Inf(-1)
		for k := 0; k < len(in); k++ {
			if in[k].Data[i] > max {
				max = in[k].Data[i]
			}
		}
		out.Data[i] = max
	}
	return out
}

// Min returns the min value in the narray.
func (na *NArray) Min() float64 {

	min := math.MaxFloat64
	for i := 0; i < len(na.Data); i++ {
		if na.Data[i] < min {
			min = na.Data[i]
		}
	}
	return min
}

// MinIdx returns the min value and corresponding indices.
func (na *NArray) MinIdx() (float64, []int) {

	var offset int
	min := math.MaxFloat64
	for i := 0; i < len(na.Data); i++ {
		if na.Data[i] < min {
			min = na.Data[i]
			offset = i
		}
	}
	return min, na.ReverseIndex(offset)
}

// MinArray compare input narrays and returns an narray containing
// the element-wise minima.
//   out[i,j,k,...] = min(in0[i,j,k,...], in1[i,j,k,...], ...)
// Will panic if there are not at least two input narray
// or if narray shapes don't match.
// If out is nil a new array is created.
func MinArray(out *NArray, in ...*NArray) *NArray {

	if len(in) < 2 {
		panic("not in enough input narrays")
	}
	if out == nil {
		out = New(in[0].Shape...)
	}
	if !EqualShape(out, in...) {
		panic("narrays must have equal shape.")
	}

	for i := 0; i < len(out.Data); i++ {
		min := math.Inf(1)
		for k := 0; k < len(in); k++ {
			if in[k].Data[i] < min {
				min = in[k].Data[i]
			}
		}
		out.Data[i] = min
	}

	return out
}

// Prod returns the products of all the elements in the narray.
func (na *NArray) Prod() float64 {

	p := 1.0
	for _, v := range na.Data {
		p *= v
	}
	return p
}

// Sum returns the sum of all the elements in the narray.
func (na *NArray) Sum() float64 {

	p := 0.0
	for _, v := range na.Data {
		p += v
	}
	return p
}

// SetValue sets all elements to value.
func (na *NArray) SetValue(v float64) *NArray {

	for i := range na.Data {
		na.Data[i] = v
	}
	return na
}

// Encode converts values in-place as follows:
//   Inf to math.MaxFloat64
//   -Inf to -math.MaxFloat64
//   NaN ro 0
//
// Returns the indices of the modified values as follows:
//   Values in inf => na.Data[abs(v)] = sign(v) * Inf
//   Values in nan => na.Data[v] = NaN
func (na *NArray) Encode() (inf, nan []int) {

	inf = []int{}
	nan = []int{}
	for k, v := range na.Data {
		switch {
		case math.IsInf(v, 1):
			na.Data[k] = math.MaxFloat64
			inf = append(inf, k)
		case math.IsInf(v, -1):
			na.Data[k] = -math.MaxFloat64
			inf = append(inf, -k)
		case math.IsNaN(v):
			na.Data[k] = 0
			nan = append(nan, k)
		}
	}
	return
}

// Decode converts values in-place.
// See Encode() for details.
func (na *NArray) Decode(inf, nan []int) {

	for _, v := range inf {
		if v >= 0 {
			na.Data[v] = math.Inf(1)
		} else {
			na.Data[-v] = math.Inf(-1)
		}
	}
	for _, v := range nan {
		na.Data[v] = math.NaN()
	}
}

// Vector returns a subarray of rank 1 as follows:
//
// Example, given a 5x10 matrix (rank=2), return the vector
// of dim 10 for row idx=3:
//
//   x := New(5,10)
//   y := x.SubArray(1,3) // dim=1, idx=3
//   // y = {x_30, x_31, ... , x_39}
//
func (na *NArray) Vector(dim, idx int) *NArray {

	if len(na.Shape) == 0 {
		panic("cannot get vector from narray with rank=0")
	}

	vLen := 1
	for k, v := range na.Shape {
		if k != dim {
			vLen *= v
		}
	}
	newArr := New(vLen)
	stride := na.Strides[dim]
	shape := na.Shape[dim]
	ncopies := vLen / stride
	inc := shape * stride
	end := 0
	to := 0
	start := stride * idx
	for i := 0; i < ncopies; i++ {
		end = start + stride
		copy(newArr.Data[to:], na.Data[start:end])
		start += inc
		to += stride
	}

	return newArr
}

// SubArray returns an narray of lower rank as follows:
//
// Example, given an narray with shape 2x3x4 (rank=3), return the subarray
// of rank=2 corresponding to dim[2]=1
//
//   x := New(2,3,4)
//   y := x.SubArray(-1,-1,1) // use -1 to select a dimension. Put a 1 in dim=2 (third argument).
//   // y = {x(0,0,1), x(0,1,1), x(0,2,1), x(1,0,1), ...}
//
func (na *NArray) SubArray(query ...int) *NArray {

	if len(na.Shape) == 0 {
		panic("cannot get subarray from narray with rank=0")
	}

	qs := querySubset(query, na.Shape)
	var ns []int // new shape
	for k, v := range query {
		if v < 0 {
			ns = append(ns, na.Shape[k])
		}
	}
	newArr := New(ns...)
	for k, v := range qs {
		newArr.Data[k] = na.At(v...)
	}

	return newArr
}

// Reshape returns an narray with a new shape.
func (na *NArray) Reshape(dim ...int) *NArray {
	panic("not implemented")
}

// Sprint prints narray elements when f returns true.
// index is the linear index of an narray.
func (na *NArray) Sprint(f func(na *NArray, index int) bool) string {

	b := bytes.NewBufferString(fmt.Sprintln("narray rank:  ", na.Rank))
	_, _ = b.WriteString(fmt.Sprintln("narray shape: ", na.Shape))
	for k, v := range na.Data {
		idx := na.ReverseIndex(k)
		if f(na, k) {
			_, _ = b.WriteString("[")
			for axis, av := range idx {
				_, _ = b.WriteString(formatted(av, na.Shape[axis]-1))
			}
			_, _ = b.WriteString(fmt.Sprintf("] => %f\n", v))
		}
	}
	return b.String()
}

// Read unmarshals json data from an io.Reader into an narray struct.
func Read(r io.Reader) (*NArray, error) {
	dec := json.NewDecoder(r)
	var na NArray
	err := dec.Decode(&na)
	if err != nil && err != io.EOF {
		return nil, err
	}
	return &na, nil
}

// ReadFile unmarshals json data from a file into an narray struct.
func ReadFile(fn string) (*NArray, error) {

	f, err := os.Open(fn)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	return Read(f)
}

// Write writes narray to an io.Writer.
func (na *NArray) Write(w io.Writer) error {

	enc := json.NewEncoder(w)
	err := enc.Encode(na)
	if err != nil {
		return err
	}
	return nil
}

// WriteFile writes an narray to a file.
func (na *NArray) WriteFile(fn string) error {

	e := os.MkdirAll(filepath.Dir(fn), 0755)
	if e != nil {
		return e
	}
	f, err := os.Create(fn)
	if err != nil {
		return err
	}
	defer f.Close()

	ee := na.Write(f)
	if ee != nil {
		return ee
	}
	return nil
}

// ToJSON returns a json string.
func (na *NArray) ToJSON() (string, error) {
	var b bytes.Buffer
	err := na.Write(&b)
	return b.String(), err
}

// MarshalJSON implements the json.Marshaller interface.
// The custom marshaller is needed to encode Inf/NaN values.
func (na *NArray) MarshalJSON() ([]byte, error) {

	ena := na.Copy()
	inf, nan := ena.Encode()
	return json.Marshal(struct {
		Rank    int       `json:"rank"`
		Shape   []int     `json:"shape"`
		Data    []float64 `json:"data"`
		Strides []int     `json:"strides"`
		Inf     []int     `json:"inf,omitempty"`
		NaN     []int     `json:"nan,omitempty"`
	}{
		Rank:    ena.Rank,
		Shape:   ena.Shape,
		Data:    ena.Data,
		Strides: ena.Strides,
		Inf:     inf,
		NaN:     nan,
	})
}

// UnmarshalJSON implements the json.Unarshaller interface.
// The custom unmarshaller is needed to decode Inf/NaN values.
func (na *NArray) UnmarshalJSON(b []byte) error {
	x := struct {
		Rank    int       `json:"rank"`
		Shape   []int     `json:"shape"`
		Data    []float64 `json:"data"`
		Strides []int     `json:"strides"`
		Inf     []int     `json:"inf,omitempty"`
		NaN     []int     `json:"nan,omitempty"`
	}{}

	err := json.Unmarshal(b, &x)
	if err != nil {
		return err
	}

	na.Rank = x.Rank
	na.Shape = x.Shape
	na.Data = x.Data
	na.Strides = x.Strides
	na.Decode(x.Inf, x.NaN)
	return nil
}

// String prints the narray
func (na *NArray) String() string {

	return na.Sprint(func(na *NArray, k int) bool {
		return true
	})
}

// equal returns true if |x-y|/(|avg(x,y)|+1) < tol.
func equal(x, y, tol float64) bool {
	avg := math.Abs(x+y) / 2.0
	sErr := math.Abs(x-y) / (avg + 1)
	if sErr > tol {
		return false
	}
	return true
}

// EqualValues compares two narrays elementwise.
// Returns true if for all elements |x-y|/(|avg(x,y)|+1) < tol.
func EqualValues(x *NArray, y *NArray, tol float64) bool {
	if !EqualShape(x, y) {
		panic("narrays must have equal shape.")
	}
	for i, _ := range x.Data {
		if !equal(x.Data[i], y.Data[i], tol) {
			return false
		}
	}
	return true
}

func formatted(n, max int) string {
	b := bytes.NewBufferString(" ")
	for i := 0; i < nd(max)-nd(n); i++ {
		_, _ = b.WriteString(" ")
	}
	_, _ = b.WriteString(strconv.FormatInt(int64(n), 10))
	return b.String()
}

// num digits in number
func nd(n int) int {
	if n == 0 {
		return 1
	}
	return int(math.Log10(float64(n))) + 1
}

func cartesianProduct(s []int) [][]int {

	if len(s) == 1 {
		z := make([][]int, s[0], s[0])
		for k := range z {
			z[k] = []int{k}
		}
		return z
	}
	var result [][]int
	for i := 0; i < s[0]; i++ {
		x := cartesianProduct(s[1:])
		for _, v := range x {
			var sl []int
			sl = append(sl, i)
			sl = append(sl, v...)
			result = append(result, sl)
		}
	}
	return result
}

// Recursively find indices for query q.
// Helper func to generate narray subsets.
func querySubset(q, s []int) [][]int {

	if len(q) != len(s) {
		panic("size mismatch")
	}
	var result [][]int

	switch {
	case len(s) == 1 && q[0] >= 0:
		result = [][]int{[]int{q[0]}}

	case len(s) == 1 && q[0] < 0:
		result = make([][]int, s[0], s[0])
		for k := range result {
			result[k] = []int{k}
		}

	case q[0] >= 0:
		x := querySubset(q[1:], s[1:])
		for _, v := range x {
			var sl []int
			sl = append(sl, q[0])
			sl = append(sl, v...)
			result = append(result, sl)
		}

	case q[0] < 0:
		for i := 0; i < s[0]; i++ {
			x := querySubset(q[1:], s[1:])
			for _, v := range x {
				var sl []int
				sl = append(sl, i)
				sl = append(sl, v...)
				result = append(result, sl)
			}
		}
	}
	return result
}
