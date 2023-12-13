#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def unfold(row, nums, n=5) = [([row]*n).join('?'), nums.cycle(n).to_a]
assert_eq unfold('.#', [1], 5), ['.#?.#?.#?.#?.#', [1,1,1,1,1]]

def parse_count(str, nums, memo={})
  n = nums[0] || 0
  memo[[str, nums]] ||= case str
  when nil, ''
    nums.empty? ? 1 : 0
  when /^[.]/
    # blank, just skip
    parse_count(str[1..], nums, memo)
  when /^[?][#?]{#{n-1}}(?![#])/
    # leading ?, so go both ways
    # take this parse
    parse_count(str[n+1..], nums[1..], memo) +
    # skip this parse
    parse_count(str[1..], nums, memo)
  when /^[#][#?]{#{n-1}}(?![#])/
    # leading #, take this parse
    parse_count(str[n+1..], nums[1..], memo)
  when /^[#]/
    # leading # but no parse, no solution
    0
  else # leading ? but no parse
    # skip this parse
    parse_count(str[1..], nums, memo)
  end
end

def parse(line)
  field, nums = line.split(' ')
  nums = nums.split(',').map(&:to_i)
  [field, nums]
end

def part1(input)
  input.readlines.sum { |l| parse_count(*parse(l)) }
end

def part2(input)
  input.readlines.sum { |l| parse_count(*unfold(*parse(l))) }
end
