require_relative 'pqueue'

# Not quite a timing wheel https://blog.acolyer.org/2015/11/23/hashed-and-hierarchical-timing-wheels/
# But a similar idea: hash of { priority => list_of_items },
# then a separate priority queue with list of priorities, so we can have dynamic step sizes.
# Optimized for multiple items with each priority, but large gaps between priorities.
# If you squint, that describes a scheduler. Thus "timing wheel".
class Wheel
  Bucket = Data.define(:priority, :list)

  def initialize
    @q = PQueue.new() { |a,b| a.priority <=> b.priority }
    @buckets = {}
  end

  def push(item, priority)
    bucket = @buckets[priority]
    unless bucket
      bucket = Bucket[priority, []]
      @buckets[priority] = bucket
      @q << bucket
    end
    bucket.list << item
  end

  def pop
    loop do
      bucket = @q.peek
      return nil unless bucket
      if bucket.list.empty?
        @q.pop
        @buckets.delete bucket.priority
        next
      end
      return bucket.list.pop
    end
  end
end

if __FILE__ == $0
  require_relative 'asserts'
  q = Wheel.new
  [5, 3, 9, 6, 4].each { q.push _1, _1 }
  assert_eq q.pop, 3
  assert_eq q.pop, 4
  assert_eq q.pop, 5
  assert_eq q.pop, 6
  q.push 11, 11
  q.push 3, 3
  q.push 3, 3
  assert_eq q.pop, 3
  assert_eq q.pop, 3
  assert_eq q.pop, 9
  assert_eq q.pop, 11
  assert_eq q.pop, nil
  puts "tests passed"
end
