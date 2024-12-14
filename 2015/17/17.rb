#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  cs = input.readlines.map(&:to_i)
  goal = cs.shift
  cs.sort! { _2 <=> _1 }

  found = []
  1.upto(cs.size).each do |n|
    cs.combination(n).each { |ns| found << ns if ns.sum == goal }
  end
  results.part1 found.size

  counts = found.map(&:size).tally.min_by { |a,b| a }
  results.part2 counts
end
