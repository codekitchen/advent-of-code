#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

# signals are 0 or 1

Mod = Struct.new(:state,:outputs,:inputs,:log) do
  def process(sig,idx) = self.state = sig
  def state_s = state.to_s(2)
end

class FlipFlop < Mod
  def process(sig,idx)
    return if sig == 1
    self.state = 1-(state^sig)
  end
end

class Conjunction < Mod
  def process(sig,idx)
    self.state = (state & ~(1<<idx)) | (sig<<idx)
    imask = (1<<inputs.size)-1
    (imask&state)==imask ? 0 : 1
  end
  def state_s = sprintf("%0#{inputs.size}b", state)
end

TyMap = { nil => Mod, ?% => FlipFlop, ?& => Conjunction }

Machine = Struct.new(:modules) do
  def parse(input)
    parser = Parse.new '{type:%&?}{name} -> {outputs*}'
    self.modules = parser.lines(input).to_h do |ty,nm,outputs|
      [nm, TyMap[ty].new(0, outputs)]
    end
    missing = modules.values.flat_map(&:outputs).select {|nm|!modules.key?(nm)}
    missing.each {|nm|modules[nm]=Mod.new(0,[])}
    modules.each { |nm,mod| mod.inputs = modules.filter_map { |nm2,m2| nm2 if m2.outputs.include?(nm) } }
    self
  end

  def inspect
    modules.map {|k,v| "#{TyMap.invert[v.class]}#{k}[#{v.state_s}] -> #{v.outputs.join(",")}" }.join("\n")
  end

  def press(needed_sigs=[])
    @seen ||= Hash.new { |h,k| h[k] = Set.new }
    sigcounts = [0,0]
    sigseen = []
    q = [['button', 'broadcaster', 0, 0]]
    until q.empty?
      src, nm, sig = q.shift
      puts "#{src} -#{sig == 0 ? 'low' : 'high'}-> #{nm}" if $output
      sigcounts[sig]+=1
      mod = modules[nm]
      idx = mod.inputs.index(src)
      sig = mod.process sig, idx
      next if !sig
      sigseen << nm if sig == 1 && needed_sigs.include?(nm)
      q += mod.outputs.map { [nm, _1, sig] }
    end
    puts if $output
    [sigcounts, sigseen]
  end
end

def part1(input)
  m = Machine.new.parse(input)
  counts = 1000.times.map do
    c,_ = m.press
    c
  end
  counts.sum(&:first) * counts.sum(&:last)
end

def part2(input)
  m = Machine.new.parse(input)
  rx = m.modules['rx']
  return "rx not defined" unless rx
  return "need rx to have one input" unless rx.inputs.size == 1
  deps = m.modules[rx.inputs.first].inputs
  found = {}

  (1..).each do |i|
    _,seen = m.press(deps)
    seen.each { |nm| found[nm] ||= i }
    break if found.size == deps.size
  end
  found.values.inject(:lcm)
end
