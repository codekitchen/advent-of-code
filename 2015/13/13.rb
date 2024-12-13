#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

FORMAT = "{a} would {dir} {amt} happiness units by sitting next to {b}."

def run(input, results)
  rules = Hash.new(0)
  parser(input, FORMAT).each do |a,dir,amt,b|
    amt = -amt if dir == 'lose'
    rules[Set[a,b]] += amt
  end
  guests = rules.keys.reduce(:+)

  results.part1 guests.to_a.permutation.map { score _1, rules }.max

  guests << "me"
  # missing rules will all default to 0
  results.part2 guests.to_a.permutation.map { score _1, rules }.max
end

def score seating, rules
  # intentionally wrap around to -1 to get the [-1,0] pair
  (-1 .. seating.length-2).sum { |i| rules[Set[seating[i], seating[i+1]]] }
end
