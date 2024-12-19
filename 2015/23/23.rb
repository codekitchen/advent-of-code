#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, aoc)
  instrs = input.readlines

  cpu = CPU.new
  cpu.run instrs
  aoc.part1 cpu.regs

  cpu = CPU.new
  cpu.regs["a"] = 1
  cpu.run instrs
  aoc.part2 cpu.regs
end

class CPU
  attr_reader :regs
  def initialize
    @regs = { "a" => 0, "b" => 0 }
  end

  def run instrs
    pc = 0
    while (0...instrs.length) === pc
      case instrs[pc]
      when /hlf ([ab])/; @regs[$1] /= 2
      when /tpl ([ab])/; @regs[$1] *= 3
      when /inc ([ab])/; @regs[$1] += 1
      when /jmp ([-+]\d+)/
        pc += $1.to_i - 1
      when /jie ([ab]), ([-+]\d+)/
        pc += $2.to_i - 1 if @regs[$1] % 2 == 0
      when /jio ([ab]), ([-+]\d+)/
        pc += $2.to_i - 1 if @regs[$1] == 1
      end
      pc += 1
    end
  end
end
