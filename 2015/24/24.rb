#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  weights = parser(input, "{weight}")

  aoc.part1 arrange(weights, target: weights.sum / 3)
  aoc.part2 arrange(weights, target: weights.sum / 4)
end

def arrange weights, target:
  # starting with groups of size 1 and working up
  1.upto(weights.size) do |n|
    # sort by QE so we get the best solution first
    ps = weights.combination(n).sort_by { |ws| ws.reduce(:*) }
    # if we have a group that matches the target, we know the rest of the
    # packages will split evenly otherwise there would be no valid solution.
    # so there's no need to even check that the other groups are evenly weighted.
    found = ps.find { it.sum == target }
    return [found, found.reduce(:*)] if found
  end
  raise 'not found'
end
