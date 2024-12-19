#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  towels, patterns = input.read.split("\n\n")
  towels = towels.split(",").map(&:strip)
  patterns = patterns.lines.map(&:strip)

  rx = %r{\A(#{towels.join("|")})+\z}
  possibles = patterns.select { rx =~ it }
  results.part1 possibles.size

  count = patterns.sum { dfs(towels, it) }
  results.part2 count
end

memoize def dfs(towels, pattern, i=0)
  return 1 if i >= pattern.size
  towels.sum { |cur|
    pattern.index(cur, i) == i ? dfs(towels, pattern, i+cur.size) : 0
  }
end
