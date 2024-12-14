#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

def part1(input)
  grid1 = Grid.from_input input
  grid2 = grid1.dup

  step = ->() do
    grid1.each do |cell|
      ncount = cell.neighbors_with_diag.count { _1 == '#' }
      newstate = if cell == '#'
        ncount == 2 || ncount == 3 ? '#' : '.'
      else
        ncount == 3 ? '#' : '.'
      end
      grid2.at(cell.x, cell.y).set(newstate)
    end
    grid1, grid2 = [grid2, grid1]
  end

  100.times { step.() }
  grid1.count { _1 == '#' }
end

def part2(input)
  grid1 = Grid.from_input input
  grid2 = grid1.dup

  grid1.each do |cell|
    cell.set '#' if cell.neighbors.count == 2
  end

  step = ->() do
    grid1.each do |cell|
      newstate = if cell.neighbors.count == 2
        '#'
      else
        ncount = cell.neighbors_with_diag.count { _1 == '#' }
        if cell == '#'
          ncount == 2 || ncount == 3 ? '#' : '.'
        else
          ncount == 3 ? '#' : '.'
        end
      end
      grid2.at(cell.x, cell.y).set(newstate)
    end
    grid1, grid2 = [grid2, grid1]
  end

  100.times { step.() }
  grid1.count { _1 == '#' }
end
