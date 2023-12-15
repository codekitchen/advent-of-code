#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def hash(str) = str.codepoints.reduce(0) { |val,c| ((val + c) * 17) % 256 }
assert_eq 52, hash("HASH")

def part1(input)
  input.read.split(",").sum { hash _1 }
end

def parse_step(step) = step.match(%r{(\w+)([-=])(\d+)?})[1..]

def score(boxes)
  boxes.sum { |id,box| box.each_with_index.sum { |(label,lens),idx| (id+1)*(idx+1)*lens.to_i } }
end

def part2(input)
  steps = input.read.split(",")
  boxes = Hash.new { |h,k| h[k] = [] }
  steps.each do |step|
    label, op, lens = parse_step step
    box = boxes[hash label]
    l = box.find { |old,| old == label }
    case op
    when ?-
      box.delete(l) if l
    when ?=
      if l
        l[1] = lens
      else
        box << [label, lens]
      end
    end
  end
  score boxes
end
