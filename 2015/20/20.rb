#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  count = input.read.to_i
  num = (1..).each { |n| break(n) if presents(n) >= count }
  results.part1 num
  num2 = (1..).each { |n| break(n) if presents2(n) >= count }
  results.part1 num2
end

def presents(house)
  return 10 if house == 1
  val = house + 1
  2.upto(Math.sqrt(house).to_i) do |n|
    if house % n == 0
      val += n
      val += house/n if n*n != house
    end
  end
  val * 10
end

def presents2(house)
  return 11 if house == 1
  val = house + 1
  2.upto(Math.sqrt(house).to_i) do |n|
    if house % n == 0
      val += n if house / n <= 50
      val += house/n if n*n != house && house/(house/n) <= 50
    end
  end
  val * 11
end
