require 'set'

input = ARGF.read.chars

input.each_cons(4).each_with_index do |chars, i|
  if Set.new(chars).length == 4
    p i+4
    break
  end
end

input.each_cons(14).each_with_index do |chars, i|
  if Set.new(chars).length == 14
    p i+14
    break
  end
end
