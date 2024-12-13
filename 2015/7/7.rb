#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  instrs = {}
  input.read.each_line do |line|
    instr, target = line.split('->').map(&:strip)
    instrs[target] = instr
  end

  $cache = {}
  val = eval('a', instrs)
  results.part1 val

  $cache = {}
  instrs['b'] = val.to_s
  val = eval('a', instrs)
  results.part2 val
end

def eval(wire, instrs)
  return wire.to_i if wire =~ %r{\d+}
  $cache[wire] ||= (0xffff &
  case instrs[wire]
  when %r{^(\w+)$}
    eval($1, instrs)
  when %r{(\w+) AND (\w+)}
    eval($1, instrs) & eval($2, instrs)
  when %r{(\w+) OR (\w+)}
    eval($1, instrs) | eval($2, instrs)
  when %r{NOT (\w+)}
    ~eval($1, instrs)
  when %r{(\w+) LSHIFT (\d+)}
    eval($1, instrs) << $2.to_i
  when %r{(\w+) RSHIFT (\d+)}
    eval($1, instrs) >> $2.to_i
  else
    raise "can't handle #{wire}: #{instrs[wire]}"
  end)
end
