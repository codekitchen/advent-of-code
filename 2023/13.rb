#!/usr/bin/env ruby --yjit
###
# impl
###
require_relative './../utils'

def parse(input)
  input.split("\n\n").map { |puz| puz.lines.map { _1.chomp.chars } }
end
def ppuz(puz) = puz.map(&:join).join("\n")

def lines_of_reflection(puz)
  (0..puz.size-2).select do |i|
    left = puz[..i]
    right = puz[i+1..]
    sz = [left.size, right.size].min
    left.reverse[...sz] == right[...sz]
  end
end

def score(puz)
  lines_of_reflection(puz).map { 100*(_1+1) } +
  lines_of_reflection(puz.transpose).map { _1+1 }
end

def part1(input)
  parse(input).sum { |puz| score(puz).first }
end

def score2(puz)
  scores = score(puz)
  (0...puz.size).each do |y|
    (0...puz[0].size).each do |x|
      chr = puz[y][x]
      puz[y][x] = chr == '#' ? '.' : '#'
      s2 = score(puz)
      news = s2 - scores
      return news[0] if news[0]
      puz[y][x] = chr
    end
  end
  puts "no solution found for\n#{s1}\n#{puz.map(&:join).join("\n")}"
end

def part2(input)
  parse(input).sum { |puz| score2 puz }
end

###
# data and runner
###

