parts = ->(str) { l = str.length; [str[...l/2], str[l/2..]] }
shared = ->(a, *others) { a.each_char.find { |c| others.all? { _1.include?(c) } } }
priority = ->(a) { a < ?a ? a.ord - 38 : a.ord - 96 }

input = ARGF.each_line.map(&:chomp)

priorities = input.map do
  lr = parts.(_1)
  l = shared.(*lr)
  priority.(l)
end
p priorities.sum

badges = input.each_slice(3).map do |sacks|
  badge = shared.(*sacks)
  priority.(badge)
end
p badges.sum
