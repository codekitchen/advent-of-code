#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  ips = input.readlines(chomp: true)

  tls = ips.select { |ip|
    ip =~ %r{(\w)(?!\1)(\w)\2\1} && ip !~ %r{\[[^\]]*(\w)(?!\1)(\w)\2\1[^\]]*\]}
  }
  aoc.part1 tls.size

  ssl = ips.select { |ip|
  }

  aoc.part2 nil
end
