#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  triangles = input.readlines.map { it.split.map(&:to_i) }
  valid = triangles.count { |(a,b,c)| valid_tri(a,b,c) }
  aoc.part1 valid

  valid = 0
  (0...triangles.size).step(3) do |row|
    (0...3).each do |col|
      valid += 1 if valid_tri(triangles[row][col], triangles[row+1][col], triangles[row+2][col])
    end
  end
  aoc.part2 valid
end

def valid_tri(a,b,c) = a+b>c && a+c>b && b+c>a
