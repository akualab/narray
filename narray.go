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

import "math"

// The NArray object.
type NArray struct {
	// The rank or order or degree of the narray is the dimensionality required to represent it. (eg. The rank of a vector is 2)
	Rank int
	// The shape is an int slice that contains the size of each dimension. Subscripts range from zero to s-1. Where s is the size of a dimension.
	Shape []int
	// The data is stored as a slice of float64 numbers.
	Data []float64
	// Strides for each dimension.
	Strides []int
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

// At returns the value for indices.
func (na *NArray) At(indices ...int) float64 {

	return na.Data[na.Index(indices...)]
}

// Set value for indices.
func (na *NArray) Set(v float64, indices ...int) {

	na.Data[na.Index(indices...)] = v
}

// Inc increments the value of an narray element.
func (na *NArray) Inc(v float64, indices ...int) {

	na.Data[na.Index(indices...)] += v
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

// Add adds narrays elementwise.
// If out is nil a new array is created.
func Add(out *NArray, in ...*NArray) *NArray {

	if len(in) == 0 {
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

// Sub subtracts narrays elementwise.
// out = in0 - in1 - in2 - ...
// If out is nil a new array is created.
func Sub(out *NArray, in ...*NArray) *NArray {

	if len(in) == 0 {
		return nil
	}
	if out == nil {
		out = New(in[0].Shape...)
	}
	if !EqualShape(out, in...) {
		panic("narrays must have equal shape.")
	}
	for i := 0; i < len(out.Data); i++ {
		out.Data[i] = in[0].Data[i]
		for j := 1; j < len(in); j++ {
			out.Data[i] -= in[j].Data[i]
		}
	}
	return out
}

// Div divides two narrays elementwise.
// out = in0 / in1
// If out is nil a new array is created.
func Div(out *NArray, in0, in1 *NArray) *NArray {

	if out == nil {
		out = New(in0.Shape...)
	}
	if !EqualShape(out, in0, in1) {
		panic("narrays must have equal shape.")
	}
	for i := 0; i < len(out.Data); i++ {
		out.Data[i] = in0.Data[i] / in1.Data[i]
	}
	return out
}

// Mul multiplies two narrays elementwise.
// out = in0 * in1
// If out is nil a new array is created.
func Mul(out *NArray, in0, in1 *NArray) *NArray {

	if out == nil {
		out = New(in0.Shape...)
	}
	if !EqualShape(out, in0, in1) {
		panic("narrays must have equal shape.")
	}
	for i := 0; i < len(out.Data); i++ {
		out.Data[i] = in0.Data[i] * in1.Data[i]
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
	for i := 0; i < len(out.Data); i++ {
		out.Data[i] = in.Data[i] + c
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
	for i := 0; i < len(y.Data); i++ {
		y.Data[i] = x.Data[i] + a
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
	for i := 0; i < len(out.Data); i++ {
		out.Data[i] = in.Data[i] * c
	}
	return out
}

// Max returns the max value in the narray.
func (na *NArray) Max() float64 {

	max := math.SmallestNonzeroFloat64
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
	max := math.SmallestNonzeroFloat64
	for i := 0; i < len(na.Data); i++ {
		if na.Data[i] > max {
			max = na.Data[i]
			offset = i
		}
	}
	return max, na.ReverseIndex(offset)
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

// Prod returns the products of all the elements in the narray.
func (na *NArray) Prod() float64 {

	p := 1.0
	for i := 0; i < len(na.Data); i++ {
		p *= na.Data[i]
	}
	return p
}

// Sum returns the sum of all the elements in the narray.
func (na *NArray) Sum() float64 {

	p := 0.0
	for i := 0; i < len(na.Data); i++ {
		p += na.Data[i]
	}
	return p
}

// SetValue sets all elements to value.
func (na *NArray) SetValue(v float64) *NArray {

	for i := 0; i < len(na.Data); i++ {
		na.Data[i] = v
	}
	return na
}

// SubArray returns a subset based on a list of dimensions.
//
// Example:
//   // For 2x2 matrix return a vector
//   x := New(2,2)
//   y := x.SubArray(1)
//
//func (na *NArray) SubArray(ranges ...Range) *NArray {

//}
