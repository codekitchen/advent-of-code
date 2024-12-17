#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def run(input, results)
  input = input.read
  a, b, c, _ = input.scan(/\d+/).map(&:to_i)
  program = input.match(/Program: (.*)/)[1]
  program = program.split(',').map(&:to_i)

  cpu = CPU.new(a:, b:, c:)
  cpu.run program
  results.part1 cpu.out.join(',')

  a = dfs(0, program, program.size-1)
  cpu = CPU.new(a:, b:, c:)
  cpu.run program
  pp cpu.out
  results.part2 a
end

CPU = Struct.new(*%i[pc a b c out]) do
  def initialize(a:0, b:0, c:0)
    super(pc: 0, out: [], a:, b:, c:)
  end

  def run program
    self.pc = 0
    while pc < program.size
      i, op = program[pc, 2]
      case i
      when 0; self.a = a>> combo(op)
      when 1; self.b = b ^ op
      when 2; self.b = combo(op) & 7
      when 3; self.pc = op-2 if a != 0
      when 4; self.b = b ^ c
      when 5; self.out << (combo(op) & 7)
      when 6; self.b = a>> combo(op)
      when 7; self.c = a>> combo(op)
      end
      self.pc += 2
    end
  end

  def combo(v)
    case v
    when 4; a
    when 5; b
    when 6; c
    else v
    end
  end
end

def dfs(a, program, i)
  return a if i < 0
  a <<= 3
  want = program[i]
  (0..7).each do |try|
    aa = a | try
    cpu = CPU.new(a: aa)
    cpu.run program
    if cpu.out[0] == want
      maybe = dfs(aa, program, i-1)
      return maybe if maybe
    end
  end
  return false
end

# 2,4, 1,1, 7,5, 1,5, 0,3, 4,4, 5,5, 3,0
=begin
b = a&7     # bottom 3 bits of a
b = b^1     # [1, 0, 3, 2, 5, 4, 7, 6]
c = a/2**b  # 2**b == [2, 1, 8, 4, 32, 16, 128, 64] == a >> b
b = b^5     # [4, 5, 6, 7, 0, 1, 2, 3]
a = a/2**3  # a >> 3
b = b^c     # bottom 3 bits, xor with those higher bits
out b&7
jump

c = a/(2**((a&7)^1))
2 ==

8**16-1 = 281474976710655
8**15-1 = 35184372088831
still 246,290,604,621,824 (246 trillion) numbers in that range

=end

def test(cpu, program)
  cpu.run program
  cpu
end

# If register C contains 9, the program 2,6 would set register B to 1.
assert_eq 1, test(CPU.new(c: 9), [2,6]).b
# If register A contains 10, the program 5,0,5,1,5,4 would output 0,1,2.
assert_eq [0,1,2], test(CPU.new(a: 10), [5,0,5,1,5,4]).out
# If register A contains 2024, the program 0,1,5,4,3,0 would output 4,2,5,6,7,7,7,7,3,1,0 and leave 0 in register A.
assert_eq [[4,2,5,6,7,7,7,7,3,1,0], 0], test(CPU.new(a: 2024), [0,1,5,4,3,0]).then { [_1.out, _1.a] }
# If register B contains 29, the program 1,7 would set register B to 26.
assert_eq 26, test(CPU.new(b: 29), [1,7]).b
# If register B contains 2024 and register C contains 43690, the program 4,0 would set register B to 44354.
assert_eq 44354, test(CPU.new(b: 2024, c: 43690), [4,0]).b
