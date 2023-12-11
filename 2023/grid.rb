class Grid
  include Enumerable

  attr_reader :cols, :rows, :data

  def initialize(cols, rows, data=nil, seed: nil)
    @cols = cols
    @rows = rows
    n = rows*cols
    raise("bad input length: #{data.length}") if data && data.length != n
    data = seed*n if seed
    @data = data || Array.new(n)
  end

  def self.from_input(input)
    input = input.lines.map(&:chomp)
    new(input.first.size, input.size, input.join)
  end

  def each(&)
    self[0..,0..].each(&)
  end

  def[](x,y)
    if Range === x
      x = Range.new(0, x.end, x.exclude_end?) if x.begin.nil?
      x = (x.begin...@cols) if x.end.nil?
      y = (y..y) if Integer === y
    end
    if Range === y
      y = Range.new(0, y.end, y.exclude_end?) if y.begin.nil?
      y = (y.begin...@rows) if y.end.nil?
      x = (x..x) if Integer === x
    end
    if Integer === x
      at(x,y)&.get
    else
      Rect.new(self, x, y)
    end
  end

  def at(x,y)
    return nil if x < 0 || y < 0 || x >= cols || y >= rows
    Cell.new(self, x, y, x+y*@cols)
  end

  def inspect
    "#<Grid #{cols}x#{rows}>"
  end

  def to_s
    self[0..,0..].to_s
  end

  Rect = Data.define(:grid, :xrange, :yrange) do
    include Enumerable
    def each
      yrange.each { |y| xrange.each { |x| yield grid.at(x, y) } }
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
      yield r unless x+1 == grid.cols
      yield u unless y == 0
      yield d unless y+1 == grid.rows
    end
  end
end
