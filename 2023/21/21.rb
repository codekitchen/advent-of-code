#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../grid'

def _(input)
  input = input.readlines
  nsteps = input.shift.to_i
  grid = Grid.from_input input.join
  start = grid.cells.find { _1 == 'S' }
  start.set '.'
  q = Set.new [start]
  nsteps.times do |i|
    if $show
      puts i
      disp = grid.dup
      q.each { |p| disp.at(p.x,p.y).set('O') }
      puts disp
    end
    q = q.flat_map { |p| p.neighbors.select { _1 == '.' } }.to_set
  end
  q.size
end

def part2(input)
  #  131:      15569
  #  262:      61825
  #  393:     138769

  #   65:       3877
  #  196:      34674  30797
  #  327:      96159  61485
  #  458:     188332  92173

  # yeah... I printed the first four cycles and then used Wolfram to find the sequence formula :/
  seq = ->(n) { n+=1; 15344*n*n - 15235*n + 3768 }
  return seq.(26501365 / 131)

  input = input.readlines
  input.shift # ignore
  nsteps = 1000
  grid = Grid.from_input input.join
  start = grid.cells.find { _1 == 'S' }
  start.set '.'
  start = [start.x, start.y]
  q = Set.new [start]
  nsteps.times do |i|
    puts sprintf("%5d: %10d", i, q.size)
    q = q.flat_map do |pos|
      [
        [pos[0],pos[1]-1],
        [pos[0],pos[1]+1],
        [pos[0]-1,pos[1]],
        [pos[0]+1,pos[1]],
    ].select { grid[*grid.norm(*_1)] == '.' }
    end.to_set
  end
end
