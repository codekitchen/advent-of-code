#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  paths = parser(input, "{src} to {dst} = {dist}")
  cities = Set.new(paths.map { |p| p[0] } + paths.map { |p| p[1] })
  distances = paths.to_h { |a,b,dist| [Set[a,b], dist] }

  results.part1 best(nil, cities, distances, :min)
  results.part2 best(nil, cities, distances, :max)
end

tabler [true, true, false, true],
def best c0, cities, distances, meth
  return 0 if cities.empty?
  cities.map { |dest|
    cost = c0 ? distances[Set[c0, dest]] : 0
    cost + best(dest, cities - [dest], distances, meth)
  }.send(meth)
end
