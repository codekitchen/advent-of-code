#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../grid'

# I implemented this using Bellman-Ford's pathfinding algorithm which supports negative
# edge weights. This turned out to not be necessary since I ended up treating each
# [pos,dir,steps] tuple as a separate node in the graph anyway, and didn't end up trying to
# map it to a problem with negative edge weights.
# I'm sure it'd run some degree faster using Djikstra's since the pqueue would help us
# find the goal faster, or A* since a good heuristic should be possible,
# but part2 completes in 25s so it's fine as is.

P = Struct.new(:pos, :dir, :steps) do
  def next
    moves = case dir
    when :u, :d then [:l, :r]
    else [:u, :d]
    end
    moves += [dir] unless steps >= 3
    moves.filter_map { |d| pos.send(d).then { |p| P[p, d, d==dir ? steps+1 : 1] if p } }
  end

  def next2
    # ULTRA CRUCIBLE 🤘
    moves = case dir
    when :u, :d then [:l, :r]
    else [:u, :d]
    end
    moves.clear if steps < 4
    moves << dir unless steps >= 10
    moves.filter_map { |d| pos.send(d).then { |p| P[p, d, d==dir ? steps+1 : 1] if p } }
  end
end

def part1(input)
  grid = Grid.from_input(input.read, &:to_i)
  opt = Hash.new(Float::INFINITY)
  start = grid.at(0,0)
  target = grid.at(grid.width-1,grid.height-1)
  q = [P[start,:r,0],P[start,:d,0]]
  q.each { opt[_1] = 0 }
  until q.empty?
    u = q.shift
    u.next.each do |v|
      new_cost = opt[u] + v.pos.get
      if new_cost < opt[v]
        opt[v] = new_cost
        q << v
      end
    end
  end
  opt.select { |p| p.pos == target }.values.min
end

def part2(input)
  grid = Grid.from_input(input.read, &:to_i)
  opt = Hash.new(Float::INFINITY)
  start = grid.at(0,0)
  target = grid.at(grid.width-1,grid.height-1)
  q = [P[start,:r,0],P[start,:d,0]]
  q.each { opt[_1] = 0 }
  until q.empty?
    u = q.shift
    u.next2.each do |v|
      # ULTRA CRUCIBLE RULES: don't allow a solution if steps < 4
      next if v.pos == target && v.steps < 4
      new_cost = opt[u] + v.pos.get
      if new_cost < opt[v]
        opt[v] = new_cost
        q << v
      end
    end
  end
  opt.select { |p| p.pos == target }.values.min
end
