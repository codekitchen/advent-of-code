#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

class P < Struct.new(:x, :y)
  def +(o)
    P[x+o.x,y+o.y]
  end
  def *(n)
    P[x*n,y*n]
  end
end

DIRS = {
  "U" => P[0,-1],
  "D" => P[0,1],
  "L" => P[-1,0],
  "R" => P[1,0],
}

def parse = Parse.new '{dir} {dist} ({color})'

def solve(dirs)
  points = [P[0,0]]
  border = 0
  dirs.each do |dir,dist|
    border += dist
    points << points[-1]+DIRS[dir]*dist.to_i
  end
  area = 0.5 * points.each_cons(2).sum { |a,b| a.x*b.y - b.x*a.y }
  (1 + area + border/2).to_i
end

def part1(input)
  solve(parse.lines(input))
end

DIR_N = %w[R D L U]

def part2(input)
  dirs = parse.lines(input).map do |_,_,hex|
    dir = DIR_N[hex[-1].to_i]
    dist = hex[1,5].to_i(16)
    [dir,dist]
  end
  solve(dirs)
end
