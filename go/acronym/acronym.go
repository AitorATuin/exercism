// Package acronym implements exercism exercise go/acronym
package acronym

import (
	"fmt"
	"regexp"
	"strings"
)

const testVersion = 2

func abbreviateRec(words []string, output string) string {
	if len(words) == 0 {
		return output
	}
	word := string(words[0])
	firstLetter := string(word[0])
	return abbreviateRec(words[1:], fmt.Sprintf("%s%s", output, strings.ToUpper(firstLetter)))
}

// Abbreviate computes the acronyms for text
func Abbreviate(text string) string {
	words := regexp.MustCompile("[A-Z]+[a-z]*|[a-z]+")
	return abbreviateRec(words.FindAllString(text, -1), "")
}
