#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  presents = parser(input, '{l}x{w}x{h}')

  paper = presents.sum do |l,w,h|
    2*l*w + 2*w*h + 2*h*l + [l*w,w*h,h*l].min
  end
  results.part1 paper

  ribbon = presents.sum do |l,w,h|
    l*w*h + [l+l+w+w, w+w+h+h, h+h+l+l].min
  end
  results.part2 ribbon
end
