#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require 'digest'

def part1(input)
  key = input.read
  (0..).each do |n|
    res = Digest::MD5.hexdigest "#{key}#{n}"
    return n if res[0,5] == "00000"
  end
end

def part2(input)
  key = input.read
  (0..).each do |n|
    res = Digest::MD5.hexdigest "#{key}#{n}"
    return n if res[0,6] == "000000"
  end
end
