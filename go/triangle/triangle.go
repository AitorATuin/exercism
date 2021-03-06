// Package triangle solves exercism exercise go/triangle
package triangle

import (
	"math"
	"sort"
)

const testVersion = 3

// Kind of triangles (alias type??????!!!!!!! It sucks :P)
type Kind int

// Each triangle type is just an int
// But we are so cool that we call it Kind :P
const (
	NaT = iota
	Equ
	Iso
	Sca
)

type Triangle struct {
	a, b, c float64
	kind    Kind
}

// triangleInequality returns true if the triangle inequality fits for a, b, c
func triangleInequality(a, b, c float64) bool {
	sides := []float64{a, b, c}
	sort.Sort(sort.Float64Slice(sides))
	for _, side := range sides {
		if math.IsNaN(side) || math.IsInf(side, 1) || math.IsInf(side, -1) {
			return false
		}
	}
	if a <= 0 || b <= 0 || c <= 0 {
		return false
	}
	if a+b < c || a+c < b || c+b < a {
		return false
	}
	return true
}

func NewTriangle(a, b, c float64) Triangle {
	if !triangleInequality(a, b, c) {
		return Triangle{a, b, c, NaT}
	}
	if a == b && b == c {
		return Triangle{a, b, c, Equ}
	}
	if a == b || a == c || b == c {
		return Triangle{a, b, c, Iso}
	}
	return Triangle{a, b, c, Sca}
}

// Returns the kind of the triangle formed by sides a, b, c
func KindFromSides(a, b, c float64) Kind {
	return NewTriangle(a, b, c).kind
}
