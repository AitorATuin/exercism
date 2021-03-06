// Package secret implements exercism exercise secret_handshake/go
package secret

const testVersion = 1

// secretAction reprensents a function [str] -> [str]
type secretAction func([]string) []string

// secretCode represents a code and its tranformation
type secretCode struct {
	code   uint
	action secretAction
}

// Define some transformations
func wink(xs []string) []string {
	return append(xs, "wink")
}

func doubleBlink(xs []string) []string {
	return append(xs, "double blink")
}

func closeYourEyes(xs []string) []string {
	return append(xs, "close your eyes")
}

func jump(xs []string) []string {
	return append(xs, "jump")
}

func reverse(xs []string) []string {
	ys := make([]string, len(xs))
	// This really sucks! :P This is supposed to be a high level language
	// Maybe there is a better way to do this.
	for i, j := len(xs)-1, 0; i >= 0; i, j = i-1, j+1 {
		ys[j] = xs[i]
	}
	return ys
}

// secrets returns the secretCodes we use in this assignment
func secrets() []secretCode {
	return []secretCode{
		secretCode{1, wink},
		secretCode{2, doubleBlink},
		secretCode{4, closeYourEyes},
		secretCode{8, jump},
		secretCode{16, reverse},
	}
}

// Handshake uses the secretCodes to do somethin valuable!
func Handshake(value uint) []string {
	var result []string
	secretCodes := secrets()
	for _, secretCode := range secretCodes {
		if (value & secretCode.code) == secretCode.code {
			result = secretCode.action(result)
		}
	}
	return result
}
