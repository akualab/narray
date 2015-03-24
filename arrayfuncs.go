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

// addSlice adds two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func addSlice(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] + b[i]
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

// minSlice returns lowest valus of two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func minSlice(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		if a[i] < b[i] {
			out[i] = a[i]
		} else {
			out[i] = b[i]
		}
	}
}

// maxSlice return maximum of two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func maxSlice(out, a, b []float64) {
	for i := 0; i < len(out); i++ {
		if a[i] > b[i] {
			out[i] = a[i]
		} else {
			out[i] = b[i]
		}
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

// caddSlice will return c * values of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func caddSlice(out, a []float64, c float64) {
	for i := 0; i < len(out); i++ {
		out[i] = c + a[i]
	}
}

// sqrtSlice will return math.Sqrt(values) of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func sqrtSlice(out, a []float64) {
	for i := 0; i < len(out); i++ {
		out[i] = math.Sqrt(a[i])
	}
}

// minSliceElement will the smallest value of the slice
// Assumptions the assembly can make:
// a != nil
// len(a) > 0
func minSliceElement(a []float64) float64 {
	min := a[0]
	for i := 1; i < len(a); i++ {
		if a[i] < min {
			min = a[i]
		}
	}
	return min
}

// maxSliceElement will the biggest value of the slice
// Assumptions the assembly can make:
// a != nil
// len(a) > 0
func maxSliceElement(a []float64) float64 {
	max := a[0]
	for i := 1; i < len(a); i++ {
		if a[i] > max {
			max = a[i]
		}
	}
	return max
}

// sliceSum will return the sum of all elements of the slice
// Assumptions the assembly can make:
// a != nil
// len(a) >= 0
func sliceSum(a []float64) float64 {
	sum := 0
	for _, v := range a {
		sum += v
	}
	return sum
}
