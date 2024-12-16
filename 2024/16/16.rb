#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'
require_relative '../../pqueue'

Pos = Data.define(:cell, :facing)

TURNS = {
  l: [:u, :d],
  r: [:u, :d],
  u: [:l, :r],
  d: [:l, :r],
}

def run(input, results)
  map = Grid.from_input input
  start = map.find('S')
  finish = map.find('E')
  neighbors = ->(p,&cb) {
    TURNS[p.facing].each { |dir| cb.([Pos[p.cell, dir], 1000]) }
    newcell = p.cell.send(p.facing)
    cb.([Pos[newcell, p.facing], 1]) if newcell != '#'
  }

  q = PQueue.new { |a,b| a[1] <=> b[1] }
  qstart = Pos[start, :r]
  # node, cost, path
  q.push([qstart, 0, [qstart]])
  solutions = []
  visited = Hash.new(Float::INFINITY)
  upper_bound = Float::INFINITY

  until q.empty?
    u, cost, path = q.pop
    if u.cell == finish
      solutions << [cost, path]
      upper_bound = cost if upper_bound > cost
      next
    end
    next if upper_bound < cost
    neighbors.(u) do |v,v_cost|
      new_cost = cost + v_cost
      next if visited[v] < new_cost
      visited[v] = new_cost
      q.push([v, new_cost, path + [v]])
    end
  end

  best = solutions.map(&:first).min
  results.part1 best

  on_path = Set[]
  solutions.select { |c,_| c == best }.each { |_,p| on_path.merge(p.map(&:cell)) }
  results.part2 on_path.size
end
