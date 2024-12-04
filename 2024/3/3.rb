#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def part1(input)
  sum_part(input.read)
end

def sum_part(part)
  part.scan(%r{mul\((\d{1,3}),(\d{1,3})\)}).sum { |a,b| a.to_i*b.to_i }
end

def part2(input)
  parts = input.read.split(%r{(do\(\)|don't\(\))})
  enabled = true
  parts.sum do |part|
    case part
    when "do()"; enabled = true; 0
    when "don't()"; enabled = false; 0
    else enabled ? sum_part(part) : 0
    end
  end
end
