package main

import (
	"fmt"
	"slices"
	"time"

	"github.com/codekitchen/advent-of-code/other/pqueue"
)

type state struct {
	doc       int
	clipboard int
}

type action string

type result struct {
	cost int64
	prev state
	edge action
}

func Pathfind() (state, map[state]result) {
	// var q wheel.Wheel[state]
	var q pqueue.PQueue[state]
	q.Push(state{1, 0}, 0)
	solved := func(s state) bool {
		return s.doc == 100_001
	}
	results := make(map[state]result)
	results[state{1, 0}] = result{}
	neighbors := func(s state, cb func(state, int64, action)) {
		// paste
		cb(state{s.doc + s.clipboard, s.clipboard}, 1, "P")
		// select-and-copy
		cb(state{s.doc, s.doc}, 2, "SC")
		// delete a char
		if s.doc > 0 {
			cb(state{s.doc - 1, s.clipboard}, 1, "D")
		}
	}

	t := time.Now()
	for {
		u, cost, ok := q.Pop()
		if !ok {
			break
		}
		if solved(u) {
			return u, results
		}
		if time.Since(t) > 5*time.Second {
			fmt.Println("cost:", cost)
			t = time.Now()
		}
		neighbors(u, func(v state, edge_cost int64, edge action) {
			newCost := cost + edge_cost
			previously, hasprev := results[v]
			if hasprev && previously.cost <= newCost {
				return
			}
			results[v] = result{newCost, u, edge}
			q.Push(v, newCost)
		})
	}
	var zero state
	return zero, results
}

func main() {
	final, res := Pathfind()
	fmt.Println("results:", len(res))
	cost := res[final].cost
	var actions []action
	cur := final
	for res[cur].edge != "" {
		actions = append(actions, res[cur].edge)
		cur = res[cur].prev
	}
	slices.Reverse(actions)
	fmt.Println("cost:", cost)
	fmt.Println("steps:", len(actions))
	fmt.Println("actions:", actions)
}
