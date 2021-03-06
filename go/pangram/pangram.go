// Package pangram solves the exercism exercise go/pangram
package pangram

const testVersion = 1

/* Alphabet interface which specifies if a runes belongs to the alphabet
and how many characters does the alphabet contains
*/
type Alphabet interface {
	runeInAlphabet(r rune) bool
	numberOfCharacters() int
}

/* AsciiAlphabet struct represents an alphabet of 26 characters using plain
ascii
*/
type AsciiAlphabet struct{}

/*
runeInAlphabet function tells if rune 'r' belongs to an alphabet
*/
func (a AsciiAlphabet) runeInAlphabet(r rune) bool {
	if len(string(r)) == 1 && (r >= 97 && r <= 122) || (r >= 65 && r <= 90) {
		return true
	}
	return false
}

/*
numberOfCharacters function tells how many characters does have an alphabet
*/
func (AsciiAlphabet) numberOfCharacters() int {
	return 26
}

/*
isPangram, given an alphabet and a sentence returns true if the sentence is a
pangram (if it contains all the characters in the alphabet). It returns false
otherwise
*/
func isPangram(a Alphabet, sentence string) bool {
	n := 0
	viewValues := make(map[rune]bool)
	for _, letter := range sentence {
		if !viewValues[letter] && a.runeInAlphabet(letter) {
			viewValues[letter] = true
			n++
		}
	}
	return n >= a.numberOfCharacters()
}

/*
IsPangram exported interface to compute if a sentence is a pangram
in an AsciiAlphabet
*/
func IsPangram(sentence string) bool {
	alphabet := AsciiAlphabet{}
	return isPangram(alphabet, sentence)
}
