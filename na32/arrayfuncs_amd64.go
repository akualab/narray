// +build amd64

package na32

import "math"

// These are function definitions for AMD64 optimized routines,
// and fallback that can be used for performance testing.
// See function documentation in arrayfuncs.go

// approx 8x faster than Go
func divSlice(out, a, b []float32)

func divSliceGo(out, a, b []float32) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] / b[i]
	}
}

// approx 8x faster than Go
func addSlice(out, a, b []float32)

func addSliceGo(out, a, b []float32) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] + b[i]
	}
}

// approx 8x faster than Go
func mulSlice(out, a, b []float32)

func mulSliceGo(out, a, b []float32) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] * b[i]
	}
}

// approx 8x faster than Go
func subSlice(out, a, b []float32)

func subSliceGo(out, a, b []float32) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] - b[i]
	}
}

// approx 8x faster than Go
func minSlice(out, a, b []float32)

func minSliceGo(out, a, b []float32) {
	for i := 0; i < len(out); i++ {
		if a[i] < b[i] {
			out[i] = a[i]
		} else {
			out[i] = b[i]
		}
	}
}

// approx 8x faster than Go
func maxSlice(out, a, b []float32)

func maxSliceGo(out, a, b []float32) {
	for i := 0; i < len(out); i++ {
		if a[i] > b[i] {
			out[i] = a[i]
		} else {
			out[i] = b[i]
		}
	}
}

// approx 4x faster than Go
func cdivSlice(out, a []float32, c float32)

func cdivSliceGo(out, a []float32, c float32) {
	for i := 0; i < len(out); i++ {
		out[i] = c / a[i]
	}
}

// approx 5x faster than Go
func cmulSlice(out, a []float32, c float32)

func cmulSliceGo(out, a []float32, c float32) {
	for i := 0; i < len(out); i++ {
		out[i] = c * a[i]
	}
}

// approx 5x faster than Go
func caddSliceGo(out, a []float32, c float32)

func caddSlice(out, a []float32, c float32) {
	for i := 0; i < len(out); i++ {
		out[i] = c + a[i]
	}
}

// approx 13x faster than Go
func addScaledSlice(y, x []float32, a float32)

func addScaledSliceGo(y, x []float32, a float32) {
	for i, v := range x {
		y[i] += v * a
	}
}

// approx 11x faster than Go
func sqrtSlice(out, a []float32)

func sqrtSliceGo(out, a []float32) {
	for i := 0; i < len(out); i++ {
		out[i] = float32(math.Sqrt(float64(a[i])))
	}
}

// approx 18x faster than Go
func absSlice(out, a []float32)

func absSliceGo(out, a []float32) {
	for i, v := range a {
		out[i] = float32(math.Abs(float64(v)))
	}
}

// approx 15x faster than Go
func minSliceElement(a []float32) float32

func minSliceElementGo(a []float32) float32 {
	min := float32(math.MaxFloat32)
	for i := 0; i < len(a); i++ {
		if a[i] < min {
			min = a[i]
		}
	}
	return min
}

// approx 15x faster than Go
func maxSliceElement(a []float32) float32

func maxSliceElementGo(a []float32) float32 {
	max := float32(-math.MaxFloat32)
	for i := 0; i < len(a); i++ {
		if a[i] > max {
			max = a[i]
		}
	}
	return max
}

// approx 8x faster than Go
func sliceSum(a []float32) float32

func sliceSumGo(a []float32) float32 {
	sum := float32(0.0)
	for _, v := range a {
		sum += v
	}
	return sum
}
