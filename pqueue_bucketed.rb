require_relative 'pqueue'

# Not quite a timing wheel https://blog.acolyer.org/2015/11/23/hashed-and-hierarchical-timing-wheels/
# But a similar idea: hash of { priority => list_of_items },
# then a separate priority queue with list of priorities, so we can have dynamic step sizes.
# Optimized for multiple items with each priority, but large gaps between priorities.
# If you squint, that describes a scheduler. Thus "timing wheel".
class PQueueBucketed
  def initialize
    @q = PQueue.new
    @buckets = {}
  end

  def push(item, priority)
    bucket = @buckets[priority]
    unless bucket
      bucket = []
      @buckets[priority] = bucket
      @q.push(bucket, priority)
    end
    bucket << item
  end

  def pop
    loop do
      bucket, priority = @q.peek2
      return nil unless bucket
      if bucket.empty?
        @q.pop
        @buckets.delete priority
        next
      end
      return bucket.pop
    end
  end

  def pop2
    loop do
      bucket, priority = @q.peek2
      return nil unless bucket
      if bucket.empty?
        @q.pop
        @buckets.delete priority
        next
      end
      return bucket.pop, priority
    end
  end
end

if __FILE__ == $0
  require_relative 'asserts'
  q = PQueueBucketed.new
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
