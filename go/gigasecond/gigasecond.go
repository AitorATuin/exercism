package gigasecond

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"time"
)

const testVersion = 4

func AddGigasecond(t0 time.Time) time.Time {
	g := strconv.FormatFloat(math.Pow10(9), 'f', -1, 64)
	d, err := time.ParseDuration(fmt.Sprintf("%ss", g))
	if err != nil {
		fmt.Printf("Error: %s\n", err.Error())
		os.Exit(1)
	}
	return t0.Add(d)
}
