require_relative 'parse'

def assert_eq(a,b)
  return if a == b
  raise "#{a.inspect} != #{b.inspect}"
end
def assert_neq(a,b)
  return if a != b
  raise "#{a.inspect} == #{b.inspect}"
end

# Enumerable#find, but return the block value rather than the original value
module Enumerable
  def find_map(if_none=nil)
    each do
      ret = yield _1
      return ret if ret
    end
    if_none.() if if_none
  end
end

# produce until nil/false returned
def unfold(seed=nil)
  Enumerator.produce(seed) { yield(_1) || raise(StopIteration) }
end
