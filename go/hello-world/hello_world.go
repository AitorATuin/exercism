/*
hello-word from exercism in go
*/
package greeting

import (
	"fmt"
)

const testVersion = 3

// Returns "Hello, 'name'!" for every value of name.
// If name is "" then it returns "Hello, World!"
func HelloWorld(name string) string {
	switch name {
	case "":
		return "Hello, World!"
	default:
		return fmt.Sprintf("Hello, %s!", name)
	}
}
