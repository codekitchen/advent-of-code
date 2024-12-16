#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

# sokoban!

MOVE = { '<' => :l, '>' => :r, '^' => :u, 'v' => :d}
REV = { l: :r, r: :l, u: :d, d: :u }

def part1(input)
  map, instrs = input.read.split("\n\n")
  instrs = instrs.chars.map { MOVE[_1] }.compact
  map = Grid.from_input map
  pos = map.find { _1 == '@' }

  instrs.size.times do |i|
    inst = instrs[i]
    case pos.send(inst).get
    when '#'; # do nothing
    when 'O'
      last = pos.send(inst)
      last = last.send(inst) while last == 'O'
      if last == '.'
        rev = REV[inst]
        while last.send(rev) != pos
          back = last.send(rev)
          swap(last, back)
          last = back
        end
        newpos = pos.send(inst)
        swap pos, newpos
        pos = newpos
      end
    when '.'
      newpos = pos.send(inst)
      swap pos, newpos
      pos = newpos
    end
  end

  # puts map
  score(map)
end

def part2(input)
  map, instrs = input.read.split("\n\n")
  instrs = instrs.chars.map { MOVE[_1] }.compact
  map = map.chars.flat_map { |ch|
    case ch
    when '#', '.'; [ch, ch]
    when 'O'; ['[', ']']
    when '@'; [ch, '.']
    else [ch]
    end
  }
  map = Grid.from_input map.join
  pos = map.find { _1 == '@' }
  puts map
  puts instrs[0]

  instrs.size.times do |i|
    inst = instrs[i]
    case pos.send(inst).get
    when '#'; # do nothing
    when '[', ']'
      boxpos = pos.send(inst)
      moving_boxes = Set[box_for(boxpos)]
      loop do
        check_locs = Set.new
        case inst
        when :r
          moving_boxes.each { |b| check_locs << b.r.r }
        when :l
          moving_boxes.each { |b| check_locs << b.l }
        when :u
          moving_boxes.each { |b| check_locs.merge([b.u, b.r.u]) }
        when :d
          moving_boxes.each { |b| check_locs.merge([b.d, b.r.d]) }
        end
        all_clear = true
        failed = false
        check_locs.each do |loc|
          case loc.get
          when '[', ']'
            # another box
            next if moving_boxes.include? box_for(loc)
            all_clear = false
            moving_boxes << box_for(loc)
          when '#'
            failed = true
          end
        end
        break if failed
        next unless all_clear
        # we can move all the boxes, and the robot
        moving_boxes.each do |box|
          box.set '.'; box.r.set '.'
        end
        moving_boxes.each do |box|
          box = box.send(inst)
          box.set '['; box.r.set ']'
        end

        pos.set '.'
        pos = pos.send(inst)
        pos.set '@'
        break
      end
    when '.'
      pos.set '.'
      pos = pos.send(inst)
      pos.set '@'
    end

    # puts map
    # puts instrs[i+1]
    # gets
  end

  puts map
  score(map)
end

def score map
  map.select { _1 == 'O' || _1 == '[' }.sum { |box| box.x + box.y * 100 }
end

def swap(a, b)
  ch = a.get
  a.set b.get
  b.set ch
end

def box_for pos
  pos == '[' ? pos : pos.l
end
