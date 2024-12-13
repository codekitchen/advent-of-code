#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require 'json'

def run(input, results)
  text = input.read

  results.part1 text.scan(%r{-?\d+}).sum { _1.to_i }
  results.part2 sumup(JSON.parse text)
end

def sumup node
  case node
  when Integer
    node
  when Array
    node.sum { sumup _1 }
  when Hash
    vals = node.values
    return 0 if vals.include?("red")
    vals.sum { sumup _1 }
  when String
    0
  else
    raise "can't handle #{node.inspect}"
  end
end
