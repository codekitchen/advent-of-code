#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  steps = input.basename.to_s =~ /example/ ? 5 : 40
  word = input.read

  steps.times { word = step word }
  results.part1 word.size

  10.times { word = step word }
  results.part2 word.size
end

def step word
  word.gsub(%r{(.)\1*}) { |s| s.size.to_s + s[0] }
end
