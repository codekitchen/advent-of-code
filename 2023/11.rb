#!/usr/bin/env ruby --yjit
###
# impl
###
require_relative './../utils'
require_relative './grid'

def part1(input)
  g = input.lines.map { _1.strip.chars }
  es = g.each_with_index.map { |l,i| i if l.all? { _1 == '.' } }.compact
  es.reverse.each { |i| g.insert(i, g[i]) }
  g = g.transpose
  es = g.each_with_index.map { |l,i| i if l.all? { _1 == '.' } }.compact
  es.reverse.each { |i| g.insert(i, g[i]) }
  g = g.transpose
  g = Grid.new(g.first.size, g.size, g.join)

  gals = g.select { _1.get == '#' }
  gals.combination(2).sum { (_2.y-_1.y).abs + (_2.x-_1.x).abs }
end

def part2(input, factor)
  factor-=1
  g = input.lines.map { _1.strip.chars }
  eys = g.each_index.select { |i| !g[i].index '#' }.to_set
  g2 = g.transpose
  exs = g2.each_index.select { |i| !g2[i].index '#' }.to_set
  g = Grid.new(g.first.size, g.size, g.join)

  gals = g.select { _1.get == '#' }
  gals.combination(2).sum do
    ys = Range.new(*[_1.y, _2.y].sort,true)
    xs = Range.new(*[_1.x, _2.x].sort,true)
    ys.size +
      xs.size +
      (factor * (eys & ys).count) +
      (factor * (exs & xs).count)
  end
end

###
# data and runner
###

SHORT = %{...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....}
FULL = DATA.read

puts "part1 short", (part1 SHORT).inspect
puts "part1 full", (part1 FULL).inspect
puts "part2 short", (part2 SHORT, 100).inspect
puts "part2 full", (part2 FULL, 1_000_000).inspect

__END__
.......................................................................................#....................................................
............................#................#..............................................................................................
....#...............................#.............................................................#........#.......#........................
................#.....#...........................#..........#...............................#................................#............#
..........................................#.................................................................................................
..........#............................................#......................#........................................#..............#.....
............................................................................................................................................
..............................#.......................................#............#...............#......#.......#.........................
.................................................................#.........................#................................................
....................#..............#.....#..................................................................................................
..............#............#................................................................................................#.....#......#..
............................................................#...........................#...................................................
..#.........................................#......#......................#.................................................................
...............................................................................................#......................................#.....
............#............................................#.......................................................#..........................
.................#.....................................................................................#....................................
...............................#..................................................#.........#......................................#........
...............................................................#.................................#..........................................
..............#...................................#.......................#................................#........#.......................
.......................................................................................#....................................#..............#
.#........................#...................#................................................................#............................
....................................#......................................................#.........................................#......
...........#......................................................................#................#........................................
....................................................#....................#....................................................#.............
.....................#............................................#......................................#.........#........................
................#...........................................................................................................................
#.........................................#......................................................#................................#.........
............#.......................#........................................#........................#.....................................
......#..................................................................................#................................#.................
...........................................................................................................#........#.......................
.......................................................#.....................................#..............................................
.........#........................#............#...........................#.........#..............................................#.......
.....................................................................................................#......................................
....................#................................................#.........................................................#............
.........................................#.............................................................................#................#...
...........................#....................................#...........................................................................
.......#.......................................................................#.................#........#.......#.........................
......................................................................................#.....................................................
#......................................#..............................#..............................#......................................
.............#......#...........#...........................................................................................................
.....................................................#....................................#...................#..................#..........
..........................#......................................#........................................................#.................
..............................................................................#.............................................................
...................................#............................................................#........#..................................
....#..........#..........................................#..........#....................................................................#.
.................................................................................................................#..........................
...........................#.........................................................#......................................................
.........................................#...................#..............................................................................
........#............................................#........................................#...........#................#................
.............................................#.....................................................#.................#...............#......
............#.................#......#.............................#..........#................................................#............
...........................................................................................................................................#
.........................#.........................#........................................................................................
............................................................#...............................................................................
.........#................................#........................................#.............#.....................................#....
.................#..........#............................................................#......................#...........................
..........................................................................................................#...........#.....................
..........................................................................#..................#............................................#.
......#.........................................................#...........................................................................
....................................................................................................#.....................#.................
...........#......................................#.................#.........#.............................#..................#............
............................#...............................................................................................................
....................#..................................................................#.............................#......................
..........................................#.......................................#.............................#........................#..
#.......#.....#................#.........................#................#..............................#..................................
............................................................................................................................................
.....................................#........................#......................#........#.............................................
.....#......................................#................................#..............................................#.......#.......
............................................................................................................................................
.................#......#........................................#..............................................#......#................#...
................................#.........................................#.................................................................
..........#..........................................................#...........#...............#..........................................
.......................................#.................#................................#..................#..............................
............................................................................................................................................
............................................................................................................................................
.#..................................#............................................................................................#..........
.............#.......#.......................................................#..............................................................
...................................................#.................................#.............#.......#...........................#....
............................................................................................................................................
......#....................#......#............................#....................................................#......#................
...............#..............................#......................#.............................................................#........
........................................#...................................................................................................
.........#..............................................................................................................................#...
.........................#......................................................#.........#..........#......................................
.............................................................#..............................................................#...............
....................................................#....................#..................................................................
#.............#.......................#................................................................................#........#...........
.....#...........................................................#......................................#.....#.............................
..........#.........#........#............................#......................................#..................................#.......
......................................................................................#......................................#..............
...............................................#.....#......................................................................................
................#.........................#....................#.......#.....#...........................................................#..
........................#........................................................................................................#..........
.#...................................#..........................................................#..........#................................
.....................................................................................................................#......................
...........................#..............................................................#.................................................
......#...............#.................................................................................................................#...
....................................................#.....#.............#.....................#.............................................
.......................................#........................................#..................#.............................#..........
............................................................................................................................................
..................#...............#...........#......................................................................................#......
.....................................................................#...............#.....................#..........#.......#.............
..................................................#..............................................#..........................................
..........................#...........#.....................................................................................................
...........................................................................................................................................#
.........................................................#...............#......................................#...........................
........#...........#...........................................#............................................................#..............
..............#.......................................................................#...........................................#.........
....................................................#.......................................................#...............................
................................#..............#........................................................................#...................
.........................................#.......................................................#..........................................
..........................................................#......#...........#...........#............#..............................#......
..........................#........#..............................................................................#...........#.............
...................................................#.......................................................#................................
.........#..............................................................................................................................#...
....................#........#..............................#...............................................................................
......................................................................#.........................#...........................................
......................................................#.......................#..........#...............#..............#...................
...#......................................#.................................................................................................
................#.................................#.........................................................................................
......................#.............#...........................................................................#..........#.........#......
.......#....................................................#............#..................................................................
...................................................................................#........................................................
............................................................................................#......................#........................
...........#...................#.........................#..........................................#......#................................
................#...................................#...........................#.....#.......................................#...........#.
.....................#..................................................#............................................................#......
...............................................................................................#............................................
.#.........................................#.......................#........................................................................
...................................#.........................#..............................................................................
.............................#..............................................................................................................
.................#....................................#....................................#...................#......#.....................
..........................................................................................................................................#.
........#......................................#..................#..........................................................#..............
..............#....................................................................#........................................................
.....................#......................................................................................................................
......................................#...................................................#.................................................
..#...............................................................................................................#.........................
..........................#...................#......#....................#...................#.............................#.....#......#..
......#.........#.................#..............................#..................#...............#........#..............................