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

  q = PQueue.new
  qstart = Pos[start, :r]
  q.push(qstart, 0)
  prev = {}
  dist = Hash.new(Float::INFINITY)

  until q.empty?
    u, cost = q.pop2
    neighbors.(u) do |v,v_cost|
      new_cost = cost + v_cost
      prev_cost = dist[v]
      next if prev_cost < new_cost
      if prev_cost > new_cost
        prev[v] = [u]
        dist[v] = new_cost
        q.push(v, new_cost)
      else
        prev[v] ||= []
        prev[v] << u
      end
    end
  end

  finishes = Grid::DIRS.map { |d| Pos[finish, d] }
  best = finishes.map { |f| dist[f] || Float::INFINITY }.min
  results.part1 best

  on_path = Set[]
  q = finishes
  until q.empty?
    c = q.pop
    next if on_path.include?(c)
    on_path << c
    prev[c].each { q << _1 }
  end
  results.part2 on_path.map(&:cell).uniq.size
end
