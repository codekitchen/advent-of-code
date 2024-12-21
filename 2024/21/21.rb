#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

LAST_KEYPAD = Grid.new(3, 4, ["7", "8", "9", "4", "5", "6", "1", "2", "3", nil, "0", "A"])
KEYPAD = Grid.new(3, 2, [nil, :u, "A", :l, :d, :r])

def run(input, aoc)
  codes = input.readlines(chomp: true)

  lengths = lengths_for(codes, 2)
  aoc.part1 lengths.zip(codes).sum { |l,c| l * c[0,3].to_i }

  lengths = lengths_for(codes, 25)
  aoc.part2 lengths.zip(codes).sum { |l,c| l * c[0,3].to_i }
end

def lengths_for(codes, n_keypads)
  codes.map do |code|
    (['A'] + code.chars).each_cons(2).sum do |from, to|
      move(LAST_KEYPAD, from, to).map do |path|
        (['A']+path).each_cons(2).sum { |a,b| atdepth(a, b, n_keypads) }
      end.min
    end
  end
end

memoize def atdepth(from, to, d)
  return 1 if d == 0
  move(KEYPAD, from, to).map do |path|
    (['A']+path).each_cons(2).sum { |a,b| atdepth(a, b, d-1) }
  end.min
end

def move(grid, from, to)
  pos = grid.find(from)
  target = grid.find(to)
  dx = target.x - pos.x
  dy = target.y - pos.y
  dirx = dx < 0 ? :l : :r
  diry = dy < 0 ? :u : :d
  pathx = [dirx] * dx.abs
  pathy = [diry] * dy.abs
  # always move either all xs or all ys first,
  # to minimize movement on the next level up
  paths = []
  paths << pathx + pathy if pos.relative(dx, 0).value
  paths << pathy + pathx if pos.relative(0, dy).value
  paths.uniq.map { it + ['A'] }
end
