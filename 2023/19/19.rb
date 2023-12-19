#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

Part = Data.define(*%i[x m a s]) do
  def initialize(**a) = super(a.transform_values(&:to_i))
  def rating = x+m+a+s
end

Test = Data.define(:cat, :op, :rhs, :dest) do
  def process(part)
    return dest unless op
    part.send(cat).send(op, rhs.to_i) && dest
  end
end

Workflow = Data.define(:tests) do
  def self.parse(line)
    %r[(?<name>\w+){(?<ops>.*)}] =~ line
    tests = ops.scan(%r{(?:([xmas])(.)(\d+):)?(\w+)}).map{ Test[*_1] }
    [name, Workflow[tests]]
  end

  def process(p) = tests.find_map { |t| t.process(p) }
end

def part1(input)
  insns, parts = input.read.split("\n\n")
  insns = insns.lines.to_h { Workflow.parse(_1) }
  parts = parts.lines.map { Part[**_1.scan(%r{([xmas])=(\d+)}).to_h] }
  parts.sum do |p|
    dst = 'in'
    dst = insns[dst].process(p) while insns.key?(dst)
    raise "part arrived somewhere else: #{p} -> #{dst}" unless %w[A R].include?(dst)
    dst == 'A' ? p.rating : 0
  end
end

def part2(input)
  insns, parts = input.read.split("\n\n")
  insns = insns.lines.to_h { Workflow.parse(_1) }
  startrange = 1..4000
  r = %w[x m a s].to_h { [_1, startrange] }
  q = [[r, 'in']]
  accepted = []
  until q.empty?
    r, i = q.shift
    case i
    when 'A'
      accepted << r
    when 'R'
      # rejected, do nothing more
    else
      insns[i].tests.each do |t|
        if !t.op
          q << [r, t.dest]
          break
        else
          lhs = r[t.cat]
          rhs = t.rhs.to_i
          if t.op == '<'
            l1 = lhs.begin..(rhs-1)
            l2 = rhs..lhs.end
            q << [r.merge(t.cat => l1),t.dest]
            r = r.merge(t.cat => l2)
          else
            l1 = lhs.begin..rhs
            l2 = (rhs+1)..lhs.end
            q << [r.merge(t.cat => l2),t.dest]
            r = r.merge(t.cat => l1)
          end
        end
      end
    end
  end
  accepted.sum { |r| r.values.map(&:size).inject(:*) }
end
