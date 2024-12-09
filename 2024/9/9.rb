#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

def part1(input)
  disk = parse input
  # compress file blocks
  free_cursor = 0
  (disk.size-1).downto(0) do |i|
    next unless disk[i]
    free_cursor += 1 while disk[free_cursor]
    break if free_cursor >= i
    disk[free_cursor] = disk[i]
    disk[i] = nil
  end
  checksum disk
end

def part2(input)
  disk = parse input
  # compress whole files
  cursor = disk.size-1
  while cursor >= 0
    cursor -= 1 until disk[cursor]
    last = cursor+1
    id = disk[cursor]
    cursor -= 1 while cursor >= 0 && disk[cursor-1] == id
    first = cursor
    size = last - first

    freepos = find_free(disk, size, first)
    if freepos
      # move file
      size.times { |i| disk[freepos+i] = id; disk[first+i] = nil }
    end

    cursor -= 1
  end
  checksum disk
end

def parse(input)
  id = (0..).each
  ints = input.read.chomp.split(//).map(&:to_i)
  ints.each_with_index.flat_map { |int,i| [i%2 == 1 ? nil : id.next] * int }
end

def disk_to_s(disk) = disk.map { |i| i || '.' }.join
def checksum(disk) = disk.each_with_index.sum { |id,i| i * (id||0) }

def find_free(disk, filesize, before_pos)
  pos = 0
  loop do
    pos += 1 while disk[pos]
    return nil if pos >= before_pos
    endpos = pos
    endpos += 1 until disk[endpos]
    freesize = endpos - pos
    return pos if freesize >= filesize
    pos = endpos
  end
end
