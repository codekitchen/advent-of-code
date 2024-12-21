#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

def run(input, aoc)
  instructions = input.readlines(chomp: true).map { it.downcase.chars }

  keypad = Grid.new(3, 3, "123456789")
  finger = keypad.at(1,1)
  code = instructions.map { |line|
    line.each { |dir| finger = finger.send(dir) || finger }
    finger.value
  }
  aoc.part1 code.join

=begin
    1
  2 3 4
5 6 7 8 9
  A B C
    D
=end
  keypad = Grid.new(5, 5, "xx1xxx234x56789xABCxxxDxx")
  finger = keypad.find('5')
  code = instructions.map { |line|
    line.each do |dir|
      newpos = finger.send(dir)
      finger = newpos if newpos && newpos != 'x'
    end
    finger.value
  }
  aoc.part2 code.join
end
