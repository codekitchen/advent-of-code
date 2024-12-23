#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  lines = input.readlines(chomp: true)

  aoc.part1 lines.sum { compressed_size it }
  aoc.part2 nil
end

def compressed_size(line)
  idx = 0

end
