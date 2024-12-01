#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def parse(input)
  left = []; right = []
  input.readlines.each { |line| l,r=line.split; left << l.to_i; right << r.to_i }
  left.sort!; right.sort!
  return left, right
end

def part1(input)
  left, right = parse input
  left.zip(right).sum { |l,r| (l-r).abs }
end

def part2(input)
  left, right = parse input
  left.sum { |l| l * right.count{_1 == l} }
end
