#!/usr/bin/env ruby --yjit
require_relative '../../runner'
require_relative '../../utils'
require_relative '../grid'

def part1(input)
  input = input.readlines
  nsteps = input.shift.to_i
  grid = Grid.from_input input.join
  start = grid.cells.find { _1 == 'S' }
  start.set '.'
  q = Set.new [start]
  nsteps.times do |i|
    if $show
      puts i
      disp = grid.dup
      q.each { |p| disp.at(p.x,p.y).set('O') }
      puts disp
    end
    q = q.flat_map { |p| p.neighbors.select { _1 == '.' } }.to_set
  end
  q.size
end

def part2(input)
  #  131:      15569
  #  262:      61825
  #  393:     138769

  #   65:       3877
  #  196:      34674  30797
  #  327:      96159  61485
  #  458:     188332  92173

  # yeah... I printed the first four cycles and then used Wolfram to find the sequence formula :/
  seq = ->(n) { n+=1; 15344*n*n - 15235*n + 3768 }
  return seq.(26501365 / 131)

  input = input.readlines
  input.shift # ignore
  nsteps = 1000
  grid = Grid.from_input input.join
  start = grid.cells.find { _1 == 'S' }
  start.set '.'
  start = [start.x, start.y]
  q = Set.new [start]
  nsteps.times do |i|
    puts sprintf("%5d: %10d", i, q.size)
    q = q.flat_map do |pos|
      [
        [pos[0],pos[1]-1],
        [pos[0],pos[1]+1],
        [pos[0]-1,pos[1]],
        [pos[0]+1,pos[1]],
    ].select { grid[*grid.norm(*_1)] == '.' }
    end.to_set
  end
end

