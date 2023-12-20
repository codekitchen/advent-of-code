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
  yield_state = ->{Fiber.yield energized:, grid:}
  yield_state.()

  beams = [[start, start_dir]]
  until beams.empty?
    beams, current = [], beams
    current.each do |beam|
      next if beams_seen.include?(beam)
      beams_seen << beam

      pos, dir = beam
      energized[pos.x,pos.y] = '#'
      moves = [MOVES[pos.get][dir]].flatten
      moves.each { |mv| nw = pos.send(mv); beams << [nw,mv] if nw }
    end
    yield_state.()
  end

  # puts energized
  energized.count('#') # aka beams_seen.uniq(&:first).count
end

def part1(input)
  grid = Grid.from_input input.read
  count_energized(grid)
end

def part2(input)
  grid = Grid.from_input input.read
  max = 0
  (0...grid.width).each { |x| max = [max, count_energized(grid, P[x,0], :d)].max }
  (0...grid.width).each { |x| max = [max, count_energized(grid, P[x,grid.height-1], :u)].max }
  (0...grid.height).each { |y| max = [max, count_energized(grid, P[0,y], :r)].max }
  (0...grid.height).each { |y| max = [max, count_energized(grid, P[grid.width-1,y], :l)].max }
  max
end

###
# Another experiment, not using Grid
###

class P < Array
  def +(p2) = P[*self.zip(p2).map{_1+_2}]
end

UP = P[0,-1]
DOWN = P[0,1]
LEFT = P[-1,0]
RIGHT = P[1,0]

def count_energized_new(grid, start=P[0,0], start_dir=RIGHT)
  grid = grid.cells.to_h { |p| [P[p.x, p.y], p.get] }
  seen = Set.new

  beams = [[start, start_dir]]
  until beams.empty?
    beam = beams.shift
    pos, dir = beam
    next if !grid.key?(pos) || seen.include?(beam)
    seen << beam
    case grid[pos]
    in "/"
      dir = P[-dir[1], -dir[0]]
      beams << [pos+dir,dir]
    in "\\"
      dir = P[dir[1], dir[0]]
      beams << [pos+dir,dir]
    in "|" if dir[1] == 0
      beams << [pos+UP,UP]
      beams << [pos+DOWN,DOWN]
    in "-" if dir[0] == 0
      beams << [pos+LEFT,LEFT]
      beams << [pos+RIGHT,RIGHT]
    else
      beams << [pos+dir,dir]
    end
  end
  seen.map(&:first).uniq.count
end
