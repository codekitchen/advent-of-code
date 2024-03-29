#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

# I like this other solution for part2.
# https://github.com/oliver-ni/advent-of-code/blob/master/py/2023/day13.py
# My solution modifies the string in each position, finds all reflections,
# and looks for a reflection that isn't the same as the original.
# This other solution just looks for almost-reflections that differ in exactly
# one position, instead. Much more elegant.

def parse(input)
  input.read.split("\n\n").map { |puz| puz.lines.map { _1.chomp.chars } }
end
def ppuz(puz) = puz.map(&:join).join("\n")

def lines_of_reflection(puz, diff=0)
  (0..puz.size-2).select do |i|
    left = puz[..i]
    right = puz[i+1..]
    sz = [left.size, right.size].min
    left.reverse[...sz].flatten.zip(right[...sz].flatten).count { |a,b| a != b } == diff
  end
end

def score(puz, diff=0)
  lines_of_reflection(puz, diff).map { 100*(_1+1) } +
  lines_of_reflection(puz.transpose, diff).map { _1+1 }
end

def part1(input)
  parse(input).sum { |puz| score(puz).first }
end

# def score2(puz)
#   scores = score(puz)
#   (0...puz.size).each do |y|
#     (0...puz[0].size).each do |x|
#       chr = puz[y][x]
#       puz[y][x] = chr == '#' ? '.' : '#'
#       s2 = score(puz)
#       news = s2 - scores
#       return news[0] if news[0]
#       puz[y][x] = chr
#     end
#   end
#   puts "no solution found for\n#{s1}\n#{puz.map(&:join).join("\n")}"
# end

def part2(input)
  # parse(input).sum { |puz| score2 puz }
  parse(input).sum { |puz| score(puz, 1).first }
end
