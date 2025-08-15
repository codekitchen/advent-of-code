package wheel

import "testing"

func TestWheel(t *testing.T) {
	q := Wheel[any]{}
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

func TestWheelValue(t *testing.T) {
	w := Wheel[string]{}
	expectPop := func(want string) {
		t.Helper()
		if got, _, _ := w.Pop(); got != want {
			t.Error("Pop() = ", got, "want", want)
		}
	}
	expectPop("")
	w.Push("5", 5)
	w.Push("5", 5)
	w.Push("5", 5)
	w.Push("3", 3)
	w.Push("11", 11)
	expectPop("3")
	expectPop("5")
	expectPop("5")
	w.Push("2", 2)
	expectPop("2")
	expectPop("5")
	expectPop("11")
	expectPop("")
}
