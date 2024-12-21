#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require 'digest'

def run(input, aoc)
  key = input.read
  pw = []
  pw2 = [nil] * 8

  (0..).each do |n|
    res = Digest::MD5.hexdigest "#{key}#{n}"
    if res[0,5] == "00000"
      pw << res[5] unless pw.size >= 8
      pos = res[5]
      next unless ('0'..'7').include?(pos)
      pw2[pos.to_i] ||= res[6]
      break if pw2.all?
    end
  end

  aoc.part1 pw.join
  aoc.part2 pw2.join
end
