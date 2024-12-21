#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

FACING = [[0,-1], [1,0], [0,1], [-1,0]]

def run(input, aoc)
  directions = parser(input, "{dir:LR}{dist}", repeat: ',').first
  pos = [0,0]
  face = 0
  seen = Set[pos.dup]
  firstdup = nil

  directions.each do |(turn,dist)|
    face = (face + (turn == 'R' ? 1 : -1)) % FACING.size
    idx = FACING[face][0] != 0 ? 0 : 1
    dist.times do
      pos[idx] += FACING[face][idx]
      if !firstdup && !seen.add?(pos.dup)
        firstdup = pos.dup
      end
    end
  end
  aoc.part1 pos[0].abs + pos[1].abs

  aoc.part2 firstdup[0].abs + firstdup[1].abs
end
