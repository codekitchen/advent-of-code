#!/usr/bin/env ruby
require_relative '../utils'

class Grid
  include Enumerable

  attr_reader :xrange, :yrange

  # args for new Grid: width, height, raw_data
  # args for view on existing Grid: xrange, yrange, grid_data
  def initialize(w, h, data=nil, seed: nil)
    if Range === w && Range === h && GridData === data
      @xrange = w
      @yrange = h
      @data = data
      raise "bad range: #{@xrange}" if @xrange.begin < 0 || @xrange.max >= @data.width
      raise "bad range: #{@yrange}" if @yrange.begin < 0 || @yrange.max >= @data.height
    elsif Integer === w && Integer === h
      @xrange = 0...w
      @yrange = 0...h
      @data = GridData.new(width: w, height: h, data: data, seed:)
    else
      raise "bad Grid construction: #{[w,h,data].inspect}"
    end
  end

  def initialize_copy(*)
    super
    @data = GridData.new(width: @data.width, height: @data.height, data: @data.data.dup)
  end

  def self.from_input(input, &mapper)
    input = input.lines.map(&:chomp)
    data = input.join
    data = data.chars.map!(&mapper) if mapper
    new(input.first.size, input.size, data)
  end

  def width  = xrange.size
  def height = yrange.size
  def hash = [xrange, yrange, @data].hash
  def ==(o)
    Grid === o &&
      xrange == o.xrange &&
      yrange == o.yrange &&
      @data == o.instance_variable_get(:@data)
  end
  alias :eql? :==
  def raw_data = @data.data

  def each
    return to_enum(__method__) unless block_given?
    @yrange.each { |y| @xrange.each { |x| yield @data.data[x+y*@data.width] } }
  end

  def [](*)
    x,y = resolve_pos(*)
    if Integer === x
      @data.at(x,y)&.get
    else
      self.class.new(x, y, @data)
    end
  end
  def []=(x,y,val)
    # x,y = resolve_pos(*args)
    if Integer === x && Integer === y
      # @data.at(x,y).set(val)
      @data.data[x+y*width] = val
    else
      raise "cannot Grid[range,range]=val but how nice would that be"
    end
  end
  def at(x,y)
    @data.at(*resolve_pos(x,y))
  end

  def norm(x,y)
    [x%width,y%height]
  end

  def resolve_pos(*args)
    case args
    in [Range=>x,y]
      x = Range.new(xrange.begin, x.end, x.exclude_end?) if x.begin.nil?
      x = Range.new(x.begin, xrange.end, xrange.exclude_end?) if x.end.nil?
      y = (y..y) if Integer === y
    in [x,Range=>y]
      y = Range.new(yrange.begin, y.end, y.exclude_end?) if y.begin.nil?
      y = Range.new(y.begin, yrange.end, yrange.exclude_end?) if y.end.nil?
      x = (x..x) if Integer === x
    in [Integer=>x, Integer=>y]
      x += xrange.begin
      y += yrange.begin
    in [Integer=>d1] if xrange.size == 1
      x = xrange.begin
      y = yrange.begin+d1
    in [Integer=>d1] if yrange.size == 1
      x = xrange.begin+d1
      y = yrange.begin
    else
      raise "Ambiguous indexing for #{self.inspect}: #{args.inspect}"
    end
    [x,y]
  end

  def cells
    return to_enum(__method__) unless block_given?
    @yrange.each { |y| @xrange.each { |x| yield @data.at(x,y) } }
  end

  def each_row
    return to_enum(__method__) unless block_given?
    yrange.each { |y| yield self[xrange,y] }
  end
  def rows = each_row.to_a

  def each_col
    return to_enum(__method__) unless block_given?
    xrange.map { |x| yield self[x,yrange] }
  end
  def cols = each_col.to_a

  def rotate_cw
    data = cols.map{_1.to_a.reverse}.join
    self.class.new(height, width, data)
  end

  def to_s
    lasty = nil
    cells.map { |c|
      nl=lasty&&lasty!=c.y&&"\n"
      lasty = c.y
      "#{nl||''}#{c.get || '⌀'}"
    }.join
  end

  class GridData
    attr_reader :width, :height, :data

    def initialize(width:, height:, data: nil, seed: nil)
      @width = width
      @height = height
      n = width*height
      raise("bad input length: #{data.length}") if data && data.length != n
      @data = data || Array.new(n, seed)
    end

    def in_bounds?(x,y)
      x >= 0 && y >= 0 && x < width && y < height
    end

    def at(x,y)
      return nil unless in_bounds?(x,y)
      Cell.new(self, x, y, x+y*width)
    end

    def inspect
      "#<GridData #{width}x#{height}>"
    end

    def hash = [width, height, data].hash
    def ==(o)
      width == o.width && height == o.height && data == o.data
    end
  end

  Cell = Data.define(:grid_data, :x, :y, :pos) do
    def get
      grid_data.data[pos]
    end

    def set(val)
      grid_data.data[pos] = val
      self
    end

    def relative(x2, y2, wrap=false)
      x2 += x
      y2 += y
      if wrap
        x2 %= grid_data.width
        y2 %= grid_data.height
      end
      return unless x2>=0 && y2>=0 && x2<grid_data.width && y2<grid_data.height
      Cell.new(grid_data, x2, y2, x2+y2*grid_data.width)
    end

    def l = relative(-1,  0)
    def r = relative( 1,  0)
    def u = relative( 0, -1)
    def d = relative( 0,  1)

    def neighbors
      return to_enum(__method__) unless block_given?
      yield l unless x == 0
      yield r unless x+1 == grid_data.width
      yield u unless y == 0
      yield d unless y+1 == grid_data.height
    end

    def neighbors_wrap
      yield relative(-1,0,true)
      yield relative(1,0,true)
      yield relative(0,-1,true)
      yield relative(0,1,true)
    end

    def inspect = "#<Grid::Cell [#{x},#{y}]>"

    def hash = [pos, grid_data.object_id].hash
    def eql?(o) = [pos,grid_data.object_id] == [o.pos,o.grid_data.object_id]
    def ==(o)
      if o.is_a?(Cell)
        [pos,grid_data.object_id] == [o.pos,o.grid_data.object_id]
      else
        get == o
      end
    end
  end
end

if __FILE__ == $0
  puts "running Grid tests"
  g = Grid.new(3,3,'123456789')
  assert_eq g.to_a, '123456789'.split(//)
  assert_eq g.rows.map(&:to_a), [%w[1 2 3], %w[4 5 6], %w[7 8 9]]
  assert_eq g.cols.map(&:to_a), [%w[1 4 7], %w[2 5 8], %w[3 6 9]]
  assert_eq Grid.new(4,4,'0123456789ABCDEF')[1..2,1..2].rows.map(&:to_a), [%w[5 6], %w[9 A]]
  assert_eq Grid.new(4,4,'0123456789ABCDEF')[1..2,1..2].cols.map(&:to_a), [%w[5 9], %w[6 A]]

  assert_eq Grid.new(3,4,'100010001000').rotate_cw.raw_data, '000100100100'

  assert_neq g.raw_data.object_id, g.dup.raw_data.object_id
  copy = g.dup
  copy[1,1] = 'A'
  assert_eq g.raw_data, '123456789'
  assert_eq copy.raw_data, '1234A6789'
end
