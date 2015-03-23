// +build !amd64

package narray

// These are the fallbacks that are used when not on AMD64 platform.

// divSlice divides two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func divSlice(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] / b[i]
	}
}

// mulSlice multiply two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func mulSlice(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] * b[i]
	}
}

// cdivSlice will return c / values of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func cdivSlice(out, a []float64, c float64) {
	for i := 0; i < len(out); i++ {
		out[i] = c / a[i]
	}
}

// cmulSlice will return c * values of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func cmulSlice(out, a []float64, c float64) {
	for i := 0; i < len(out); i++ {
		out[i] = c * a[i]
	}
}
