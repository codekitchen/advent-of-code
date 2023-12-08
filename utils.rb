# easier way to write simple regexp captures
# based on behavior of the nushell parse command
# parse("{loc} = ({l}, {r})") returns a regexp to capture those groups
def parse(pattern)
  s = Regexp.escape(pattern).gsub(/\\\{(\w+)\\\}/) { |m| "(?<#{m[2...-2]}>\\w+)" }
  Regexp.new(s)
end

def assert_eq(a,b)
  return if a == b
  raise "#{a.inspect} != #{b.inspect}"
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
