#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

FORMAT = "{name}: capacity {a}, durability {b}, flavor {c}, texture {d}, calories {e}"

def run(input, results)
  ing = parser input, FORMAT
  amts = [44, 56]

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
