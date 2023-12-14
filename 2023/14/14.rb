#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../grid'

def roll g
  # rolls north, rotate grid to roll other directions
  g.cols.each do |col|
    stop = nil
    col.each do |pos|
      stop ||= pos
      case pos.get
      when ?#
        stop = pos.d
      when ?O
        pos.set ?.
        stop.set ?O
        stop = stop.d
      end
    end
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

def cycle(g)
  g=g.dup
  4.times { roll g; g=g.rotate_cw }
  g
end

def part2(input, cycles=1000000000)
  g = Grid.from_input input.read
  seen = {}
  i = 0
  while i < cycles
    prev_i = seen[g.data]
    if prev_i
      clen = i - prev_i
      i += clen while i+clen < cycles
    end
    seen[g.data] = i
    g = cycle g
    i += 1
  end
  score g
end
assert_eq 64, part2(INPUTS["example"])
