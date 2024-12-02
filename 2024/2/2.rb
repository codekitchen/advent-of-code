#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def parse = Parse.new("{nums*}")

def part1(input)
  parse.lines(input).count { valid? _1 }
end

def part2(input)
  parse.lines(input).count { valid_with_remove? _1 }
end

def valid?(line)
  pairs = 0.upto(line.length-2).map { |i| line[i,2] }
  pairs.all? { |a,b| (1..3).include? (a-b).abs } &&
    (pairs.all? { |a,b| a < b } || pairs.all? { |a,b| a > b })
end

def valid_with_remove?(line)
  perms = [line] + line.each_index.map { |i| line.dup.tap{|p|p.delete_at(i)} }
  perms.any? { valid? _1 }
end
