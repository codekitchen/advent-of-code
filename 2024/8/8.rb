#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

def part1(input)
  antinodes = Set.new
  map = Grid.from_input(input.read)
  map.select { _1 != '.' }
  .group_by(&:value)
  .each do |k,cells|
    cells.permutation(2) do |a,b|
      dx = b.x-a.x
      dy = b.y-a.y
      antinode = map.at(a.x+dx+dx, a.y+dy+dy)
      antinodes << antinode if antinode
    end
  end
  antinodes.size
end

def part2(input)
  antinodes = Set.new
  map = Grid.from_input(input.read)
  map.select { _1 != '.' }
  .group_by(&:value)
  .each do |k,cells|
    cells.permutation(2) do |a,b|
      dx = b.x-a.x
      dy = b.y-a.y
      cell = map.at(a.x, a.y)
      while cell
        antinodes << cell
        cell = cell.relative(dx, dy)
      end
    end
  end
  antinodes.size
end
