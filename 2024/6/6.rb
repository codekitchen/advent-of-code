#!/usr/bin/env ruby --yjit
require 'set'
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

TURNS = {
  u: :r,
  r: :d,
  d: :l,
  l: :u,
}

Guard = Data.define(:pos, :dir) do
  def step
    dir = self.dir
    dir = TURNS[dir] while self.pos.send(dir) == '#'
    pos = self.pos.send(dir)
    pos && Guard.new(pos, dir)
  end
end

def walk(guard)
  seen = Set.new
  while guard
    seen << guard.pos
    guard = guard.step
  end
  seen
end

def loop?(guard)
  slow = guard
  fast = guard
  while fast
    slow = slow.step
    fast = fast.step&.step
    return true if fast && slow == fast
  end
  false
end

def part1(input)
  map = Grid.from_input(input.read)
  start = map.find { _1 == '^' }
  walk(Guard.new(start, :u)).size
end

def part2(input)
  map = Grid.from_input(input.read)
  start = map.find { _1 == '^' }
  guard = Guard.new(start, :u)
  walk(guard).count do |obs|
    next unless obs == '.'
    obs.set '#'
    loop?(guard).tap { obs.set '.' }
  end
end
