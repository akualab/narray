// +build amd64

package na64

import "math"

// These are function definitions for AMD64 optimized routines,
// and fallback that can be used for performance testing.
// See function documentation in arrayfuncs.go

// approx 2x faster than Go
func divSlice(out, a, b []float64)

func divSliceGo(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] / b[i]
	}
}

// approx 3x faster than Go
func addSlice(out, a, b []float64)

func addSliceGo(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] + b[i]
	}
}

// approx 3x faster than Go
func mulSlice(out, a, b []float64)

func mulSliceGo(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] * b[i]
	}
}

// approx 3x faster than Go
func subSlice(out, a, b []float64)

func subSliceGo(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] - b[i]
	}
}

// approx 4x faster than Go
func minSlice(out, a, b []float64)

func minSliceGo(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		if a[i] < b[i] {
			out[i] = a[i]
		} else {
			out[i] = b[i]
		}
	}
}

// approx 4x faster than Go
func maxSlice(out, a, b []float64)

func maxSliceGo(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		if a[i] > b[i] {
			out[i] = a[i]
		} else {
			out[i] = b[i]
		}
	}
}

// approx Xx faster than Go
func csignSlice(out, a, b []float64)

func csignSliceGo(out, a, b []float64) {
	const sign = 1 << 63
	for i := 0; i < len(out); i++ {
		out[i] = math.Float64frombits(math.Float64bits(a[i])&^sign | math.Float64bits(b[i])&sign)
	}
}

// approx 2x faster than Go
func cdivSlice(out, a []float64, c float64)

func cdivSliceGo(out, a []float64, c float64) {
	for i := 0; i < len(out); i++ {
		out[i] = c / a[i]
	}
}

// approx 3x faster than Go
func cmulSlice(out, a []float64, c float64)

func cmulSliceGo(out, a []float64, c float64) {
	for i := 0; i < len(out); i++ {
		out[i] = c * a[i]
	}
}

// approx 3x faster than Go
func caddSlice(out, a []float64, c float64)

func caddSliceGo(out, a []float64, c float64) {
	for i := 0; i < len(out); i++ {
		out[i] = c * a[i]
	}
}

// approx 3x faster than Go
func addScaledSlice(y, x []float64, a float64)

func addScaledSliceGo(y, x []float64, a float64) {
	for i, v := range x {
		y[i] += v * a
	}
}

// approx 2x faster than Go
func sqrtSlice(out, a []float64)

func sqrtSliceGo(out, a []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = math.Sqrt(a[i])
	}
}

// approx 12x faster than Go
func absSlice(out, a []float64)

func absSliceGo(out, a []float64) {
	for i, v := range a {
		out[i] = math.Abs(v)
	}
}

// approx 6x faster than Go
func minSliceElement(a []float64) float64

func minSliceElementGo(a []float64) float64 {
	min := math.MaxFloat64
	for i := 0; i < len(a); i++ {
		if a[i] < min {
			min = a[i]
		}
	}
	return min
}

// approx 6x faster than Go
func maxSliceElement(a []float64) float64

func maxSliceElementGo(a []float64) float64 {
	max := -math.MaxFloat64
	for i := 0; i < len(a); i++ {
		if a[i] > max {
			max = a[i]
		}
	}
	return max
}

// approx 4x faster than Go
func sliceSum(a []float64) float64

func sliceSumGo(a []float64) float64 {
	sum := 0.0
	for _, v := range a {
		sum += v
	}
	return sum
}
