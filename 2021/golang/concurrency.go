// goroutines cerner_2tothe5th_2021
package main

import (
	"fmt"
	"time"
)

func say(s string) {
	for i := 0; i < 5; i++ {
		fmt.Println("Starting sleep", s, i)
		time.Sleep(100 * time.Millisecond)
	}
}

func main() {
	go say("thread")
	say("main")
}
