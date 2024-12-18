#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'
require_relative '../../pathfinding'

PARAMS = {
  'example.txt' => { w:7, h:7, nbytes: 12 },
  'full.txt' => { w:71, h:71, nbytes: 1024 },
}

def run(input, results)
  PARAMS[input.basename.to_s] => w:, h:, nbytes:
  bytes = parser(input, '{x},{y}')

  start, finish = make_grid w, h, bytes[0, nbytes]
  pathfind(start) => dist:
  results.part1 dist[finish]

  blocker = (nbytes+1 ... bytes.size).bsearch do |n|
    start, finish = make_grid w, h, bytes[0, n+1]
    pathfind(start) => dist:
    Float::INFINITY == dist[finish]
  end
  results.part2 [blocker, bytes[blocker]]
end

def make_grid w, h, bytes
    grid = Grid.new(w, h, seed: '.')
    start = grid.at(0,0)
    finish = grid.at(w-1,h-1)
    bytes.each { |x,y| grid[x,y] = '#' }
    return start, finish
end

def pathfind start
  q = PQueue.new { |a,b| a[1] <=> b[1] }
  # node, cost
  q.push([start, 0])
  prev = {}
  dist = Hash.new(Float::INFINITY)

  until q.empty?
    u, cost = q.pop
    u.neighbors.reject { it == '#' }.each do |v|
      new_cost = cost + 1
      prev_cost = dist[v]
      next if prev_cost < new_cost
      if prev_cost > new_cost
        prev[v] = [u]
        dist[v] = new_cost
        q.push([v, new_cost])
      else
        prev[v] ||= []
        prev[v] << u
      end
    end
  end

  return { prev:, dist: }
end
