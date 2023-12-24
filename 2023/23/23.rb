#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../grid'

SLOPES = { '>'=>:r, '<'=>:l, 'v'=>:d, '^'=>:u }

using Module.new { refine Grid::Cell do
  def neighbor_paths
    slope = SLOPES[get]
    return [send(slope)].compact if slope
    neighbors.select{_1!='#'}
  end
  def path? = get != '#'
  def node? = path? && (SLOPES.keys.include?(get) || neighbor_paths.count > 2)
end }

def part1(input)
  grid = Grid.from_input input.read
  solve(grid)
end

def part2(input)
  grid = Grid.from_input input.read
  grid.cells.each {|c|c.set('.') if SLOPES.keys.include?(c.get)}
  solve(grid)
end

def solve(grid)
  startpos = grid.cells.find { _1=='.' }
  finishpos = grid[0.., grid.height-1].cells.find { _1=='.' }
  # nodes are intersections/slopes, edges are paths between intersections
  nodes = [startpos,finishpos] + grid.cells.select(&:node?)

  edges = Hash.new {|k,v|k[v]=[]}
  nodes.each do |node|
    next if node == finishpos
    seen = Set.new
    q = [[node,0]]
    until q.empty?
      n2,dist = q.shift
      seen << n2
      n2.neighbor_paths.each do |np|
        next if seen.include?(np)
        if nodes.include?(np)
          edges[node] << [np,dist+1]
        else
          q<<[np,dist+1]
        end
      end
    end
  end

  nodeids = edges.keys.each_with_index.to_h
  targets = nodeids.map{|n,i|edges[n].map{|n2,c|[nodeids[n2],c]}}
  startid = nodeids[startpos]
  finishid = nodeids[finishpos]

  seen = Set.new
  dfs = lambda do |nodeid|
    return 0 if nodeid == finishid
    seen.add nodeid
    found = targets[nodeid].map do |nextid,nextdist|
      next if seen.include? nextid
      res = dfs.(nextid)
      res&.+nextdist
    end.compact.max
    seen.delete nodeid
    found
  end
  dfs.(startid)
end
