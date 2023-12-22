#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require 'ruby-progressbar'
using ProgressBar::Refinements::Enumerator

class Brick
  attr_accessor :x1,:y1,:z1,:x2,:y2,:z2
  attr_reader :label
  def initialize(x1,y1,z1,x2,y2,z2,label)
    @x1,@y1,@z1,@x2,@y2,@z2 = x1,y1,z1,x2,y2,z2
    @label = label
  end
  def x = x1..x2
  def y = y1..y2
  def z = z1..z2
  def extents
    [@x,@y,@z]
  end

  def overlap?(o)
    extents.zip(o.extents).all? {|a,b| a.overlap?(b) }
  end
end

class Stack
  attr_reader :zm,:ym,:xm,:bricks
  def initialize(bricks)
    @zm = bricks.map(&:z2).max+1
    @ym = bricks.map(&:y2).max+1
    @xm = bricks.map(&:x2).max+1
    @d = @zm.times.map { |z| @ym.times.map { |y| [nil] * @xm } }
    @bricks = []
    bricks.each { add _1 }
  end

  def add(brick)
    @bricks << brick
    brick.z.each {|z|brick.y.each{|y|brick.x.each{|x|@d[z][y][x]=brick}}}
  end

  def remove(brick)
    @bricks.delete brick
    brick.z.each {|z|brick.y.each{|y|brick.x.each{|x|@d[z][y][x]=nil}}}
  end

  def to_s(axis=:x)
    maxz = @d.size
    maxn = axis == :x ? @d[0][0].size : @d[0].size
    res = maxz.times.map { "." * maxn }
    res[maxz-1] = '-' * maxn
    (1...@d.size).each{|z|
      @d[z].each_with_index{|ya,y|
        ya.each_with_index{|v,x|
        v && res[maxz-1-z][axis==:x ?x:y]=v.label
    }}}
    [" #{axis}"] + [(0...maxn).map(&:to_s).join] + res
  end

  def [](x,y,z)
    @d[z][y][x]
  end

  def unsupported(*ignoring)
    bricks.select{|b|
      next false if b.z1 == 1 # on the ground
      b.y.all?{|y|b.x.all?{|x|
        v=self[x,y,b.z1-1]
        !v || ignoring.include?(v)
      }}
    }
  end

  def sort! = @bricks.sort_by!(&:z1)

  def drop(brick)
    raise "can't drop #{brick}" if brick.z1 <= 1
    remove brick
    brick.z1 -= 1
    brick.z2 -= 1
    add brick
  end

  def sim
    loop do
      moving = unsupported
      break if moving.empty?
      moving.each { |b| drop(b) }
    end
    sort!
    self
  end
end

def parse = Parse.new('{x1},{y1},{z1}~{x2},{y2},{z2}')
def bchr(i) = i >= 26 ? '?' : (?A.ord+i).chr

def part1(input)
  bricks = parse.lines(input).map.with_index { |b,i| Brick.new(*b, bchr(i)) }.sort_by(&:z1)
  stack = Stack.new bricks
  stack.sim
  puts stack.to_s
  puts
  puts stack.to_s :y
  # # what can we disintegrate?
  safe = stack.bricks.select.with_progressbar do |b|
    stack.unsupported(b).empty?
  end
  safe.size
end

def part2(input)
  bricks = parse.lines(input).map.with_index { |b,i| Brick.new(*b, bchr(i)) }.sort_by(&:z1)
  stack = Stack.new bricks
  stack.sim

  stack.bricks.sum do |b|
    # how many will fall if b is gone?
    ignoring = Set.new [b]
    prev = Set.new
    until ignoring == prev
      prev = ignoring
      ignoring += stack.unsupported(*ignoring)
    end
    ignoring.size - 1
  end
end
