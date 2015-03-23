// +build amd64

package narray

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
func mulSlice(out, a, b []float64)

func mulSliceGo(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] * b[i]
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
