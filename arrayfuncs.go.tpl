// +build !amd64

package {{.Package}}

import (
	"math"
)

// These are the fallbacks that are used when not on AMD64 platform.

// divSlice divides two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func divSlice(out, a, b []{{.Format}}) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] / b[i]
	}
}

// addSlice adds two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func addSlice(out, a, b []{{.Format}}) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] + b[i]
	}
}

// subSlice subtracts two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func subSlice(out, a, b []{{.Format}}) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] - b[i]
	}
}

// mulSlice multiply two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func mulSlice(out, a, b []{{.Format}}) {
	for i := 0; i < len(out); i++ {
		out[i] = a[i] * b[i]
	}
}

// minSlice returns lowest valus of two slices
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func minSlice(out, a, b []{{.Format}}) {
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
func maxSlice(out, a, b []{{.Format}}) {
	for i := 0; i < len(out); i++ {
		if a[i] > b[i] {
			out[i] = a[i]
		} else {
			out[i] = b[i]
		}
	}
}

// csignSlice returns a value with the magnitude of a and the sign of b
// for each element in the slice.
// Assumptions the assembly can make:
// out != nil, a != nil, b != nil
// len(out)  == len(a) == len(b)
func csignSlice(out, a, b []{{.Format}}) {
{{if .Float64}}	const sign = 1 << 63 {{end}}{{if .Float32}}	const sign = 1 << 31 {{end}}
	for i := 0; i < len(out); i++ {
{{if .Float64}}			out[i] = math.Float64frombits(math.Float64bits(a[i])&^sign | math.Float64bits(b[i])&sign){{end}}
{{if .Float32}}			out[i] = math.Float32frombits(math.Float32bits(a[i])&^sign | math.Float32bits(b[i])&sign){{end}}
    }
}

// cdivSlice will return c / values of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func cdivSlice(out, a []{{.Format}}, c {{.Format}}) {
	for i := 0; i < len(out); i++ {
		out[i] = c / a[i]
	}
}

// cmulSlice will return c * values of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func cmulSlice(out, a []{{.Format}}, c {{.Format}}) {
	for i := 0; i < len(out); i++ {
		out[i] = c * a[i]
	}
}

// caddSlice will return c * values of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func caddSlice(out, a []{{.Format}}, c {{.Format}}) {
	for i := 0; i < len(out); i++ {
		out[i] = c + a[i]
	}
}

// addScaledSlice adds a scaled narray elementwise.
// y = y + a * x
// Assumptions the assembly can make:
// y != nil, a != nil
// len(x)  == len(y)
func addScaledSlice(y, x []{{.Format}}, a {{.Format}}) {
	for i, v := range x {
		y[i] += v * a
	}
}

// sqrtSlice will return math.Sqrt(values) of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func sqrtSlice(out, a []{{.Format}}) {
	for i := 0; i < len(out); i++ {
		out[i] = {{.Format}}(math.Sqrt(float64(a[i])))
	}
}

// minSliceElement will the smallest value of the slice
// Assumptions the assembly can make:
// a != nil
// len(a) > 0
func minSliceElement(a []{{.Format}}) {{.Format}} {
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
func maxSliceElement(a []{{.Format}}) {{.Format}} {
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
func sliceSum(a []{{.Format}}) {{.Format}} {
	sum := {{.Format}}(0.0)
	for _, v := range a {
		sum += v
	}
	return sum
}

// absSlice will return math.Abs(values) of the array
// Assumptions the assembly can make:
// out != nil, a != nil
// len(out)  == len(a)
func absSlice(out, a []{{.Format}}) {
	for i, v := range a {
		out[i] = {{.Format}}(math.Abs(float64(v)))
	}
}