SHORT = %{#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#}
FULL = DATA.read

puts "part1 short", (part1 SHORT).inspect
puts "part1 full", (part1 FULL).inspect
puts "part2 short", (part2 SHORT).inspect
puts "part2 full", (part2 FULL).inspect

__END__
.#..#......
..#.#......
..#...#....
#.##...####
.#..#..####
#.#.##.####
###..#.#..#

.#.##.#.###
..####..##.
#########..
.##..##..##
.##..##..##
#########..
..####..##.
.#.##.#.###
#.#..#.##.#
..#####.###
...##.....#
..#..#..#..
...##...#..

..##.#.
#...###
#...###
..##.##
..#..#.
....##.
#.#.#..
.#...##
##.#...
###.###
###.###
##.#...
.#...##

#.#.###
..##.##
...####
##....#
##....#
...####
..##.##
#.#.###
#.#####
....##.
.#...#.
#.#####
#....##
#..##.#
#..##.#
#..#.##
#.#####

###...#...#.#..
.#.##.#.....#..
..###..#..#....
..###..#..#....
.#.##.#........
###...#...#.#..
###..#..##.#.##

##.#.....
##.#...#.
..#.#..##
..##....#
#..#....#
#.#..##..
#.#..##..
#..#....#
..##....#
..#.#..##
##.#...#.
##.#.....
#.#..#.#.

#..#..#..#.##
..........###
..........###
#..#..#..#.##
###....####.#
....##......#
##..##..##..#
###....####..
....##.....##
.#......#.#.#
.##....##..##
..#.##.#....#
####..######.
.##..#.##.###
..##..##...#.

..#.###..#.
####.#.....
..#.##.##..
...##...#.#
###.#......
#######.###
..#.#...###
###.###.##.
###..#...##
##....##.#.
####...#.##
..###......
.###..#.#..
##.##..#.#.
##.##..#.#.

#.##.###......#
.#..#.#..##..##
..##..#.#..#...
#....##.#.#.#..
#....##.######.
######....###.#
#.##.#...##.##.
..##..#####.###
..##..######..#
..##..######..#
..##..#####.###
#.##.#...##.##.
######....###.#
#....##.######.
#....##...#.#..

......#....#...
.####...##...#.
######..##..###
######..##..###
......##..##...
.####.######.##
.#..#.######.#.

#############..##
.########...###.#
.########...#.#.#
#.##..##.###..##.
..#.##.#....#.#..
..#....#...####..
#.#....#.##.#.#..
.#......#......##
.#......#......##
#.#....#.##.#.##.
..#....#...####..

...#.###.#.
....##.#.##
..##..#.###
..##..#.###
....##.#.##
...#.###.#.
#.#.#.#.#..
...##.#..##
.#.####...#
.#.#.##...#
...##.#..##
#.#.#.#.#..
...#.###.#.
....##.#.##
..##..#.###

.#.##.#.#.#..#.
.........######
###..####.#..#.
##.##.##.......
..#..#..##....#
.#.##.#...####.
##.....#..####.
..####..#..##..
##....##...##..

....####.####..
.#..####.####..
#.#.##..#####..
##..#.#.#######
.#.#.##.##.##..
..##..#.##..#..
####....#...#..
..#.#....##.#..
#..#..#..##.#..
.#.......#.####
..........##...
#.....####.#.##
##....##....###
.....#.##.#####
.#..#.##....#..
#.....###...#..
#....##........

#..##..#....###
#..#.#......###
.....#..####...
.##.##.##...###
.....##.###..##
.##..##....#.#.
.##...#.#.#.#..

.###.....##
..#......#.
..####.####
#.##...#.#.
#..#...####
##.#.#..###
##.#.#..###
#..#...####
#.##...#.#.
..####.####
..#......#.
.###.....##
.#.##.#..#.
..#...###..
..#...###..
.#.#..#..#.
.###.....##

###..##
...####
.#..#.#
#.##...
#...#..
#...#..
#.##...

..#......#.....
#.#......#.#..#
.#..####..#....
.#.#....#.#.##.
..########..##.
..#.####.#.....
..###..###..##.
#..######..####
.#####.####.##.
#..#....#..#..#
##........##..#
.....##.....##.
.##.#..#.##....

...#.##
...#...
#..####
#..####
...#...
...#.##
#.###.#
.##.#.#
.#.###.
.##.##.
.##..#.
.#.###.
.##.#.#

..#...##.
..###..##
...##.#..
###.#.##.
..##..##.
###..###.
..#.#.#..
####..#..
...#####.
##.####..
###.#..##
..#######
..#######
###.#...#
##.####..
...#####.
####..#..

.##...##.
#..##..#.
###..####
#..##.##.
.##..##..
#..###.##
.##.##.##
....##.##
.##.##..#
.##.##...
.##.##...
.##.##..#
....##.##

#...#.##.##..#.##
##..#.###...#####
##..#.###...###.#
#...#.##.##..#.##
...#.....###..##.
..####.#.#.####.#
..####.#.#.####.#
...#.....###..##.
#...#.##.##..#.##

.##..####.#####
.##..####.####.
.##.#.##..#.###
#..#.######.#.#
.#....##..##...
##..#.####..##.
.....#......##.
##..##..#.#.###
...##..#.#.#.#.
...#..##.###...
...#..##.###...

#..##.#.#.#
######..##.
#..#...#..#
#..#...#..#
######..##.
#..##.#.#.#
#..#..##..#
#...##.#.##
######.##.#
....#..####
####..##.#.

##.##..##.#.##.#.
....##.###..##..#
.##.#.##..######.
.##.#.##..######.
....##.###..##..#
##.##..##.#.##.#.
#####..#...####..
..##....###.##.##
.####...##.#..#.#
.####....#......#
##..#...#........
.##.#..#..##...#.
#####..#.##....##
#.#.#.#..#.####.#
##.######........

....#.#..
....#.##.
##.##.#..
##...#.#.
#.##..###
#.##..###
##...#.#.

##....###.####..#
##....###.####..#
.#.##.#.....#####
.######..#.#..#.#
.######.##.######
..#..#....####.##
.######.#.#.###.#
###########.#.##.
........##....#..
##.##.###..#.####
#......##....###.
#.....#####...#.#
###..###.##...##.

#..#...##
........#
....##...
....###..
........#
#..#...##
####.##..

.##..#.
##....#
##....#
.##..#.
...#.#.
#####.#
#####..
...#.#.
.##..#.

.##....#.#.##
#..#.....#...
.##.....###..
#..#...##....
#..#...#...##
..#.#.#......
.....#.#..###

#.....###....#.##
#.##.#.....#...#.
....#####.#...###
#...#..#...#.....
....#...#...####.
....#.#.#...####.
#...#..#...#.....
....#####.#...###
#.##.#.....#...#.
#.....###....#.##
.##.##....#..##..
...#.#.#..#.#...#
####...##.##...#.
.###.....###....#
.###.....###....#

..##..#...##...
##..##..#....#.
......#.#.##.#.
..##..#.#.##.#.
#.##.###.####.#
.####.....##...
.###..#........
.#..#.####..###
##..###...##...
#.##.####.##.##
######....##...
######.##.##.##
.####.#.#.##.#.
######..##..##.
.#..#..########
#.##.##...##...
#....##.##..##.

#..#..##.##.....#
....###.#...##.#.
##..#.#...###.##.
##...#..#.#..##.#
..#.#.....#.#####
..#.#.....#.#####
###..#..#.#..##.#
##..#.#...###.##.
....###.#...##.#.
#..#..##.##.....#
#..#..##.##.....#
....###.#...##.#.
##..#.#...###.##.
###..#..#.#..##.#
..#.#.....#.#####

##.########.####.
......#...#.####.
#.##..###.#######
##...#.###.##..##
##...#.###.##..##
#.##..###.#######
......#...#.####.
##.########.####.
..#####..#.######
#..###.#.#.#....#
..#.#....##.####.
......#.###..#...
..#...##...#....#
#...#....##..##..
.###.#.##.##.##.#
..#...##.##......
.##..#.##....##..

.###...#...#.#.
.###...#...#.#.
#...#.###..###.
##.##.#..#.####
.........#..###
..##.###..###.#
.......####....
####.#.#.#..###
####.###.#..###
.......####....
..##.###..###.#

.#..#..
.#..#..
#.#.#..
.##.#.#
#..#.##
..###..
.#.....
######.
#####.#
#####.#
######.
.#..#..
..###..
#..#.##
.##.#.#

#....#.#...##
######....#..
..........###
########.#...
#...###...###
##..###....##
..##...##....
#....##...#..
......#.#.#..

##########.#.#.##
..........#.#.##.
#..#..#..#..##..#
..........#.###.#
..........######.
.##.##.##.####.#.
#..####..#####..#
#..####..##...##.
..#.##.#...###..#
#..####..#......#
####..#######..##
#..####..##.##.#.
####..#####..####
....##.........#.
.............##..

.#..#.####..#.#..
####.#...#.......
#.##.#.#.##..#...
.........#..#.###
......#..#.#.##..
######.#.##...#..
.####..##.#...###

...##.##.
.....#.##
##...#..#
...##.##.
..#######
..#######
...##.##.
##...#..#
.....#.##
...##.##.
..####..#
....#####
.#.##....

..##....###
######.#..#
..##..#.#..
#######.###
...#.####..
##..#.###.#
##..#...#.#
###.##..##.
###.#.#.#.#
...#...#..#
###.#.#####
###..##....
...#.#....#
...#.#....#
###..##....
###.#.###.#
...#...#..#

##..####.#.
##..###.###
......##.#.
######...##
##..##..#.#
##..###...#
##..###.###
#.##.#.####
......####.

..#.##.##.#
#.##..####.
#....#.##.#
.##....##..
#..##......
##.#.......
#####......
#.#.#.#..#.
##..#.####.
#.#...#..#.
#.##..###..
###........
###.#......
..###..##..
..###..##..

####.###.##.#
......#......
....##.##.#..
....#..#.#..#
#####..#.###.
.....##...##.
#####.#.#.#..
....#......#.
.....#..#...#
####.#####.#.
#####.#..#...
.##...######.
.....#.######
####.#.##...#
.....##..####
....###.###.#
####.####...#

..###....###...
.##...###......
#.#..#..###....
##.##.#...#..##
#.####.#.##.###
#.####.#.##.###
##.##.#...#..##
#.#..#..###....
.##...###......
..###....###...
#.#..#......###
....#..##.#.###
...#.##..#.###.
.#.####.#.##.##
.#...##.###.###
###..#...#...##
###.#.#........

...##..#.##
..#..###..#
##.##.##..#
..#.#.#....
##....#.##.
..#####....
##..#.##..#
###...#....
...#.#.#..#
...########
###..##....
..##.......
###..#.....
###.##.....
###.#.#....

.#.#..#
#..#..#
.#.####
#...##.
..#....
##.#..#
.#.....
#...##.
#...##.
.#.....
#..#..#

###...##.##..#.#.
..#.####...#....#
....#..######....
....#.....#..#.#.
....#.....#..#.#.
....#..######....
..#.####...#....#
###..###.##..#.#.
###..#......#..#.
##..###.##..#####
...#...###....#..

.#.....####..##.#
#.####.##.##.....
##..###.###.##..#
...###.##.##.#...
##.#.#.##.#..#...
#..#.##.#.....#..
.#..#...##....##.
.#..#...##....##.
#..#.##.......#..
#..#.##.......#..
.#..#...##....##.
.#..#...##....##.
#..#.##.#.....#..

##..##..##..#
..##.#..#.##.
##...#.##...#
###..####..##
..##..##..##.
..#...##...#.
.....####....
....#....#...
..###.##.###.
###........##
..###.##.###.
##..######..#
..#..#..#..#.
##..##..##..#
..##.#..#.##.

#....########
.#....#..##..
#.##...##..##
..#.#.#.####.
##...#..####.
###.#...####.
.#.##...#..#.
.#....#..##..
..#...#.####.
..#...#.####.
.#....#..##..
.#.##...#..#.
##..#...####.

#.#......###.##.#
#.#...#..###.##.#
#..###..#.#..##..
###.#..##..##..##
.#..#..##........
#.###.....###..##
##..#.#.##.######
##.#.....#.#.##.#
##...#.##..#....#
...#.##..........
.##.#.#..#.......

..#####.#
....##.##
..#.#####
#..###.#.
###..##.#
.#...#.#.
.#...#.#.
###..#..#
#..###.#.
..#.#####
....##.##
..#####.#
.###..##.
...#.####
..###...#
..###...#
...#.####

..#...#...##.#.
##.....####.###
##.....###..###
..#...#...##.#.
##........#....
..#.##.###.#...
####.###.#####.
####.....###..#
....#.....#####
##....#.#..#..#
....##..#..#.#.
...##.###.....#
###.#.##.....##
##..###.#..####
##..####....##.
##.###....#.#.#
###..#.#.##.#.#

...#.##..
..#.####.
####.##.#
###.#..#.
##.#.##.#
..#..##..
###......
....#..#.
.....##..
####....#
...#.##.#
..#..##..
##.######

#.##.....
..#.#..#.
..#.#..#.
#.##.....
.##.....#
##.##..##
..###.###
.##..##..
.##..##..
..###.###
##.##..##
.##.....#
#.###....

#....#.##.####...
##.#...#..#..#.#.
####..####.######
..#...#...#...##.
###....#.#.#####.
###.#..##.....#.#
##.####.##.##..##
....##...##..#..#
##.....#.#.#...##
###.#.##.#.##..##
..##..##....#.###
##.##..#...###...
...###.#...####.#
...#....##.....##
##########...#..#
##....#.#.#......
##....#.#.#......

###.##.####
.##.##.##.#
#####.####.
#.#.##.#.#.
.#..##..#.#
..##..##...
#...##...##
#.#.##.#.##
##.####.##.
####..#####
..##..##..#
.##....##.#
.##....##.#
..##..##..#
####..#####
##.####.##.
#.#.##.#.##

.###............#
..#..##......##..
###....#....##...
###..####..####..
.....##.#..#.##..
..###.###..###.##
.##....#.##.#....
..#...#......#...
#..#.###.##.###.#
#.##...#.##.#...#
..#.##.#.##.#.##.
####...#....#...#
####...#....#...#
..#.##.#.##.#.##.
#.##...#.##.#...#

#..##.#
.##..##
.##..##
#..##.#
.#...##
..#####
....#..
.#...#.
.#.###.
.#.###.
.#...#.
....#..
..####.

##.......
##..#..##
#####....
.#.#..#..
.....#.#.
.##.##.##
.##.##.##
.....#.#.
.#.#..#..
#####.#..
##..#..##
##.......
##.......
##..#..##
#####.#..

..###....#.#.###.
#........###.####
..#...##.###.#..#
.#.##.##....#....
#.##.###..#.#####
##..###.#.....##.
##..###.#.....##.

..##.#.##.#.##..#
.#.##.####..#.#.#
...###....###...#
#....#....#....#.
####.#....#.#####
.##..........##..
.##..........##..
####.#....#.#####
#....#....#....#.

..##...##
.....#.##
.###.#...
..###.#..
..#.##.##
...#.####
...##..##
##.##...#
#####.#..
###.####.
.......#.
##.#.####
##.#.####
.......#.
###.####.

#..#..###
#####..##
..#.#....
###..#..#
##.###...
...###.#.
##.###.#.
...#.....
...###..#
....#..#.
##.#####.
###.#.###
###.#.###
##.#####.
....#..#.
...###..#
...#.....

...#...
...#.#.
##.....
....##.
...#.#.
..#.#..
#.#.#.#
#.#.#.#
..#.#..
...#.#.
....##.
##.....
...#.#.
...#...
##..#..
#.#.#..
#.##...

#..#...##.#....
#...#....###..#
.#.##.......##.
##..##..#..#..#
####..##..#....
###..#.........
#..##.#.##..##.
##..#.#.#..#..#
.###########..#
..........#.##.
###....#.#.....
##...##.####..#
##...##.####..#
###....#.#.....
..........#.##.
.###########..#
##....#.#..#..#

####.##.###..
###########..
....##...##..
########.####
####.####.#.#
....##.#.####
####..#.##.#.
######.#...##
#..#..#..#...
........#....
....##...##.#

.###..##.
###.#.#..
.######..
###.##.#.
###..#.#.
....#..#.
....#..#.
###..#.#.
###.##.#.
.######..
###.#.#..
.###..##.
..#.##..#
..#.#...#
..#.#...#
..#..#..#
.###..##.

###.#..
.#.####
#.##.##
...####
.#.#..#
##.#.##
#####..
#####..
##.#.##

..##.###..##.##.#
#.#....##.#...#..
#.#....##.#......
..##.###..##.##.#
..##.###..##.##.#
#.#....##.#......
#.#....##.#...#..
..##.###..##.##.#
##.##.##....##.#.
.#.#.###.###..#..
...##.#.#.#######
##..#.#..###.####
#.....##.###.#..#
.####.##..#.##...
###.#.#...##.#.#.

#....###.###..#
#######.#...#..
######.##..###.
#....#..#...#.#
##..##..####.#.
#########......
.#..#.####....#
######.##....#.
######.##....#.
.#..#.####....#
#########.....#
##..##..####.#.
#....#..#...#.#
######.##..###.
#######.#...#..

##.##..##.####.
.#........#..#.
.#..#..#..#..#.
###.#..#.######
##........####.
##.#....#.####.
..###..###....#
.#...##.#.#..#.
###.####.######

#...#..#.
#.#.#..#.
#.#..##..
###.#..#.
#.###..##
#.#..##..
##..#..#.
####....#
.#.#....#

##.....##....
.#...##..##..
#..##.#..#.##
##.###.##.###
.#.####..####
....########.
.##..######..
#.#..#....#..
.##...####...
#.###.#..#.##
..###.#..#.##
.##..######..
##.###....###

#.#.###..
#.#.#.#.#
#.#.#.#.#
#.#..##..
#..##...#
....##...
#.#..###.
##...#.##
##...#.##
#.#..###.
....##...
#..##...#
#.#..##..

.....##..###..#
##..#..##.##...
.##...##..#..##
.#..###.##.##.#
.#..###.##.##.#
.##...##..#..##
#...#..##.##...
.....##..###..#
#.###.......#.#
##..##...#.####
##..##...#.####
#.###.......#.#
.....##..###..#

#........
..#.####.
..#..##..
##.......
####....#
##.......
...######
..##.##.#
#####..##

##......#####
#.######.##..
#..####..##..
..##..##...##
##......###..
.#.#..#.#....
##..##..###..
.#.#..#.#.###
##########.##
..#....#..#..
.##.##.##....
#..####..#...
#.#.##.#.#...
#.#.##.###...
....##....###
###....###...
##.#..#.###..

....###...####...
.##.#.#..##..##..
......##...##...#
#..##.####.##.###
.#...#..#.#..#.#.
.##.#.###......##
#..##..###....###
.##.#..###.##.###
.##...#..#.##.#..
........#.####.#.
####.###.#.##.#.#
####..#.########.
######...######..
.....###...##...#
#..#.##.########.

###..####..
......##...
......##...
###..####..
...#..##..#
#..#.####.#
##.#.####.#
.##.#.##.#.
..#........
#..##....##
..#.#....#.
..#........
#..#....#.#
.#....##...
#.#...##...

###......###.
####....#####
..#..##..#.#.
....####....#
#.##....##.##
.##.#..#.##..
...##..##....
#.##.##.##.#.
#.##.##.##.#.
...##..##....
.##.#..#.##..

.##.....#..#.
....####....#
.#.####.#..#.
##.#...#....#
##.....#....#
##.##..#....#
..#..#...##..
..#..#...##..
##.##..#....#
##.....#....#
##.#...#....#
.#.####.#..#.
....####....#
.##.....#..#.
.#..###..#...

...#...######
.###....#####
..##....#....
#.#.#.##.#..#
##.##..#.####
##.....#.####
..#.##...#..#
.#.......#..#
##..##.#.####
##...#.#.####
.#.......#..#

.#.###..#.##.
.#.###..#.##.
..#...#...###
##.....#.##..
#.#.#....#..#
###....#.....
.#.###.#...#.
########..#.#
##.#####..#.#

#.#....#....#..
######.#....#.#
.#####.######.#
##....#.#..#.#.
.##...####.###.
....#..######..
#######.#..#.##
.......#.##.#..
.###....#..#...
#..##.#..##..#.
.#.##.###..###.
...##..######..
...##..######..

.#.####.#.....#.#
...#..#...#...##.
###....###.#.#.##
#.#.##.#.#.#.#...
##.####.#####..##
##.#..#.####...##
#######.##.#..##.
##..##..####.#..#
#..####..#....##.
#.######.#.##..#.
##########.####.#
#.#.##.#.##.##..#
..#....#..####.#.
#........#..####.
..######....#.###
..######....#.###
#........#..####.

#.#..#..##..#
#.#..#..##..#
.###...#..#..
.#.##..####..
.###.#......#
...#..######.
...###.#..#.#
###.....##...
###.##......#
#...##.##.#.#
..##..#.##.#.

.#....#.#.#..#.
##.####.##.#..#
.#..#.#.##..##.
.#..#.#.##..##.
##.####.##.#..#
.#..#.#.#.#..#.
...#..#.###..#.
..##....#.#.#.#
##.#.#..##..##.
..###.#..##..##
#.#..##.##.#...
..#..###...###.
#..#...####.###
...#.#.#.###.#.
...#..#...##..#
...#..#...##..#
...#.#.#.###.#.

..#.#.###...#.##.
#####...###...#..
#...#..#.#..##.#.
#...#..#.#..##.#.
#####...###...#..
..#.#.###...#.##.
.#.##......#.#...
.........#..##...
####.#...#....#.#
.#..##.###....##.
.#..##.###....##.
####.#...#....#.#
.........#..##...
.#.##......#.#..#
..#.#.###...#.##.

#..#.#.#..##..##.
.#..#.##..##..##.
#....#.#....##...
..##..#####.##.##
#....#.###..##..#
..##..#.#..####..
######.#.#.#..#.#
#.##.#..#...##...
#.##.#....##..##.
..##..###.######.
##..####..#....#.
##..##...#..##..#
##..###..##.##.##
##..######.####.#
..##......#....#.

##..###.#
..##.##..
###.#...#
####.####
###..###.
...##....
...##....
###..###.
####.####
###.#..##
..##.##..
##..###.#
######...
....#..##
######.##

..###.####.......
##..####.###.##..
#.....#..##.####.
#.##.##..#.##..##
.#####.#.#.#.##.#
##....##...######
####....##.######
#.#####.##.#.##.#
...#.###..#..##..
....##.......##..
....##.......##..
...#.###..#..##..
#.#####.##.#.##.#
####....##.######
##....##...######
.#####.#.#.#.##.#
#.##.##..#.##..##

.#.##.#.##.
.#.##.#.##.
#.#..#.####
.######.#.#
##....###.#
.#.##.#.##.
#.#..#.#.##
#.####.##.#
..#.....###

..#####....
..###..####
..#..#.#...
#..#..##..#
..##..#....
#..#..##..#
.####......
..######..#
...#.#.####
#.##.#.#..#
..#..#.#..#
..#..#..##.
..#..#..##.

#....##....##
###......####
#..#....#..##
#.#.#..#.#.##
#.###..###.##
###.#..#.####
.#........#..
##.######.###
#..##..##..##
.####..####..
#.#..##..#.##
#.#.#..#.#.##
#.##....##.##
##.######.###
..#.####.#...
###..##.#####
##...##...###

.#.####...###
##.###.#.##..
#...##..#.###
#...##..#.###
##..##.#.##..
.#.####...###
#.#...#.##...
...#.......##
####.##.#.#..

..#.#..
##..#..
##..#..
...####
####.##
....#..
#####..
#..##..
.....##
..##...
....#..
##..###
...##..

.##..#...#.#.
.##..#...#.#.
.....#..####.
.##.#.#..###.
.##...#..#..#
#####.##.#.#.
#.##.#..#.#.#

#....##...#.##.
#....#...###..#
.####.##.##....
..##...########
##..##..##.#..#
#.##.#.....#..#
..##..#.....#..