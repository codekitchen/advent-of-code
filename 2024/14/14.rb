#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  lines = input.readlines
  w, h = [lines.shift.to_i, lines.shift.to_i]
  halfw, halfh = [w/2, h/2]
  robots = parser(lines.join(), "p={x},{y} v={dx},{dy}")

  at_step = ->step { robots.map { |x,y,dx,dy| [(x+dx*step) % w, (y+dy*step) % h] } }

  final = at_step.(100)
  counts = Hash.new(0)
  final.each { |x,y| next if x==halfw || y == halfh; counts[[x<halfw, y<halfh]] += 1 }
  results.part1 counts.values.reduce(:*)

  # I originally printed out each step and did a visual search for the most aligned frame
  # for each of x and y. This idea of doing it algorithmically came from
  # https://www.reddit.com/r/adventofcode/comments/1he0asr/2024_day_14_part_2_why_have_fun_with_image/
  variances = 0.upto([w,h].max).map do |step|
    pos = at_step.(step)
    xmean = pos.sum(&:first) / pos.size
    xvar = pos.sum { |x,y| (x-xmean)**2 } / pos.size
    ymean = pos.sum(&:last) / pos.size
    yvar = pos.sum { |x,y| (y-ymean)**2 } / pos.size
    [xvar, yvar]
  end
  xminvar = variances.each_index.min_by { |i| variances[i][0] }
  yminvar = variances.each_index.min_by { |i| variances[i][1] }

  # look at the above grid outputs, find the two different steps where things look spread out
  # in interesting ways horizontally, and vertically.
  # then mod math to find where they intersect. I found steps 9 and 65
  # I am not sure how to deal with the remainder operator algebraically, so I used this code:
  results.part2 (1..).each { |i| break(i) if i % 101 == xminvar && i % 103 == yminvar }
end
