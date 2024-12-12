#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../../grid'

def run(input, results)
  map = Grid.from_input input
  regions = []
  map.each do |pos|
    next if pos == VISITED
    crop, squares, borders = flood_fill map, pos
    regions << { squares:, borders:, crop: }
  end

  results.part1 regions.sum { |r| r[:squares] * r[:borders].size }
  results.part2 regions.sum { |r| r[:squares] * count_sides(r[:borders]) }
end

Border = Data.define(:cell, :dir)
VISITING = '*'
VISITED = '.'

def flood_fill map, start
  crop = start.get
  squares = 0
  borders = []

  step = ->p do
    squares += 1
    p.set VISITING
    p.neighbors_with_dir do |n, dir|
      if n && n == crop
        step.(n)
      elsif !n || n != VISITING
        borders << Border[p, dir]
      end
    end
  end
  step.(start)
  map.each { _1.set VISITED if _1 == VISITING }
  return crop, squares, borders
end

def count_sides borders
  count = 0
  until borders.empty?
    b = borders.first # artbitarily pick next
    borders.delete b
    delete_connected borders, b
    count += 1
  end
  count
end

def delete_connected borders, b
  # search dir is perpendicular to fence dir
  search_dirs = %i[l r].include?(b.dir) ? %i[u d] : %i[l r]
  search_dirs.each do |search_dir|
    connected = b
    loop do
      # step in each direction, finding any connected
      connected = Border[connected.cell.send(search_dir), b.dir]
      break unless borders.include?(connected)
      borders.delete connected
    end
  end
end
