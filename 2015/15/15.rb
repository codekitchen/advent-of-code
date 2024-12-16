#!/usr/bin/env ruby --yjit
require 'z3'
require_relative '../../runner'
require_relative '../../utils'

FORMAT = "{name}: capacity {a}, durability {b}, flavor {c}, texture {d}, calories {e}"

def run(input, results)
  ing = parser input, FORMAT
  # amts = [44, 56]

  solver = Z3::Optimize.new
  vars = ing.map { |name,*| Z3.Int(name) }
  targets = [Z3.Int('cap'),Z3.Int('dur'),Z3.Int('fla'),Z3.Int('tex'),]
  attrs =
    Z3.And(vars.each_with_index.sum { |v,i| v * ing[i][1] } == targets[0],
    vars.each_with_index.sum { |v,i| v * ing[i][2] } == targets[1])

  p solver.maximize attrs

  # this is linear algebra, solving for the max value in a system of equations
  # except what about negatives becoming zero?
  # and only integer values?

  results.part1({ amts:, score: score1(ing, amts) })
  # results.part2 nil
end

def score1 ing, amts
  (1..4).map do |prop|
    [0, ing.zip(amts).sum { |i,a| i[prop] * a }].max
  end.inject(:*)
end

__END__

a + b = 100
x1,x2,x3,x4,y1,y2,y3,y4 are constants

maximize:
(a*x1 + b*y1) * (a*x2 + b*y2) * (a*x3 + b*y3) * (a*x4 + b*y4)
(x1*x2*a*a + x1*y2*a*b + y1*x2*a*b + y1*y2*b*b) * (a*x3 + b*y3) * (a*x4 + b*y4)
