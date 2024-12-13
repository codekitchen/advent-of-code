#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

def part1(input)
  grid = Grid.new(1000, 1000, seed: false)
  input.open.each_line do |line|
    md = %r{(\d+),(\d+) through (\d+),(\d+)}.match(line)
    _, x1, y1, x2, y2 = md.to_a.map(&:to_i)
    case line
    when %r{^turn on}
      grid[x1..x2, y1..y2].each { _1.set true }
    when %r{^turn off}
      grid[x1..x2, y1..y2].each { _1.set false }
    when %r{^toggle}
      grid[x1..x2, y1..y2].each { _1.set !_1.get }
    end
  end
  grid.count { _1.get }
end

def part2(input)
  grid = Grid.new(1000, 1000, seed: 0)
  input.open.each_line do |line|
    md = %r{(\d+),(\d+) through (\d+),(\d+)}.match(line)
    _, x1, y1, x2, y2 = md.to_a.map(&:to_i)
    case line
    when %r{^turn on}
      grid[x1..x2, y1..y2].each { _1.set(_1.get+1) }
    when %r{^turn off}
      grid[x1..x2, y1..y2].each { _1.set([_1.get-1, 0].max) }
    when %r{^toggle}
      grid[x1..x2, y1..y2].each { _1.set(_1.get+2) }
    end
  end
  grid.sum { _1.get }
end
