// Package clock implements clock from exercism in go
package clock

import (
	"fmt"
)

const testVersion = 4

// Clock struct representing a clock
type Clock struct {
	hours   int
	minutes int
}

func reduceHours(hours int) int {
	remainderHours := hours % 24
	if hours < 0 {
		return 24 + remainderHours
	}
	return remainderHours
}

func reduceMinutes(minutes int) Clock {
	remainderMinutes := minutes % 60
	extraHours := minutes / 60

	if minutes < 0 {
		return Clock{reduceHours(extraHours - 1), 60 + remainderMinutes}
	}
	return Clock{reduceHours(extraHours), remainderMinutes}
}

// New function, creates a new Clock
func New(hours, minutes int) Clock {
	reducedMinutes := reduceMinutes(minutes)
	return Clock{
		reduceHours(hours + reducedMinutes.hours),
		reducedMinutes.minutes,
	}
}

func (c Clock) String() string {
	return fmt.Sprintf("%.02d:%.02d", c.hours, c.minutes)
}

// Add function, adds minutes to a Clock
func (c Clock) Add(minutes int) Clock {
	return New(reduceHours(c.hours), c.minutes+minutes)
}
