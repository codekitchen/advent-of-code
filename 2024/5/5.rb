#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def valid?(update, rules)
  update.each_with_index.all? do |n,i|
    (rules[n] || []).all? { |r| !update[0,i].include?(r) }
  end
end

def parse(input)
  rules, updates = input.read.split("\n\n")
  rules = rules.lines.map { _1.chomp.split("|") }
  rules_h = {}
  rules.each { |l,r| (rules_h[l] ||= []) << r }
  updates = updates.lines.map { _1.chomp.split(",") }
  return rules_h, updates
end

def part1(input)
  rules, updates = parse(input)
  good = updates.select { |update| valid?(update, rules) }
  good.sum { _1[_1.size/2].to_i }
end

def sorter(a,b,rules)
  return -1 if rules[a] && rules[a].include?(b)
  return 1 if rules[b] && rules[b].include?(a)
  return 0
end

def part2(input)
  rules, updates = parse(input)
  bad = updates.reject { |update| valid?(update, rules) }
  bad = bad.map { |update| update.sort { |a,b| sorter(a,b,rules) } }
  bad.sum { _1[_1.size/2].to_i }
end
