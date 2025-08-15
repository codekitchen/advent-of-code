package pqueue

type PQueue[T any] struct {
	items []item[T]
}

type item[T any] struct {
	value    T
	priority int64
}

func (q *PQueue[T]) Size() int {
	return len(q.items)
}

func (q *PQueue[T]) Push(value T, priority int64) {
	q.items = append(q.items, item[T]{value: value, priority: priority})
	q.up(len(q.items) - 1)
}

func (q *PQueue[T]) Peek() (T, int64, bool) {
	if len(q.items) == 0 {
		var zero T
		return zero, 0, false
	}
	return q.items[0].value, q.items[0].priority, true
}

func (q *PQueue[T]) Pop() (T, int64, bool) {
	if len(q.items) == 0 {
		var zero T
		return zero, 0, false
	}
	n := len(q.items) - 1
	q.swap(0, n)
	q.down(0, n)
	ret := q.items[n]
	q.items[n] = item[T]{}
	q.items = q.items[:n]
	return ret.value, ret.priority, true
}

func (q *PQueue[T]) up(j int) {
	// While the item at j is less than its parent, swap it with its parent.
	for {
		i := parent(j)
		if i < 0 || q.cmp(i, j) <= 0 {
			break
		}
		q.swap(i, j)
		j = i
	}
}

func (q *PQueue[T]) down(i, n int) {
	// If the item at i is greater than its right child, swap it with that.
	// Else if it's greater than its left child, swap it with that.
	// Repeat until the item at i is less than both children.
	// n is the length of the queue.
	if n <= 0 {
		return
	}
	for {
		j := leftchild(i)
		if j >= n {
			break
		}
		j2 := j + 1
		if j2 < n && q.cmp(j, j2) > 0 {
			j = j2
		}
		if q.cmp(i, j) <= 0 {
			break
		}
		q.swap(i, j)
		i = j
	}
}

func (q *PQueue[T]) cmp(i, j int) int64 {
	return q.items[i].priority - q.items[j].priority
}

func (q *PQueue[T]) swap(i, j int) {
	q.items[i], q.items[j] = q.items[j], q.items[i]
}

func parent(index int) int {
	return (index - 1) / 2
}

func leftchild(index int) int {
	return 2*index + 1
}
