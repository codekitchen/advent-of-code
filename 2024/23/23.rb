#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  conns = Hash.new { |h,k| h[k] = Set[] }
  trios = Set[]
  input.readlines(chomp: true).each do |line|
    a,b = line.split('-')
    shared = conns[a] & conns[b]
    shared.each { |c| trios << Set[a,b,c] }
    conns[a] << b
    conns[b] << a
  end

  aoc.part1 trios.select { |t| t.any? { |c| c.start_with?('t') } }.size

  largest_clique = Set[]
  # https://en.wikipedia.org/wiki/Bron–Kerbosch_algorithm#Without_pivoting
  bron_kerbosch1 = ->(r,p,x) do
    if p.empty? && x.empty?
      largest_clique = r if r.size > largest_clique.size
      next
    end
    p.each do |v|
      bron_kerbosch1.(r | [v], p & conns[v], x & conns[v])
      p -= [v]
      x |= [v]
    end
  end
  bron_kerbosch1.(Set[], Set[*conns.keys], Set[])

  aoc.part2 largest_clique.sort.join(',')
end
