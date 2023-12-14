require_relative '../utils'

class Grid
  include Enumerable

  attr_reader :width, :height, :data

  def initialize(width, height, data=nil, seed: nil)
    @width = width
    @height = height
    n = width*height
    raise("bad input length: #{data.length}") if data && data.length != n
    data = seed*n if seed
    @data = data || Array.new(n)
  end

  def self.from_input(input)
    input = input.lines.map(&:chomp)
    new(input.first.size, input.size, input.join)
  end

  def dup
    Grid.new width, height, data.dup
  end

  # returns a Rect covering the entire grid
  def all = self[0..,0..]
  def each(&) = all.each(&)
  def rows(&) = all.rows(&)
  def cols(&) = all.cols(&)

  def[](x,y)
    if Range === x
      x = Range.new(0, x.end, x.exclude_end?) if x.begin.nil?
      x = (x.begin...@width) if x.end.nil?
      y = (y..y) if Integer === y
    end
    if Range === y
      y = Range.new(0, y.end, y.exclude_end?) if y.begin.nil?
      y = (y.begin...@height) if y.end.nil?
      x = (x..x) if Integer === x
    end
    if Integer === x
      at(x,y)&.get
    else
      Rect.new(self, x, y)
    end
  end

  def in_bounds?(x,y)
    x >= 0 && y >= 0 && x < @width && y < @height
  end

  def at(x,y)
    return nil unless in_bounds?(x,y)
    Cell.new(self, x, y, x+y*@width)
  end

  def inspect
    "#<Grid #{width}x#{height}>"
  end

  def to_s = all.to_s

  def rotate_cw
    data = cols.map{_1.get.reverse}.join
    Grid.new(height, width, data)
  end

  Rect = Data.define(:grid, :xrange, :yrange) do
    include Enumerable

    def each
      return to_enum(__method__) unless block_given?
      yrange.each { |y| xrange.each { |x| yield grid.at(x, y) } }
    end

    def rows
      yrange.map { |y| grid[xrange,y] }
    end

    def cols
      xrange.map { |x| grid[x,yrange] }
    end

    def get
      map(&:get)
    end

    def to_s
      lasty = nil
      map { |c|
        nl=lasty&&lasty!=c.y&&"\n"
        lasty = c.y
        "#{nl||''}#{c.get || '⌀'}"
      }.join
    end
  end

  Cell = Data.define(:grid, :x, :y, :pos) do
    def get
      grid.data[pos]
    end

    def set(val)
      grid.data[pos] = val
      self
    end

    def relative(x2, y2)
      grid.at(x+x2, y+y2)
    end

    def l = relative(-1,  0)
    def r = relative( 1,  0)
    def u = relative( 0, -1)
    def d = relative( 0,  1)

    def neighbors
      return to_enum(__method__) unless block_given?
      yield l unless x == 0
      yield r unless x+1 == grid.width
      yield u unless y == 0
      yield d unless y+1 == grid.height
    end
  end
end

assert_eq Grid.new(3,3,'123456789').map(&:get), '123456789'.split(//)
assert_eq Grid.new(3,3,'123456789').rows.map(&:get), [%w[1 2 3], %w[4 5 6], %w[7 8 9]]
assert_eq Grid.new(3,3,'123456789').cols.map(&:get), [%w[1 4 7], %w[2 5 8], %w[3 6 9]]
assert_eq Grid.new(4,4,'0123456789ABCDEF')[1..2,1..2].rows.map(&:get), [%w[5 6], %w[9 A]]
assert_eq Grid.new(4,4,'0123456789ABCDEF')[1..2,1..2].cols.map(&:get), [%w[5 9], %w[6 A]]

assert_eq Grid.new(3,4,'100010001000').rotate_cw.data, '000100100100'
