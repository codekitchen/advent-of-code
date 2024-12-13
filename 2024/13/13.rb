#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

INPUT = "Button A: X+{ax}, Y+{ay} Button B: X+{bx}, Y+{by} Prize: X={x}, Y={y}"

def run(input, results)
  # my parser doesn't do multi-line, needs some help here
  machines = parser(input.read.gsub(/\n(?!\n)/, ' '), INPUT, nums: :to_r)

  sols = machines.map { [_1, solve(_1)] }
  valid = sols.select { |m,s| valid?(m, s) }
  results.part1(valid.sum { |m,(a,b)| (a*3+b).to_i })

  mega = machines.map { |m| m=m.dup; m[4] += 10000000000000; m[5] += 10000000000000; m }
  sols = mega.map { [_1, solve(_1)] }
  valid = sols.select { |m,s| valid?(m, s) }
  results.part2(valid.sum { |m,(a,b)| (a*3+b).to_i })
end

def solve m
  ax, ay, bx, by, x, y = m
  # solved on paper
  a = ((y*bx)/by - x) / ((ay*bx)/by - ax)
  b = (x - a*ax) / bx
  [a.to_i, b.to_i]
end

def valid? m, s
  ax, ay, bx, by, x, y = m
  a, b = s
  a*ax + b*bx == x && a*ay + b*by = y
end
