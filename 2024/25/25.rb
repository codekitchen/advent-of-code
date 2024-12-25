#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  schemas = input.read.split("\n\n")
  locks, keys = schemas.partition { it.start_with?('#####') }

  locks = locks.map { it.split("\n").map(&:chars).transpose.map { |col| col.count('#') - 1 } }
  keys = keys.map { it.split("\n").map(&:chars).transpose.map { |col| col.count('#') - 1 } }

  # p locks[0]
  # p keys[0]

  viable = locks.sum { |lock|
    keys.count { |key| lock.zip(key).all? { |a,b| a+b <= 5 } }
  }

  aoc.part1 viable
end
