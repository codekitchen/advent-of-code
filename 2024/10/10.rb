#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../grid'

def part1(input)
  map = Grid.from_input(input.read, &:to_i)
  trailheads = map.select { |c| c == 0 }
  trailheads.sum { |th| allpaths(th).uniq.count }
end

def part2(input)
  map = Grid.from_input(input.read, &:to_i)
  trailheads = map.select { |c| c == 0 }
  trailheads.sum { |th| allpaths(th).count }
end

def allpaths(th)
  found = []
  step = ->c do
    if c == 9
      found << c
    else
      c.neighbors.select { |n| n.value == c.value + 1 }.each { |n| step.(n) }
    end
  end
  step.(th)
  found
end
