#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

FORMAT = "{name}: capacity {a}, durability {b}, flavor {c}, texture {d}, calories {e}"

def run(input, results)
  ing = parser input, FORMAT

  # this is linear algebra, solving for the max value (derivative=0) in a system of equations
  # except what about negatives becoming zero? that sounds like relu activation.
  # and only integer values?
  amts = maximize(ing)
  results.part1({ amts:, score: score1(ing, amts) })

  amts = best_500(ing)
  results.part2({ amts:, score: score1(ing, amts) })
end

def maximize ing
  best = [0, []]
  all_amts(ing.size) do |amts|
    score = score1(ing, amts)
    best = [score, amts] if score > best[0]
  end
  best[1]
end

def best_500 ing
  all = []
  all_amts(ing.size) do |amts|
    score = score1(ing, amts)
    cal = calories(ing, amts)
    all << [amts, score] if cal == 500
  end
  all.max_by { |_,score| score }.first
end

def calories(ing, amts)
  ing.zip(amts).sum { |i,a| i[5] * a }
end

def all_amts(sz, a=[], &cb)
  so_far = a.sum
  if a.size == sz-1
    cb.(a + [100-so_far])
    return
  end
  0.upto(100-so_far) do |v|
    all_amts(sz, a+[v], &cb)
  end
end

def score1 ing, amts
  (1..4).map do |prop|
    [0, ing.zip(amts).sum { |i,a| i[prop] * a }].max
  end.inject(:*)
end
