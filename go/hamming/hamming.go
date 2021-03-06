// Package hamming implements exercism exercise go/hamming
package hamming

import "errors"

const testVersion = 5

// recDistance, recursive function computing the real hamming distance between
// a and b
func recDistance(runesA, runesB []rune, mutations int, i int, n int) (int, error) {
	if i >= n && mutations > 0 {
		return mutations, nil
	}
	if i >= n {
		return mutations, nil
	}
	if runesA[i] != runesB[i] {
		return recDistance(runesA, runesB, mutations+1, i+1, n)
	}
	return recDistance(runesA, runesB, mutations, i+1, n)
}

// Distance computes the Hamming distance between a and b
func Distance(a, b string) (int, error) {
	runesA := []rune(a)
	runesB := []rune(b)
	if len(a) != len(b) {
		return 0, errors.New("Strings have different length")
	}
	return recDistance(runesA, runesB, 0, 0, len(a))
}
