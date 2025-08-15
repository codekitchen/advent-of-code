package wheel

import "github.com/codekitchen/advent-of-code/other/pqueue"

type Wheel[T any] struct {
	q       pqueue.PQueue[struct{}]
	buckets map[int64]*bucket[T]
}

type bucket[T any] []T

func (w *Wheel[T]) Push(value T, priority int64) {
	w.init()
	b, ok := w.buckets[priority]
	if !ok {
		b = &bucket[T]{}
		w.buckets[priority] = b
		w.q.Push(struct{}{}, priority)
	}
	*b = append(*b, value)
}

func (w *Wheel[T]) Pop() (T, int64, bool) {
	var zero T
	for {
		_, priority, ok := w.q.Peek()
		if !ok {
			return zero, 0, false
		}
		b := w.buckets[priority]
		if len(*b) == 0 {
			delete(w.buckets, priority)
			w.q.Pop()
			continue
		}
		return b.pop(), priority, true
	}
}

func (b *bucket[T]) pop() T {
	var zero T
	i := len(*b) - 1
	ret := (*b)[i]
	(*b)[i] = zero
	*b = (*b)[:i]
	return ret
}

func (w *Wheel[T]) init() {
	if w.buckets == nil {
		w.buckets = make(map[int64]*bucket[T])
	}
}
