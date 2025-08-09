def assert_eq(a,b)
  return if a == b
  raise "#{a.inspect} != #{b.inspect}"
end

def assert_neq(a,b)
  return if a != b
  raise "#{a.inspect} == #{b.inspect}"
end
