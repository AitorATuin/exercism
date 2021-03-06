// Package bob implements exercism exercise go/bob
package bob

import (
	"strings"
)

const testVersion = 2 // same as targetTestVersion

func areYouQuestioning(input string) bool {
	runes := []byte(strings.TrimSpace(input))
	return runes[len(runes)-1] == []byte("?")[0]
}

func areYouYelling(input string) bool {
	return strings.ToUpper(input) == input && strings.ToLower(input) != input
}

func nothingToSay(input string) bool {
	return len(strings.TrimSpace(input)) == 0
}

// Hey functions is bob brain
func Hey(input string) string {
	if nothingToSay(input) {
		return "Fine. Be that way!"
	}
	if areYouYelling(input) {
		return "Whoa, chill out!"
	}
	if areYouQuestioning(input) {
		return "Sure."
	}
	return "Whatever."
}
