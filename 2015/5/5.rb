#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def part1(input)
  input.read.lines.count { nice? _1 }
end

def part2(input)
  input.read.lines.count { nice2? _1 }
end

def nice?(string)
  return false if ['ab', 'cd', 'pq', 'xy'].any? { string.include?(_1) }
  return false unless string =~ %r{([a-z])\1}
  return false unless string =~ %r{[aeiou].*[aeiou].*[aeiou]}
  true
end
assert_eq true, nice?('ugknbfddgicrmopn')
assert_eq true, nice?('aaa')
assert_eq false, nice?('jchzalrnumimnmhp')
assert_eq false, nice?('haegwjzuvuyypxyu')
assert_eq false, nice?('dvszwmarrgswjxmb')

def nice2?(string)
  !!(string =~ %r{([a-z]{2}).*\1} && string =~ %r{([a-z]).\1})
end
assert_eq true, nice2?('qjhvhtzxzqqjkmpb')
assert_eq true, nice2?('xxyxx')
assert_eq false, nice2?('uurcxstgmygtbstg')
assert_eq false, nice2?('ieodomkazucvgmuy')
