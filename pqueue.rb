class PQueue
  Node = Data.define(:item, :priority) do
    def to_a
      [item, priority]
    end
  end

  def initialize
    @q = []
  end

  def push(item, priority)
    @q.push Node[item, priority]
    up(@q.length-1)
  end

  def pop_node
    n = @q.length-1
    swap(0,n)
    down(0,n)
    @q.pop
  end

  def pop = pop_node&.item
  def pop2 = pop_node&.to_a

  def peek = @q[0]&.item
  def peek2 = @q[0]&.to_a
  def empty? = @q.empty?
  def size = @q.size
  alias length size

  def heapify
    n = @q.length
    (n/2 - 1).downto(0) { |i| down(i,n) }
  end

  def cmp(i,j)
    @q[i].priority <=> @q[j].priority
  end

  # move the node up the tree as far as needed
  def up(j)
    loop do
      i = (j-1) / 2 # parent
      break if i < 0 || i == j || cmp(i, j) <= 0
      swap i, j
      j = i
    end
  end

  # move the node down the tree as far as needed
  def down(i,n)
    loop do
      j = 2*i + 1 # left child
      break if j >= n
      j2 = j+1 # right child
      j = j2 if j2 < n && cmp(j,j2) > 0
      break if cmp(i,j) <= 0
      swap(i,j)
      i = j
    end
  end

  def swap i,j
    t = @q[i]
    @q[i] = @q[j]
    @q[j] = t
  end
end

if __FILE__ == $0
  require_relative 'asserts'
  q = PQueue.new
  [5, 3, 9, 6, 4].each { q.push(_1, _1) }
  assert_eq q.pop, 3
  assert_eq q.pop, 4
  assert_eq q.pop, 5
  assert_eq q.pop, 6
  q.push 11, 11
  q.push 3, 3
  assert_eq q.pop, 3
  assert_eq q.pop2, [9, 9]
  assert_eq q.pop, 11
  assert_eq q.pop, nil
  puts "tests passed"
end
