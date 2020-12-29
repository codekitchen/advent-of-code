package main

import "fmt"

// const input = "389125467" // example
const input = "418976235" // real
const pt2 = true

func main() {
	var moves, cuplen int
	if pt2 {
		moves = 10_000_000
		cuplen = 1_000_001
	} else {
		moves = 100
		cuplen = len(input) + 1
	}

	// parse input
	init := make([]int, len(input))
	for idx, c := range input {
		init[idx] = int(c - '0')
	}

	// build cups array
	cups := make([]int, cuplen)
	cups[init[len(init)-1]] = init[0]
	for idx := 1; idx < len(init); idx++ {
		cups[init[idx-1]] = init[idx]
	}
	if pt2 {
		cups[init[len(init)-1]] = len(init) + 1
		for idx := len(init) + 1; idx < 1_000_000; idx++ {
			cups[idx] = idx + 1
		}
		cups[1_000_000] = init[0]
	}

	cur := init[0]
	min := 1
	max := len(cups) - 1

	for move := 1; move <= moves; move++ {
		pick := [3]int{cups[cur], cups[cups[cur]], cups[cups[cups[cur]]]}
		picked := func(dest int) bool {
			return pick[0] == dest || pick[1] == dest || pick[2] == dest
		}

		var dest int
		for dest = cur; dest == cur || picked(dest); {
			dest--
			if dest < min {
				dest = max
			}
		}
		// fmt.Printf("\n-- move %d --\n", move)
		// fmt.Printf("cups: %v\n", cups)
		// fmt.Printf("pick up: %v\n", pick)
		// fmt.Printf("destination: %d\n", dest)
		prev := cups[dest]
		cups[dest] = pick[0]
		cups[cur] = cups[pick[2]]
		cups[pick[2]] = prev
		cur = cups[cur]
	}

	if pt2 {
		a := cups[1]
		b := cups[a]
		fmt.Printf("%d * %d = %d", a, b, a*b)
	} else {
		for cur = cups[1]; cur != 1; cur = cups[cur] {
			fmt.Print(cur)
		}
	}
	fmt.Println()

}
