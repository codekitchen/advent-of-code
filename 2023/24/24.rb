#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require 'ruby-progressbar'

I = Float::INFINITY
L = Struct.new(:x,:y,:z,:dx,:dy,:dz) do
  def i2d(o)
    x1,y1=x,y
    x2,y2=x+dx,y+dy
    x3,y3=o.x,o.y
    x4,y4=x3+o.dx,y3+o.dy
    d = (x1-x2)*(y3-y4) - (y1-y2)*(x3-x4)
    return [I,I] if d == 0
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
  ls.combination(2).count do |l1,l2|
    x,y = l1.i2d(l2)
    testx.include?(x) && testy.include?(y) && !l1.past?(x,y) && !l2.past?(x,y)
  end
end

def all_intersect?(ls)
  x,y = ls[0].i2d(ls[1])
  return false if x == I || y == I
  return [x,y] if ls.combination(2).all? { [x,y] == _1.i2d(_2) }
end

def part2(input)
  ls = input.readlines.map{L.new(*(_1.tr('@',',').split(',').map(&:to_i)))}
  ls = ls[0,4]
  ext=1000
  founds = Set.new
  (-ext..ext).each do |dy|
    (-ext..ext).each do |dx|
      adjusted = ls.map { |l| l.dup.tap {|l2| l2.dx -= dx; l2.dy -= dy } }
      if all_intersect?(adjusted) in [x,y]
        found = [x,y,dx,dy]
        if !founds.include? found
          puts "found potential intersect at #{dx}, #{dy} [#{x},#{y}]"
          founds << found

          (-ext..ext).each do |dz|
            zs = adjusted.map { |o|
              t1 = (x-o.x) / o.dx
              z = o.z + t1 * o.dz - t1 * dz
            }
            if zs.uniq.size == 1
              rock = L[x,y,zs.first,dx,dy,dz]
              puts "rock is #{rock}"
              puts rock.x+rock.y+rock.z
              exit
            end
          end
        end
      end
    end
  end
  founds
end