STATES = %w[. O #]
STATE_MAP = { '.' => 0, 'O' => 1, '#' => 2 }

require 'weakref'

class TransientCache < Hash
  class AmbivalentRef < WeakRef
    def __getobj__
      super rescue nil
    end
  end

  def []= key, object
    super(key, AmbivalentRef.new(object))
  end

  def [] key
    ref = super(key)
    if ref
      val = ref.__getobj__
      self.delete(key) if !val
    end
    val
  end

end

class Node
  class << self
    def n(*args)
      @cache ||= TransientCache.new
      @cache[args] ||= begin
        # puts "cache miss for #{args}"
        new(*args)
      end
    end
    def cache; @cache; end
  end

  def initialize(nw, ne, sw, se)
    @level = nw.is_a?(Array) ? 2 : nw.is_a?(Integer) ? 1 : nw.level+1
    @count = @level == 1 ? [nw,ne,sw,se].count(1) : [nw,ne,sw,se].sum(&:count)
    @nw, @ne, @sw, @se = nw, ne, sw, se
  end
  attr_reader :level, :nw, :ne, :sw, :se, :count

  def center
    @center ||= Node.n(@nw.se, @ne.sw, @sw.ne, @se.nw)
  end

  def result
    @result ||= if @level == 2
      Node.n(
        @nw.se == 2 ? 2 : ([@nw.ne,@nw.sw,@ne.sw,@sw.ne].any?(1) ? 1 : 0),
        @ne.sw == 2 ? 2 : ([@ne.nw,@ne.se,@nw.se,@se.nw].any?(1) ? 1 : 0),
        @sw.ne == 2 ? 2 : ([@sw.nw,@sw.se,@nw.se,@se.nw].any?(1) ? 1 : 0),
        @se.nw == 2 ? 2 : ([@sw.ne,@ne.sw,@se.ne,@se.sw].any?(1) ? 1 : 0),
      )
    elsif @level > 2
      n00 = @nw.result
      n01 = Node.n(@nw.ne, @ne.nw, @nw.se, @ne.sw).result
      n02 = @ne.result
      n10 = Node.n(@nw.sw, @nw.se, @sw.nw, @sw.ne).result
      n11 = Node.n(@nw.se, @ne.sw, @sw.ne, @se.nw).result
      n12 = Node.n(@ne.sw, @ne.se, @se.nw, @se.ne).result
      n20 = @sw.result
      n21 = Node.n(@sw.ne, @se.nw, @sw.se, @se.sw).result
      n22 = @se.result
      # n00 = @nw.centeredSubnode
      # n01 = centeredHorizontal(@nw, @ne)
      # n02 = @ne.centeredSubnode
      # n10 = centeredVertical(@nw, @sw)
      # n11 = centeredSubSubnode
      # n12 = centeredVertical(@ne, @se)
      # n20 = @sw.centeredSubnode
      # n21 = centeredHorizontal(@sw, @se)
      # n22 = @se.centeredSubnode
      Node.n(
        # Node.n(n00, n01, n10, n11).result,
        # Node.n(n01, n02, n11, n12).result,
        # Node.n(n10, n11, n20, n21).result,
        # Node.n(n11, n12, n21, n22).result,
        Node.n(n00, n01, n10, n11).center,
        Node.n(n01, n02, n11, n12).center,
        Node.n(n10, n11, n20, n21).center,
        Node.n(n11, n12, n21, n22).center,
      )
    else
      raise "can't result on level #@level"
    end
  end

  def to_a
    if @level == 1
      [@nw,@ne,@sw,@se]
    end
  end

  def showsub(x, y, step)
    if @level == 2
      case step
      when 1
        # pass
      when 0
        # return Node.n(@nw.se,@ne.sw,@sw.ne,@se.nw).showsub(x+1,y+1,step)
      # else raise "invalid step #{step} for level==2"
      end
    end
    if @level == 1
      # puts "showing #{self.inspect} [#{x},#{y}] #{step}"
      if step == 0
        @@showing[y][x] = STATES[@nw]
        @@showing[y][x+1] = STATES[@ne]
        @@showing[y+1][x] = STATES[@sw]
        @@showing[y+1][x+1] = STATES[@se]
      end
      return
    end
    result_step = 2**(@level-2)
      d = (2**@level)/2
      @nw.showsub(x, y, step)
      @ne.showsub(x+d, y, step)
      @sw.showsub(x, y+d, step)
      @se.showsub(x+d, y+d, step)
    # if step >= result_step
    #   d = (2**@level)/4
    #   # puts "showing at #{x+d} #{y+d} #{result.inspect}"
    #   result.showsub(x+d, y+d, step - result_step)
    # end
  end

  def show(step=0)
    sz = 2**@level
    raise "step #{step} must be <= #{sz-2} (2**level-2)" unless step <= sz-2
    res = sz.times.map { "#" * sz }
    @@showing = res
    showsub(0, 0, step)
    res.join("\n")
  end
end
# L1Node = Array
# L0Node = 0,1,2
# ....
# .O..
# ....
# ....
n = Node.n(Node.n(0,0,0,1),Node.n(0,0,0,0),Node.n(0,0,0,0),Node.n(0,0,0,0),)
assert_eq n.result.to_a, [0,1,1,0]
n = Node.n(Node.n(0,0,0,0),Node.n(1,0,0,0),Node.n(0,0,0,0),Node.n(0,0,0,0),)
assert_eq n.result.to_a, [0,1,0,0]

# .O.O
# ..O.
# ....
# ....
empty = Node.n(Node.n(0,0,0,0),Node.n(0,0,0,0),Node.n(0,0,0,0),Node.n(0,0,0,0))
ne = Node.n(Node.n(0,0,1,0),Node.n(0,0,0,0),Node.n(0,0,0,0),Node.n(0,0,0,0))
n = Node.n(empty,ne,empty,empty)
# assert_eq n.result.ne.to_a, [0,1,1,0]

def empty(n=1)
  return Node.n(0,0,0,0) if n == 1
  e = empty(n-1)
  Node.n(e,e,e,e)
end

def expand(n)
  e = n.level == 1 ? 0 : empty(n.level-1)
  Node.n(
    Node.n(e, e, e, n.nw),
    Node.n(e, e, n.ne, e),
    Node.n(e, n.sw, e, e),
    Node.n(n.se, e, e, e),
  )
end

def show_helper(n, step)
  return n.show(0) if n == 0
  req_levels = 2 + Math.log2(step)
  n = expand(n) while n.level < req_levels
  n.show(step)
end

def part2_conway(input)
  n = expand(expand(Node.n(0,0,1,0)))
  puts "#{n.level} (#{n.count})"
  puts n.show
  puts

  n = expand(n).result
  puts "#{n.level} (#{n.count})"
  puts n.show

  n = expand(n).result
  puts "#{n.level} (#{n.count})"
  puts n.show

  65.times { n = expand(n).result }
  puts "#{n.level} (#{n.count})"
  puts n.show

  25.times { n = expand(n) }
  26501365.times { |i| print("\r#{i}  #{Node.cache.size}           "); n = expand(n).result }
  puts
  puts "#{n.level} (#{n.count})"
  # 3.times { n = expand(n) }
  # puts show_helper(n,0)
  # puts
  # puts show_helper(n,1)
  # puts
  # puts show_helper(n,2)
  # puts
  # n2 = Node.n(empty(1),n,empty(1),empty(1))
  # n3 = Node.n(empty(2), empty(2), n2, empty(2))
  # n3 = expand(expand(expand(expand(n))))
  # puts n3.show(0)
  # puts
  # puts n3.show(1)
  # puts
  # puts n3.show(2)
end
