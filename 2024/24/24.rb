#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

OP = { "AND" => :&, "OR" => :|, "XOR" => :"^" }

CPU = Data.define(:values, :instrs) do
  def initialize = super(values: {}, instrs: {})

  def read(reg) = values[reg] ||= eval(reg)

  def eval(reg)
    a,op,b = instrs[reg]
    read(a).send(OP[op], read(b))
  end
  def reset! = values.reject! { |k,v| k !~ /\A[xy]/ }
end

def run(input, aoc)
  cpu = CPU.new
  init, rest = input.read.split("\n\n")
  parser(init, "{reg}: {val}").each { |reg,val| cpu.values[reg] = val }
  parser(rest, "{a} {op} {b} -> {dest}").each { |a,op,b,dest| cpu.instrs[dest] = [a,op,b] }

  vals = cpu.instrs.keys.select { it =~ /\Az/ }.sort.map { |zreg| cpu.read zreg }

  aoc.part1 vals.reverse.join.to_i(2)

  # x = 23854477729455
  # y = 22066456577055
  # incorrect answer = 45923082839246
  # correct answer x + y = 45920934306510
  # incorrect: 1010011100010001001101000010100010010011001110
  #   correct: 1010011100001111001100111110100010001011001110
  # puts "x", cpu.values.select { |k,v| k =~ /\Ax/ }.sort_by(&:first).map(&:last).reverse.join.to_i(2)
  # puts "y", cpu.values.select { |k,v| k =~ /\Ay/ }.sort_by(&:first).map(&:last).reverse.join.to_i(2)

  swaps = [
    ["z09", "rkf"],
    ["z20", "jgb"],
    ["z24", "vcg"],
    ["rrs", "rvc"],
  ]
  cpu.reset!
  swaps.each do |(a,b)|
    cpu.instrs[a], cpu.instrs[b] = cpu.instrs[b], cpu.instrs[a]
  end

  vals = cpu.instrs.keys.select { it =~ /\Az/ }.sort.map { |zreg| cpu.read zreg }

  puts "  correct: 1010011100001111001100111110100010001011001110"
  puts "incorrect: #{vals.reverse.join}"
  aoc.part2 swaps.flatten.sort.join(",")
end

def dotfile(cpu)
  dot = []
  cpu.instrs.each do |dest, (a,op,b)|
    desc = "#{a} #{op} #{b}"
    dot << "#{a} -> #{dest}"
    dot << "#{b} -> #{dest}"
    dot << "#{dest} [label=\"#{dest}\\n#{desc}\"]"
  end
  puts(["digraph {", *dot, "}"].join("\n"))
end
