#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  messages = input.readlines(chomp: true)
  tallies = messages.first.size.times.map { Hash.new(0) }
  messages.each  { |m| m.chars.zip(tallies) { |c,t| t[c] += 1 } }

  most = tallies.map { |t| t.max_by(&:last).first }
  aoc.part1 most.join

  least = tallies.map { |t| t.min_by(&:last).first }
  aoc.part2 least.join
end
