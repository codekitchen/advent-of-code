#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

DIRS = { '^' => :u, '>' => :r, '<' => :l, 'v' => :d }

def part1(input)
  dirs = input.read.chars

  seen = Set.new
  pos = V2[0,0]
  dirs.each do |c|
    seen << pos
    pos = pos.send(DIRS[c])
  end
  seen.size
end

def part2(input)
  dirs = input.read.chars

  seen = Set.new
  santa = V2[0,0]
  robo = V2[0,0]
  seen << santa
  dirs.each_with_index do |c,i|
    if i.even?
      santa = santa.send(DIRS[c])
      seen << santa
    else
      robo = robo.send(DIRS[c])
      seen << robo
    end
  end
  seen.size
end

V2 = Data.define(:x, :y) do
  def l = V2[x-1, y]
  def r = V2[x+1, y]
  def u = V2[x, y-1]
  def d = V2[x, y+1]
end
