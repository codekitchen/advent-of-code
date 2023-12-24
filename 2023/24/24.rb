#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'

L = Struct.new(:x,:y,:z,:dx,:dy,:dz) do
  def i2d(o)
    x1,y1=x,y
    x2,y2=x+dx,y+dy
    x3,y3=o.x,o.y
    x4,y4=x3+o.dx,y3+o.dy
    d = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4)
    return [Float::INFINITY,Float::INFINITY,] if d == 0
    [
      ((x1*y2-y1*x2)*(x3-x4)-(x1-x2)*(x3*y4-y3*x4))/d,
      ((x1*y2-y1*x2)*(y3-y4)-(y1-y2)*(x3*y4-y3*x4))/d,
    ]
  end

  def past?(x2,y2)
    ((x2-x) > 0 && dx < 0) || ((x2-x) < 0 && dx > 0) ||
      ((y2-y) > 0 && dy < 0) || ((y2-y) < 0 && dy > 0)
  end
end

def part1(input)
  if input.basename.to_s =~ /example/
    testx = testy = 7..27
  else
    testx = testy = 200000000000000..400000000000000
  end
  ls = input.readlines.map{L.new(*(_1.tr('@',',').split(',').map(&:to_i)))}
  # pp ls
  ls.combination(2).count do |l1,l2|
    x,y = l1.i2d(l2)
    testx.include?(x) && testy.include?(y) && !l1.past?(x,y) && !l2.past?(x,y)
  end
end

# def part2(input)
# end
