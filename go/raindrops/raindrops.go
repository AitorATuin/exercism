// Package raindrops implements exercism exercise go/raindrops
package raindrops

import (
	"fmt"
)

const testVersion = 2

func convertRec(number int, output string, viewedFactors int) string {
	if viewedFactors%3 != 0 && number%3 == 0 {
		return convertRec(number/3, fmt.Sprintf("%s%s", output, "Pling"), viewedFactors*3)
	}
	if viewedFactors%5 != 0 && number%5 == 0 {
		return convertRec(number/5, fmt.Sprintf("%s%s", output, "Plang"), viewedFactors*5)
	}
	if viewedFactors%7 != 0 && number%7 == 0 {
		return convertRec(number/7, fmt.Sprintf("%s%s", output, "Plong"), viewedFactors*7)
	}
	if viewedFactors == 1 {
		return fmt.Sprintf("%d", number)
	}
	return output
}

// Convert function computes raindrops for a number
func Convert(number int) string {
	return convertRec(number, "", 1)
}
