class PQueueImplicit
  def initialize
    @pos = 0
    @buckets = {}
  end

  def push(item, priority)
    raise "priority #{priority} is less than current position #{@pos}" if priority < @pos
    bucket = @buckets[priority]
    unless bucket
      bucket = []
      @buckets[priority] = bucket
    end
    bucket << item
  end

  def pop
    loop do
      return nil if @buckets.empty?
      @pos += 1 while !@buckets[@pos]
      bucket = @buckets[@pos]
      item = bucket.pop
      if bucket.empty?
        @buckets.delete(@pos)
      end
      return item
    end
  end

  def pop2
    return pop, @pos
  end
end

if __FILE__ == $0
  require_relative 'asserts'
  q = PQueueImplicit.new
  [5, 3, 9, 6, 4].each { q.push _1, _1 }
  assert_eq q.pop, 3
  assert_eq q.pop, 4
  assert_eq q.pop, 5
  assert_eq q.pop, 6
  q.push 11, 11
  q.push 6, 6
  q.push 8, 8
  assert_eq q.pop, 6
  assert_eq q.pop, 8
  assert_eq q.pop, 9
  assert_eq q.pop, 11
  assert_eq q.pop, nil
  puts "tests passed"
end
