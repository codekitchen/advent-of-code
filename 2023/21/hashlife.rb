# To the extent possible under law, the author(s) have dedicated all copyright and related
# and neighboring rights to this software to the public domain worldwide. This software is
# distributed without any warranty.

# Implementation of the HashLife algorithm for cellular automaton similar to the Game of Life.
# This implementation supports stepping to an arbitrary timestep, not just a power of 2
# time step.
# This implementation also supports loading an infinite tiling "background" of arbitrary
# size to set the initial state of the simulation at any queried position.
# References:
# https://www.dev-mind.blog/hashlife/
# https://www.lri.fr/~filliatr/m1/gol/gosper-84.pdf
# https://conwaylife.com/wiki/HashLife
# https://web.archive.org/web/20220131050938/https://jennyhasahat.github.io/hashlife.html

# Developed using Ruby 3.3, but also seems to work fine on Ruby 3.2.

STATES = %w[. O #]
STATE_MAP = { '.' => 0, ' ' => 0, 'O' => 1, '#' => 2, 'S' => 0 }
class HashLife
  def initialize(bg_path)
    @background = File.readlines(bg_path).map { |l| l.chomp.chars.map { STATE_MAP[_1] } }
    @bh = @background.size
    @bw = @background[0].size
    @empty = {}
    @cache = {}
    mkroot(0,0)
  end
  attr_reader :bh, :bw, :background

  # erases the current tree!
  def mkroot(left, top)
    @left = left
    @top = top
    @root = empty(1, left, top)
  end
  attr_reader :left, :top
  # TODO: better abstraction so this doesn't need to be writeable,
  # this is a huge footgun
  attr_accessor :root

  # expand the universe by n levels, centered around the current root
  def expand(n=1)
    n.times do
      subtr = 2**(@root.level-1)
      larger = empty(@root.level+1, @left-subtr, @top-subtr)
      larger = larger.replace([
        larger.nw.replace([nil,nil,nil,@root.nw]),
        larger.ne.replace([nil,nil,@root.ne,nil]),
        larger.sw.replace([nil,@root.sw,nil,nil]),
        larger.se.replace([@root.se,nil,nil,nil]),
      ])
      @root = larger
      @left -= subtr
      @top -= subtr
    end
    @root
  end

  def build(*args)
    @cache[args] ||= Node.new(self, *args)
  end
  attr_reader :cache # for debugging

  # returns a new "empty" node at the given level
  #
  # however, the algorithm is extended here to populate empty nodes
  # with the background substrate -- the rock positions in AoC day 21.
  # this means that unlike the original algorithm, we need to track
  # grid positions that we can modulo with the background size to
  # read the background values.
  def empty(level=1, left, top)
    left %= @bw
    top %= @bh
    @empty[[level,left,top]] ||= begin
      if level == 1
        c00 = @background[top][left]
        c01 = @background[top][(left+1)%@bw]
        c10 = @background[(top+1)%@bh][left]
        c11 = @background[(top+1)%@bh][(left+1)%@bw]
        return build(c00,c01,c10,c11)
      end
      stride = 2**(level-1)
      e00 = empty(level-1,left,top)
      e01 = empty(level-1,left+stride,top)
      e10 = empty(level-1,left,top+stride)
      e11 = empty(level-1,left+stride,top+stride)
      build(e00,e01,e10,e11)
    end
  end

  # advance the root node by _n_ simulation steps.
  # n can be any value, it's not limited to a power of 2.
  def step(n=1, explain:false)
    while n > 0
      hyper_level = @root.level
      hyper_level -= 1 while hyper_level > 3 && n < 2**(hyper_level-2)
      if hyper_level > 3
        puts "running hyper at level #{hyper_level}" if explain
        @root = expand.evolve(hyper_level)
        n -= 2**(hyper_level-2)
        puts "n is now #{n}" if explain
      else
        puts "remainder #{n} running slowly" if explain
        n.times { @root = expand.evolve(0); n -=1 }
      end
    end
    @root
  end
end

# Node in the quad tree. Node width and height is 2**level.
class Node
  def initialize(hl, nw, ne, sw, se)
    @hl = hl
    @level = nw.is_a?(Array) ? 2 : nw.is_a?(Integer) ? 1 : nw.level+1
    @count = @level == 1 ? [nw,ne,sw,se].count(1) : [nw,ne,sw,se].sum(&:count)
    @nw, @ne, @sw, @se = nw, ne, sw, se
    @results = {}
  end
  attr_reader :level, :nw, :ne, :sw, :se, :count

  def build(*) = @hl.build(*)

  def center
    @center ||= build(@nw.se, @ne.sw, @sw.ne, @se.nw)
  end

  # returns a new node based on this node with specified quadrants overwritten
  def replace(newvals)
    qs = newvals.zip([@nw, @ne, @sw, @se]).map { _1 || _2 }
    build(*qs)
  end

  # Core of the simulation. Step this node forward.
  # _hyper_ is the level at which we want to step forward 2**(level-2) steps.
  # Above that level, we step forward just 1 step.
  # Pass 0 for hyper to step forward just 1 step in total.
  def evolve(hyper)
    do_hyper = hyper >= level
    @results[hyper] ||= if @level == 2
      build(
        @nw.se == 2 ? 2 : ([@nw.ne,@nw.sw,@ne.sw,@sw.ne].any?(1) ? 1 : 0),
        @ne.sw == 2 ? 2 : ([@ne.nw,@ne.se,@nw.se,@se.nw].any?(1) ? 1 : 0),
        @sw.ne == 2 ? 2 : ([@sw.nw,@sw.se,@nw.se,@se.nw].any?(1) ? 1 : 0),
        @se.nw == 2 ? 2 : ([@sw.ne,@ne.sw,@se.ne,@se.sw].any?(1) ? 1 : 0),
      )
    elsif @level > 2
      n00 = @nw.evolve(hyper)
      n01 = build(@nw.ne, @ne.nw, @nw.se, @ne.sw).evolve(hyper)
      n02 = @ne.evolve(hyper)
      n10 = build(@nw.sw, @nw.se, @sw.nw, @sw.ne).evolve(hyper)
      n11 = build(@nw.se, @ne.sw, @sw.ne, @se.nw).evolve(hyper)
      n12 = build(@ne.sw, @ne.se, @se.nw, @se.ne).evolve(hyper)
      n20 = @sw.evolve(hyper)
      n21 = build(@sw.ne, @se.nw, @sw.se, @se.sw).evolve(hyper)
      n22 = @se.evolve(hyper)
      if do_hyper
        build(
          build(n00, n01, n10, n11).evolve(hyper),
          build(n01, n02, n11, n12).evolve(hyper),
          build(n10, n11, n20, n21).evolve(hyper),
          build(n11, n12, n21, n22).evolve(hyper),
        )
      else
        build(
          build(n00, n01, n10, n11).center,
          build(n01, n02, n11, n12).center,
          build(n10, n11, n20, n21).center,
          build(n11, n12, n21, n22).center,
        )
      end
    else
      raise "can't result on level #@level"
    end
  end

  def to_a
    if @level == 1
      [@nw,@ne,@sw,@se]
    else
      raise "to_a not implemented for level #@level"
    end
  end

  # returns a string representation of the current grid state
  # this is not remotely optimized for large grids, it's really
  # just for debugging on small states right now
  def show
    sz = 2**@level
    res = sz.times.map { "#" * sz }
    showsub(0, 0, res)
    res.join("\n")
  end

  def showsub(x, y, outp)
    if @level == 1
      outp[y][x] = STATES[@nw]
      outp[y][x+1] = STATES[@ne]
      outp[y+1][x] = STATES[@sw]
      outp[y+1][x+1] = STATES[@se]
    else
      d = (2**@level)/2
      @nw.showsub(x, y, outp)
      @ne.showsub(x+d, y, outp)
      @sw.showsub(x, y+d, outp)
      @se.showsub(x+d, y+d, outp)
    end
  end
end

def find_start(fname)
  File.readlines(fname).each_with_index { |l,y| l.chars.each_with_index { |c,x|
    return [x,y] if c == 'S'
  } }
end

def part2_hashlife
  bg_path = File.join(__dir__, 'full.txt')
  left, top = find_start(bg_path)
  hl = HashLife.new(bg_path)
  hl.mkroot(left, top)
  hl.root = hl.root.replace([1, nil, nil, nil])

  goal = 26501365
  required_level = Math.log2(goal).ceil+1
  hl.expand(required_level - hl.root.level)
  puts "level #{hl.root.level} left #{hl.left} top #{hl.top}"
  puts "cache size: #{hl.cache.size}"
  hl.step(goal,explain:true)
  puts
  # correct answer for my input is 627960775905777
  puts "#{hl.root.level}@#{goal}: #{hl.root.count}"
  puts "cache size: #{hl.cache.size}"
end
part2_hashlife
