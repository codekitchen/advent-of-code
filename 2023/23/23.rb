#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../pathfinding'
require_relative '../grid'

SLOPES = { '>'=>:r, '<'=>:l, 'v'=>:d, '^'=>:u }

CellWithPrev = Data.define(:cell, :prev)

def part1(input)
  grid = Grid.from_input input.read
  startpos = grid.cells.find { _1=='.' }
  starts = [CellWithPrev[startpos,nil]]
  finishpos = grid[0.., grid.height-1].cells.find { _1=='.' }

  neighbors = proc do |cwp|
    cwp => [pos,prev]
    dir = SLOPES[pos.get]
    res = []
    if dir
      raise 'wtf' if pos.send(dir) == prev
      res << [CellWithPrev[pos.send(dir),pos],-1]
    else
      res << [CellWithPrev[pos.u,pos],-1] if pos.u && pos.u != prev && !'#v'.include?(pos.u.get)
      res << [CellWithPrev[pos.d,pos],-1] if pos.d && pos.d != prev && !'#^'.include?(pos.d.get)
      res << [CellWithPrev[pos.l,pos],-1] if pos.l && pos.l != prev && !'#>'.include?(pos.l.get)
      res << [CellWithPrev[pos.r,pos],-1] if pos.r && pos.r != prev && !'#<'.include?(pos.r.get)
    end
    res
  end
  pathfind(starts:, neighbors:, negatives:true) => prev:, costs:
  best,cost = costs.select { _1.cell == finishpos }.sort_by(&:last).first
  pos = best
  until pos.cell == startpos
    pos.cell.set('O')
    # puts pos
    # puts grid
    pos = prev[pos]
  end
  pos.cell.set('S')
  # puts grid
  -cost
end

P2 = Data.define(:cell, :prev, :intersections)

def part2(input)
  dry = input.read.gsub(/[<>v^]/, 'i')
  grid = Grid.from_input dry
  startpos = grid.cells.find { _1=='.' }
  starts = [P2[startpos,nil,Set.new]]
  finishpos = grid[0.., grid.height-1].cells.find { _1=='.' }

  neighbors = proc do |cwp|
    cwp => [pos,prev,intersections]
    res = []
    intersections += [pos] if pos == 'i'
    res << [P2[pos.u,pos,intersections],-1] if pos.u && pos.u != '#' && pos.u != prev && !intersections.include?(pos.u)
    res << [P2[pos.d,pos,intersections],-1] if pos.d && pos.d != '#' && pos.d != prev && !intersections.include?(pos.d)
    res << [P2[pos.l,pos,intersections],-1] if pos.l && pos.l != '#' && pos.l != prev && !intersections.include?(pos.l)
    res << [P2[pos.r,pos,intersections],-1] if pos.r && pos.r != '#' && pos.r != prev && !intersections.include?(pos.r)
    res
  end
  pathfind(starts:, neighbors:, negatives:true) => prev:, costs:
  best,cost = costs.select { _1.cell == finishpos }.sort_by(&:last).first
  pos = best
  until pos.cell == startpos
    pos.cell.set('O')
    # puts pos
    # puts grid
    pos = prev[pos]
  end
  pos.cell.set('S')
  # puts grid
  -cost
end
