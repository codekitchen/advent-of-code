#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  parens = input.read.chars

  counts = parens.tally
  results.part1(counts['('] - counts[')'])

  floor = 0
  parens.each_with_index do |c,i|
    floor += c == '(' ? 1 : -1
    if floor < 0
      results.part2(i+1)
      break
    end
  end
end
