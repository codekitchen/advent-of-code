#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

FORMAT = "{name} can fly {speed} km/s for {fly} seconds, but then must rest for {rest} seconds."

Reindeer = Data.define(:name, :speed, :fly_time, :rest_time)

def run(input, results)
  rules = parser(input, FORMAT).map { Reindeer[*_1] }

  results.part1_1000s rules.map { distance_at _1, 1000 }.max
  results.part1_2503s rules.map { distance_at _1, 2503 }.max

  distances = 1.upto(2503).map { |t| rules.map { |r| distance_at r, t } }
  scores = [0] * rules.size
  distances.each do |rs|
    lead = rs.max
    rs.each_with_index { |v,i| scores[i] += 1 if v == lead }
  end

  results.part2 scores.max
end

def distance_at r, sec
  dist = 0
  while sec > 0
    fly_time = [sec, r.fly_time].min
    sec -= fly_time
    dist += fly_time * r.speed

    rest_time = [sec, r.rest_time].min
    sec -= rest_time
  end
  dist
end

def race rs, sec
  score = Hash.new(0)
  dist = Hash.new(0)
  while sec > 0
    fly_time = [sec, r.fly_time].min
    sec -= fly_time
    dist += fly_time * r.speed

    rest_time = [sec, r.rest_time].min
    sec -= rest_time
  end
  score.values.max
end
