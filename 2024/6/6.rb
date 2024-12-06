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

Guard = Struct.new(:pos, :dir) do
  def step
    return unless present?
    self.dir = TURNS[self.dir] while self.pos.send(self.dir) == '#'
    self.pos = self.pos.send(self.dir)
  end

  def present? = !!pos
end

def walk(guard)
  seen = Set.new
  while guard.present?
    seen << guard.pos
    guard.step
  end
  seen
end

def loop?(guard)
  slow = guard.dup
  fast = guard
  while fast.present?
    slow.step
    fast.step
    fast.step
    return true if slow == fast
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
  walk(guard.dup).count do |obs|
    next unless obs == '.'
    obs.set '#'
    loop?(guard.dup).tap { obs.set '.' }
  end
end
