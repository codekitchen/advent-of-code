#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../grid'

def roll g
  # rolls north, rotate grid to roll other directions
  stops = g.rows[0].select { _1.get != ?# }
  stops += g.select { _1.y > 0 && _1.u&.get == ?# }
  stops.each do |pos|
    start = pos
    os = 0
    until !pos || pos.get == ?#
      os += 1 if pos.get == ?O
      pos = pos.d
    end
    y = start
    os.times { y.set 'O'; y=y.d }
    (y.set '.'; y=y.d) until !y || y.get == ?#
  end
end

def score(g)
  g.sum { |pos| pos.get == ?O ? pos.grid.height - pos.y : 0 }
end

def part1(input)
  g = Grid.from_input input.read
  roll g
  score g
end
assert_eq 136, part1(INPUTS["example"])

def cycle(g) = 4.times { roll g; g=g.rotate_cw } && g

def part2(input)
  g = Grid.from_input input.read
  memo = {}
  seen = {}
  cycles = 1000000000
  i = 0
  while i < cycles
    pre = g.data.dup
    if memo.key?(pre)
      prev_i, prev_g = memo[pre]
      if seen.key?(prev_i)
        clen = i - prev_i
        i += clen while i+clen < cycles
      else
        seen[prev_i] = i
      end
      g = prev_g
    else
      g = cycle g
      memo[pre] = [i, g.dup]
    end
    i += 1
  end
  score g
end
assert_eq 64, part2(INPUTS["example"])
