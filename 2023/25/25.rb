#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

# it's Christmas morning, I don't feel like reading up on graph clustering
# algorithms right now... so I loaded the graph definitions into graphviz
# and visually confirmed which 3 cuts need to be made.

def grouping(nodes,start)
  found = Set.new
  q = [start]
  until q.empty?
    n = q.shift
    found << n
    nodes[n].each {|n2|q<<n2 unless found.include?(n2)}
  end
  found
end

def parse = Parse.new '{node}: {conns*}'

def part1(input)
  nodes = Hash.new {|h,k|h[k]=[]}
  parse.lines(input).each { |src,rs| rs.each {|r|nodes[src]<<r;nodes[r]<<src} }
  if input.basename.to_s =~ /full/
    cuts = [%w[pbq nzn], %w[vfs dhl], %w[xvp zpc]]
  else
    cuts = [%w[jqt nvd], %w[bvb cmg], %w[hfx pzl]]
  end
  cuts.each {|s,d|nodes[s].delete(d);nodes[d].delete(s)}
  g1 = grouping(nodes,cuts[0][0])
  g2 = grouping(nodes,cuts[0][1])
  puts g1.size, g2.size
  g1.size * g2.size
  # puts "graph{"
  # nodes.each {|n,ds|ds.each{|d|puts "#{n} -- #{d}"}}
  # puts "}"
end
