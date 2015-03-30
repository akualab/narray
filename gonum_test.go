// Copyright (c) 2015 AKUALAB INC., All rights reserved.
//
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package narray

import "testing"

func TestMatrix(t *testing.T) {

	mat := na234.Matrix(0, -1, -1)
	t.Log(mat)

	row0 := mat.Row(nil, 0)
	row1 := mat.Row(nil, 1)
	row2 := mat.Row(nil, 2)
	col0 := mat.Col(nil, 0)
	col1 := mat.Col(nil, 1)
	col2 := mat.Col(nil, 2)
	col3 := mat.Col(nil, 3)

	t.Log(row0)
	t.Log(row1)
	t.Log(row2)
	t.Log(col0)
	t.Log(col1)
	t.Log(col2)
	t.Log(col3)

	na := na234.SubArray(1, 2, -1)
	vec := na234.Vector(1, 2, -1)
	if !EqualValues(na, (*NArray)(vec), 0) {
		t.Fatalf("expected same values")
	}

	na = na234.SubArray(-1, 2, -1)
	mat = na234.Matrix(-1, 2, -1)
	if !EqualValues(na, (*NArray)(mat), 0) {
		t.Fatalf("expected same values")
	}
}
