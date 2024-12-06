#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

def part1(input)
  grid = Grid.from_input(input.read)
  grid.cells.sum do |start|
    next(0) if start.get != 'X'
    Grid::DIRS8.count { |dir| mas?(start.send(dir), dir) }
  end
end

def mas?(pos, dir)
  return unless pos && pos.get == 'M'
  return unless (pos = pos.send(dir)) && pos.get == 'A'
  return unless (pos = pos.send(dir)) && pos.get == 'S'
  true
end

def part2(input)
  grid = Grid.from_input(input.read)
  4.times.sum do |i|
    grid = grid.rotate_cw()
    grid.each_index.count do |x,y|
      mas?(grid.at(x,y), :rd) && mas?(grid.at(x+2,y), :ld)
    end
  end
end
