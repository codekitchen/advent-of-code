#!/usr/bin/env ruby --yjit
require_relative '../../runner'

def run(input, result)
  stones = input.read.split.map(&:to_i)

  result.part1 stones.sum { |stone| evolve stone, 25 }
  result.part2 stones.sum { |stone| evolve stone, 75 }
end

CACHE = {}
def evolve(num, steps)
  return 1 if steps == 0
  CACHE[[num, steps]] ||= step(num).sum { evolve _1, steps-1 }
end

def step(stone)
  str = stone.to_s
  case
  when stone == 0
    [1]
  when str.length.even?
    half = str.length / 2
    [str[...half].to_i, str[half..].to_i]
  else
    [stone * 2024]
  end
end
