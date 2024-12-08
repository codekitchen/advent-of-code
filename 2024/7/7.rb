#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def part1(input)
  parser(input, '{result}: {nums*}').select { |(result,nums)|
    valid?(%i[+ *], result, nums[0], nums, 1)
  }.sum(&:first)
end

using Module.new { refine Numeric do
  def cat(b) = "#{self}#{b}".to_i
end }

def part2(input)
  parser(input, '{result}: {nums*}').select { |(result,nums)|
    valid?(%i[+ * cat], result, nums[0], nums, 1)
  }.sum(&:first)
end

def valid?(ops, result, value, nums, i)
  return false if value > result
  return result == value if i == nums.size
  ops.any? { |op| valid?(ops, result, value.send(op, nums[i]), nums, i+1) }
end
