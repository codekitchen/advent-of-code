#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../grid'
require_relative '../../pathfinding'

# I implemented this using Bellman-Ford's pathfinding algorithm which supports negative
# edge weights. This turned out to not be necessary since I ended up treating each
# [pos,dir,steps] tuple as a separate node in the graph anyway, and didn't end up trying to
# map it to a problem with negative edge weights.
# I'm sure it'd run some degree faster using Dijkstra's since the pqueue would help us
# find the goal faster, or A* since a good heuristic should be possible,
# but part2 completes in 25s so it's fine as is.

P = Struct.new(:pos, :dir, :steps) do
  def next
    moves = case dir
    when :u, :d then [:l, :r]
    else [:u, :d]
    end
    moves += [dir] unless steps >= 3
    moves.filter_map { |d| pos.send(d).then { |p| neighbor(p,d) if p } }
  end

  def next2
    # ULTRA CRUCIBLE 🤘
    moves = case dir
    when :u, :d then [:l, :r]
    else [:u, :d]
    end
    moves.clear if steps < 4
    moves << dir unless steps >= 10
    moves.filter_map { |d| pos.send(d).then { |p| neighbor(p,d) if p } }
  end

  def neighbor(pos, newdir) = [P[pos, newdir, newdir==dir ? steps+1 : 1], pos.get]
  def distance(pos2) = (pos2.y-pos.y) + (pos2.x-pos.x)
end

def part1(input)
  grid = Grid.from_input(input.read, &:to_i)
  start = grid.at(0,0)
  target = grid.at(grid.width-1,grid.height-1)
  starts = [P[start,:r,0],P[start,:d,0]]

  neighbors = :next.to_proc
  solved = ->p { p.pos == target }
  costs = pathfind(starts:, neighbors:, solved:)
  costs.select { |p,| p.pos == target }.values.min
end

def part2(input)
  grid = Grid.from_input(input.read, &:to_i)
  start = grid.at(0,0)
  target = grid.at(grid.width-1,grid.height-1)
  starts = [P[start,:r,0],P[start,:d,0]]

  # ULTRA CRUCIBLE RULES: don't allow a solution if steps < 4
  neighbors = ->p{ p.next2.reject { |p,| p.pos == target && p.steps < 4 } }
  solved = ->p { p.pos == target }
  costs = pathfind(starts:, neighbors:, solved:)
  costs.select { |p,| p.pos == target }.values.min
end
