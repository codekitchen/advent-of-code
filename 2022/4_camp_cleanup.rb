require 'set'
require 'active_support/core_ext'

pairs = ARGF.each_line.map { |l|
  l.split(',').map {
    Range.new(*_1.split('-').map(&:to_i))
  }
}
contained = pairs.select { |a,b|
  a = a.to_set
  b = b.to_set
  [a,b].include?(a | b)
}
p contained.size

overlaps = pairs.select { |a,b|
  (a.begin <= b.begin && a.end >= b.begin) || (b.begin <= a.begin && b.end >= a.begin)
}
p overlaps.size
