class PQueue
  def initialize(els=[], &cmp)
    @q = [].replace(Array(els))
    @cmp = cmp || ->(a,b) { a <=> b }
    heapify
  end

  def push(item)
    @q.push item
    up(@q.length-1)
  end
  alias :<< push

  def pop
    n = @q.length-1
    swap(0,n)
    down(0,n)
    @q.pop
  end

  def peek = @q[0]
  def empty? = @q.empty?
  def size = @q.size
  alias length size

  def heapify
    n = @q.length
    (n/2 - 1).downto(0) { |i| down(i,n) }
  end

  def cmp(i,j)
    @cmp.(@q[i], @q[j])
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
  [5, 3, 9, 6, 4].each { q << _1 }
  assert_eq q.pop, 3
  assert_eq q.pop, 4
  assert_eq q.pop, 5
  assert_eq q.pop, 6
  q << 11
  q << 3
  assert_eq q.pop, 3
  assert_eq q.pop, 9
  assert_eq q.pop, 11
  assert_eq q.pop, nil
  puts "tests passed"
end
