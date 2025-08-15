package pqueue

import "testing"

func TestPQueue(t *testing.T) {
	q := PQueue[any]{}
	expectPop := func(want int64) {
		t.Helper()
		if _, got, _ := q.Pop(); got != want {
			t.Error("Pop() = ", got, "want", want)
		}
	}
	expectPop(0)
	q.Push(nil, 5)
	q.Push(nil, 3)
	q.Push(nil, 9)
	q.Push(nil, 6)
	q.Push(nil, 4)
	expectPop(3)
	expectPop(4)
	expectPop(5)
	expectPop(6)
	q.Push(nil, 11)
	q.Push(nil, 3)
	expectPop(3)
	expectPop(9)
	expectPop(11)
	expectPop(0)
}
