#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../grid'

MOVES = {
  ?/  => { l: :d, u: :r, r: :u, d: :l },
  ?\\ => { l: :u, d: :r, r: :d, u: :l },
  ?|  => { u: :u, d: :d, l: [:u, :d], r: [:u, :d] },
  ?-  => { l: :l, r: :r, u: [:l, :r], d: [:l, :r] },
  ?.  => { l: :l, r: :r, u: :u, d: :d },
}

def count_energized(grid, start=[0,0], start_dir=:r)
  start = grid.at(*start)
  energized = Grid.new(grid.width, grid.height, seed: '.')
  beams_seen = Set.new

  beams = [[start, start_dir]]
  until beams.empty?
    beams_seen += beams
    next_beams = []
    beams.each do |pos,dir|
      energized[pos.x,pos.y] = '#'
      moves = [MOVES[pos.get][dir]].flatten
      moves.each { |mv| nw = pos.send(mv); next_beams << [nw,mv] if nw }
    end
    beams = next_beams.to_set - beams_seen
  end

  # puts energized
  energized.count('#')
end

def part1(input)
  grid = Grid.from_input input.read
  count_energized(grid)
end

def part2(input)
  grid = Grid.from_input input.read
  max = 0
  (0...grid.width).each { |x| max = [max, count_energized(grid, [x,0], :d)].max }
  (0...grid.width).each { |x| max = [max, count_energized(grid, [x,grid.height-1], :u)].max }
  (0...grid.height).each { |y| max = [max, count_energized(grid, [0,y], :r)].max }
  (0...grid.height).each { |y| max = [max, count_energized(grid, [grid.width-1,y], :l)].max }
  max
end
