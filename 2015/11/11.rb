#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  cur = input.read

  cur = nextvalid cur
  results.part1 cur

  cur = nextvalid cur
  results.part2 cur
end

def nextvalid pw
  loop do
    pw = nextpw pw
    return pw if valid? pw
  end
end

def nextpw pw
  raise "currently has invalid chars" if pw.index %r{[iol]}
  pw = pw.succ
  loop do
    i = pw.index %r{[iol]}
    break unless i
    pw[i] = pw[i].succ
  end
  pw
end

def valid? pw
  # at least two different, non-overlapping pairs of letters
  hasseq?(pw) && pw.match(%r{(.)\1.*(?!\1)(.)\2})
end

def hasseq? pw
  0.upto(pw.length-2) do |i|
    return true if pw[i+1] == pw[i].succ && pw[i+2] == pw[i+1].succ
  end
  return false
end
