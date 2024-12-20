#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

def run(input, aoc)
  map = Grid.from_input input
  start = map.find('S')
  finish = map.find('E')

  costs = { finish => 0 }
  pos = finish
  until pos == start
    nxt = pos.neighbors.select { it != '#' && !costs.key?(it) }.first # assumes all corridor
    costs[nxt] = costs[pos]+1
    pos = nxt
  end
  costs = costs.sort_by { |pos,cost| cost }

  savings = all_cheats(2, costs)
  if input.to_s =~ /example/
    aoc.part1 savings.sort_by(&:first).map { |k,v| [k, v.size] }
  else
    aoc.part1 savings.select { |s,_| s >= 100 }.sum { |_,c| c.size }
  end

  savings = all_cheats(20, costs)
  target = input.to_s =~ /example/ ? 50 : 100
  aoc.part2 savings.select { |s,_| s >= target }.sum { |_,c| c.size }
end

def all_cheats cheat_len, costs
  savings = Hash.new { |h,k| h[k] = Set[] } # cost -> set of [cheat_start, cheat_end]
  costs.each_with_index do |(cheat_start,start_cost),i|
    costs[i+1..].each_with_index do |(cheat_end,end_cost),j| # all positions closer to the finish
      cheat_cost = steps(cheat_start, cheat_end)
      next if cheat_cost > cheat_len
      normal_cost = j+1
      saved = normal_cost - cheat_cost
      next if saved <= 0
      savings[saved] << [cheat_start, cheat_end]
    end
  end
  savings
end

# manhattan distance since we can only move udrl
def steps(a,b) = (a.x-b.x).abs + (a.y-b.y).abs
