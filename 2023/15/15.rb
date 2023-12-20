#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def hash(str) = str.codepoints.reduce(0) { |val,c| ((val + c) * 17) % 256 }
assert_eq 52, hash("HASH")

def part1(input)
  input.read.split(",").sum { hash _1 }
end

def parse = Parse.new '{label}{op:-=}{lens?}', repeat: ','

def score(boxes)
  boxes.sum { |id,box| box.each_with_index.sum { |(label,lens),idx| (id+1)*(idx+1)*lens } }
end

def part2(input)
  steps = parse.(input.read)
  # relies on hash ordering
  boxes = Hash.new { |h,k| h[k] = {} }
  steps.each do |label,op,lens|
    if op == ?-
      boxes[hash label].delete label
    else
      boxes[hash label][label] = lens
    end
  end
  score boxes
end
