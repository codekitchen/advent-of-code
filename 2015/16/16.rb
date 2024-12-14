#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

RULES = {
  children: 3,
  cats: 7,
  samoyeds: 2,
  pomeranians: 3,
  akitas: 0,
  vizslas: 0,
  goldfish: 5,
  trees: 3,
  cars: 2,
  perfumes: 1,
}

def run(input, results)
  sues = input.readlines.each_with_index.map { |sue,i| [i+1, parse_attrs(sue)] }
  p1 = sues
  RULES.each { |k,v| p1 = p1.reject { |i,sue| sue[k.to_s] && !matching(sue, k.to_s, v) } }
  results.part1 p1

  p2 = sues
  RULES.each { |k,v| p2 = p2.reject { |i,sue| sue[k.to_s] && !matching2(sue, k.to_s, v) } }
  results.part2 p2
end

def parse_attrs str
  str.split(':', 2).last.split(',').to_h { |l| l.split(':').map(&:strip) }
end

def matching sue, k, v
  sue[k].to_i == v
end

def matching2 sue, k, v
  sv = sue[k].to_i
  case k
  when "cats", "trees"
    sv > v
  when "pomeranians", "goldfish"
    sv < v
  else
    sv == v
  end
end
