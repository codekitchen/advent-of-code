#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  starts = input.readlines(chomp: true)
  numbers = starts.map { |num| 2000.times.map { num = next_num(num.to_i) } }
  aoc.part1 numbers.map(&:last).sum

  prices = numbers.map { |ns| ns.map { |n| n % 10 } }
  changes = prices.map { |ps| [nil] + ps.each_cons(2).map { |a,b| b-a } }

  values = Hash.new(0)
  prices.zip(changes) do |plist,clist|
    seen = Set[]
    clist.each_index do |i|
      next if i < 4 # skip the initial nil price change as well
      pat = clist[i-3, 4]
      next unless seen.add?(pat)
      values[pat] += plist[i]
    end
  end
  aoc.part2 values.max_by { |k,v| v }
end

def next_num(num)
  num = ((num * 64) ^ num) % 16777216
  num = ((num / 32) ^ num) % 16777216
  num = ((num * 2048) ^ num) % 16777216
  num
end
