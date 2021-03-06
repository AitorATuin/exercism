// Package pascal implements pascals-triangle go
package pascal

const testVersion = 1

func fillRow(row int, previousRow []int) []int {
	result := make([]int, row+1)
	for j := 0; j <= row; j++ {
		// always one in both extremes
		if j == 0 || j == row {
			result[j] = 1
		} else {
			// value at j is always the value j-1 + value j from previous row
			result[j] = previousRow[j-1] + previousRow[j]
		}
	}
	return result
}

// Triangle implements the pascal triangle with n rows
func Triangle(n int) [][]int {
	result := make([][]int, n)
	// Fill row 0
	result[0] = []int{1}
	// Fill rows 1 to n
	for i := 1; i < n; i++ {
		result[i] = fillRow(i, result[i-1])
	}
	return result
}
