#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../pathfinding'

def run(input, results)
  rules, str = input.read.split("\n\n")
  rules = rules.lines.map { _1.split("=>").map(&:strip) }
  rules_rev = rules.each_with_object({}) { |(i,o),h| (h[o] ||= []) << i }
  rules = rules.each_with_object({}) { |(i,o),h| (h[i] ||= []) << o }
  rx = Regexp.new rules.keys.join('|')

  found = evolve rules, str, rx
  results.part1 found.size

  # things I've tried:
  # Keeping track of the longest prefix seen globally, and reject neighbors with less prefix
  #    - incorrect, it breaks necessary backtracking
  # Cost is inversely proportional to correct prefix size
  #    - still much too slow
  # DFS and prioritize matching prefixes
  #    - still too slow
  #
  # There has to be a way to reduce the state space that I'm not seeing
  # There are some fragments of outputs that don't map to any other input,
  # so they are "dead ends" of sorts. Once you have them they stick around.
  # Is that relevant?
  #
  # Blargh: the answer, which I rejected early on, is to go in reverse --
  # start from the end state and work back to the beginning 'e'.
  # Except that's not quite what it was... I got lucky without realizing it.
  # In general the backwards search is still too big of a state space.
  # But I happened to pop from the end in my DFS, which means I'm accidentally
  # taking the rightmost match each time, which takes me directly to
  # the solution with zero detours.

  neighbors = ->s {
    print "\r#{prefix_size str, s}"
    nexts = s.size > str.size ? [] : evolve(rules, s, rx)
    nexts = nexts.sort_by { |a| prefix_size(str, a) }.select { valid?(str, a) }
    # nexts.map { |s| [s, str.size-prefix_size(str, s)] }
  }
  found = ->s { s == str }
  neighbors_rev = ->s {
    evolve2(rules_rev, s).to_a
  }

  seens = Set[]
  cost = catch :found do
    dfs(seens, str, 0, ->s { s == 'e' }, neighbors_rev)
    # dfs(Set[], "e", 0, found, neighbors)
  end
  p "seens #{seens.size}"
  p "ic #{$ic}"
  results.part2 cost
end

$ic = 0
def dfs seen, cur, cost, found, neighbors
  return unless seen.add?(cur)
  throw(:found, cost) if found.(cur)
  nexts = neighbors.(cur)
  $ic += nexts.size
  while s = nexts.pop
    dfs seen, s, cost+1, found, neighbors
  end
end

def evolve rules, str, rx
  found = Set[]
  idx = 0
  while md = str.match(rx, idx)
    rules[md[0]].each do |o|
      str2 = str.dup
      str2[md.begin(0), md[0].length] = o
      found << str2
    end
    idx = md.end(0)
  end
  found
end

def evolve2 rules, str
  found = Set[]
  (0...str.size).each do |idx|
    rules.each do |r,os|
      next unless str[idx,r.size] == r
      os.each do |o|
        str2 = str.dup
        str2[idx,r.size] = o
        found << str2
      end
    end
  end
  found
end

def prefix_size a, b
  (0 ... a.size).each do |i|
    return i if a[i] != b[i]
  end
  0
end
