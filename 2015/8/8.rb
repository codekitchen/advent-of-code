#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def part1(input)
  lines = input.readlines.map(&:chomp)
  code = lines.sum &:size
  mem = lines.sum { |l| l.gsub(%r{\\\\|\\\"|\\x\w\w}, '?').size - 2 }
  "#{code} - #{mem} = #{code-mem}"
end

def part2(input)
  lines = input.readlines.map(&:chomp)
  code = lines.sum &:size
  enc = lines.sum { |l| l.gsub(%r{\\|"}, 'xx').size + 2 }
  "#{enc} - #{code} = #{enc-code}"
end
